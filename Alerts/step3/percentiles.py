# coding=utf-8
#se importan bibliotecas necesarias para leer los datos
import sys
import os
import re
import time
import numpy as np
from netCDF4 import Dataset
from datetime import datetime
from datetime import timedelta
from scipy import interpolate
import gc


#constantes de archivo
TOKENFILE = "/"
MONTHS = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"]
#constantes para T2
T2VARS = ["T2_10", "T2_5", "T2_1", "T2_95", "T2_99", "T2_99_9"]
T2VALUES = [-1, -2, -3, 1, 2, 3]#el orden si importa
#constantes para viento
WINVARS = ["VIENTO_10", "VIENTO_5", "VIENTO_1", "VIENTO_95", "VIENTO_99", "VIENTO_99_9"]
WINVALUES = [0, 0, 0, 1, 2, 3]#el orden si importa
#constantes para precipitacion
PRECVARS = ["PREC_10", "PREC_5", "PREC_1", "PREC_95", "PREC_99", "PREC_99_9"]#verificar
PRECVALUES = [0, 0, 0, 1, 2, 3]#el orden si importa
#constantes para tiempo
FORMAT = "%Y-%m-%d"
CALENDAR = "gregorian"
SINCE = "hours since 2017-11-26 00:00:00"
#dimenciones de latitud y longitus
DIMLAT = 262
DIMLON = 338
DIMLAT_2 = 156
DIMLON_2 = 273
DIMTIME = 121

#obtine los archivos por dia
def get_file_day(dom, path):
    if dom != 1:
        dom = 2
    today = datetime.today()
    year = today.year
    mount = today.month
    nfile = path + TOKENFILE + str(year) + TOKENFILE + str(mount) \
            + "_" + MONTHS[mount - 1]  + TOKENFILE + "wrfout_d0" \
            + str(dom) + "_" + today.strftime(FORMAT) + "_00.nc"#direccion del archivo path/año/mesEntero_mesCadena/wrfout_d0(dominio 1 o 2)_(año_mes_dia)_00.nc
    if not os.path.isfile(nfile):
        raise IOError("forecast file not found ", nfile)
    print("Forecast file: " + nfile)
    return Dataset(nfile, "r", format="NETCDF4")

def get_file_percentiles(pvars, dom, path):
    per = {}
    if dom != 1:
        dom = 2
    nfile = path + TOKENFILE + "Percentil_Dom" + str(dom) \
            + "_" + datetime.today().strftime(FORMAT) + ".nc"#path/Percentil_Dom(dominio 1 o 2)_(año_mes_dia).nc
    if not os.path.isfile(nfile):
        raise IOError("percentiles file not found ", nfile)
    print("percentiles file: " + nfile)
    gsfFile = Dataset(nfile , "r", format="NETCDF4")
    for var in pvars:
        per[var] = get_var_netcdf(var, gsfFile)
    return per

#obtiene una variable del archivo netcdf
def get_var_netcdf(nameVar, netCDF):
    if nameVar in netCDF.variables:
    	return np.copy(netCDF.variables.get(nameVar))
    else:
    	print("variable not found: " + nameVar)

#obtiene los valores de alerta segun la variable
def alert_values(forecast, percentiles, percentilesValues):
    aler = np.zeros(forecast.shape, dtype=int)
    k = 0
    for dayforecast in forecast:#itera sobre las horas
        i = 0
        for ky in percentiles.keys():#sobre los percentiles
            percentil = percentiles[ky]
            if(len(percentil.shape) == (len(dayforecast.shape) + 1)):
                percentil = percentil[0]
            if(percentilesValues[i] < 0):
                aler[k][dayforecast < percentil] = percentilesValues[i]
            else:
                aler[k][percentil < dayforecast] = percentilesValues[i]
            i += 1
        k += 1
    return aler

#crea un archivo netCDF
def create_netcdf_file(name, varsNCDF, dimensions, ow=None):
    if os.path.isfile(name) and not(ow is None):
        gsfFile = Dataset(name + ".nc", "r+", format="NETCDF4")
    else:
        gsfFile = Dataset(name, "w", format="NETCDF4")
    ##Se crean las dimensiones##
    varCreate = {}
    varDims = {}
    #primero se crean las dimensiones
    for dim in dimensions.keys():
        varDims[dim] = gsfFile.createDimension(dim, dimensions[dim]["size"])
    for var in varsNCDF.keys():
        varCreate[var] = gsfFile.createVariable(var, varsNCDF[var]["type"], varsNCDF[var]["depends"], varsNCDF[var]["fill"])
        print(var, " tam ", varsNCDF[var]["value"].shape)
        varCreate[var][:] = varsNCDF[var]["value"]
        for att in varsNCDF[var]["attributes"].keys():
            setattr(varCreate[var], att, varsNCDF[var]["attributes"][att])
    #se cierra el archivo
    gsfFile.conventions = "CF-1.6"
    gsfFile.description = "Made at UNAM, at Center of Atmospheric Sciences. Conctact: Olmo Zavala";
    gsfFile.close()
    del varCreate
    del varDims
    gc.collect()
    print("Close file")
    
#obtiene los valores de las variables de longitud y Latitud
def netcdf_var_latlon(dom, lat, lon, fillLat=None, fillLon=None):
    net = {}
    if dom != 1:
        dom = 2
    net["Latitude"] = {"type" : "f4",
                       "depends" : ("Latitude",), 
                       "value" : lat, 
                       "fill": fillLat, 
                       "attributes" : {"units": "degrees_north", 
                                       "long_name": "Latitude", 
                                       "standard_name": "Latitude"}}
    net["Longitude"] = {"type" : "f4", 
                        "depends" : ("Longitude",), 
                        "value" : lon, "fill": fillLon, 
                        "attributes" : {"units": "degrees_east", 
                                        "long_name": "Longitude", 
                                        "standard_name": "longitude"}}
    return net

#obtiene la dimencion de las variables latitud y longitudlatlong
def netcdf_dim_latlon(dom, lat=DIMLAT, lon=DIMLON):
    if dom != 1:
        lat = DIMLAT_2
        lon = DIMLON_2
    return {"Latitude": {"size": lat}, "Longitude": {"size": lon}}

#obtiene la variable tiempo
def netCDFVarTime(time, since=SINCE, calendar=CALENDAR, fill=None):
    return {"Time" : {"type" : "f4",
                      "depends" : ("Time",),
                      "value" : time, "fill": fill,
                      "attributes" : {"axis": "T",
                                      "units": "hours since " + since, 
                                      "calendar": calendar, 
                                      "long_name": "Time", 
                                      "standard_name": "time"}},
            "OTime" : {"type" : "f4", 
                       "depends" : ("OTime",), 
                       "value" : np.array([1]), 
                       "fill": fill, 
                       "attributes" : {"units": "hours since " + since, 
                                       "calendar": calendar, 
                                       "long_name": "Time", 
                                       "standard_name": "time"}}}

#obtiene la dimencion de la variable tiempo
def netcdf_dim_time(time=None):
    return {"Time": {"size": time},
            "OTime" : {"size": None}}

#crea una variable T2 con los valores -1,-2,-3,1,2,3, dependiendo si pasa algun percentil
def netcdf_var_t2(value, value2, fill=None):
    return {"T2" : {"type" : "i4", 
                    "depends" : ("Time", "Latitude", "Longitude", ), 
                    "value" : value, 
                    "fill": fill, 
                    "attributes" : {"units": "C", 
                                    "descripcion": "TEMP at 2M", 
                                    "long_name": "TEMP a 2M", 
                                    "standard_name": "TEMP a 2M"}}, 
            "T2A" : {"type" : "i4", 
                     "depends" : ("OTime", "Latitude", "Longitude", ), 
                     "value" : value2, 
                     "fill": fill,
                     "attributes" : {"units": "C", 
                                     "descripcion": "TEMP at 2M", 
                                     "long_name": "TEMP a 2M", 
                                     "standard_name": "TEMP a 2M"}}}

#crea una variable VIENTO con los valores 0,0,0,1,2,3, dependiendo si pasa algun percentil
def netcdf_var_win(value, value2, fill=None):
    return {"VIENTO" : {"type" : "i4", 
                        "depends" : ("Time", "Latitude", "Longitude", ), 
                        "value" : value, 
                        "fill": fill, 
                        "attributes" : {"units": "m s-1", 
                                        "descripcion": "Magnitud del viento", 
                                        "long_name": "Magnitud del viento", 
                                        "standard_name": "Magnitud del viento"}},
            "VIENTOA" : {"type" : "i4", 
                         "depends" : ("OTime", "Latitude", "Longitude", ), 
                         "value" : value2, 
                         "fill": fill, 
                         "attributes" : {"units": "m s-1", 
                                         "descripcion": "Magnitud del viento", 
                                         "long_name": "Magnitud del viento", 
                                         "standard_name": "Magnitud del viento"}}}

#crea una variable PREC con los valores 0,0,0,1,2,3, dependiendo si pasa algun percentil
def netcdf_var_prec(value, value2, fill=None):
    return {"PREC" : {"type" : "i4", 
                      "depends" : ("Time", "Latitude", "Longitude", ), 
                      "value" : value, 
                      "fill": fill, 
                      "attributes" : {"units": "%", 
                                      "descripcion": "Precipitacion", 
                                      "long_name": "Precipitacion", 
                                      "standard_name": "Precipitacion"}}, 
            "PRECA" : {"type" : "i4", 
                       "depends" : ("OTime", "Latitude", "Longitude", ), 
                       "value" : value2, 
                       "fill": fill, 
                       "attributes" : {"units": "%", 
                                       "descripcion": "Precipitacion", 
                                       "long_name": "Precipitacion", 
                                       "standard_name": "Precipitacion"}}}


def netcdf_dim(netcdf, name, size=None):
    netcdf.createDimension(name, size)

#se definen una funcion
def netcdf_var(netcdf, name, typ, depends, value, attributes, fill=None):
    var = netcdf.createVariable(name, typ, depends, fill)
    var[:] = value
    for att in attributes.keys():
        setattr(var, att, attributes[att])
    

#crea las alertas para temperatura
def alert_t2(spath, dom, fpath, ppath):
    netcdf = get_file_day(dom, fpath)
    forecast = get_var_netcdf("T2", netcdf) - 273.15#se cambia de grados kelvin a celcius
    #percentiles = get_file_percentiles(T2VARS, dom, ppath)
    percentiles = estep2(ppath, T2VARS, get_var_netcdf("XLAT", netcdf)[0,::,0], get_var_netcdf("XLONG", netcdf)[0][0,:], "T2_dom" + str(dom))
    alert = alert_values(forecast, percentiles, T2VALUES)
    var = {}
    var.update(netCDFVarTime(np.arange(121), datetime.today().strftime(FORMAT) + " 00:00:00"))
    var.update(netcdf_var_latlon(dom, get_var_netcdf("XLAT", netcdf)[0,::,0], get_var_netcdf("XLONG", netcdf)[0][0,:]))
    var.update(netcdf_var_t2(alert, np.array([np.amax(alert, axis=0)])))
    dim = {}
    dim.update(netcdf_dim_latlon(dom))
    dim.update(netcdf_dim_time())
    create_netcdf_file(spath + "T2_dom" + str(dom) + "_" + datetime.today().strftime(FORMAT) + ".nc", var, dim)

#crea las alertas para viento
def alert_wind(spath, dom, fpath, ppath):
    netcdf = get_file_day(dom, fpath)
    U10 = get_var_netcdf("U10", netcdf)
    V10 = get_var_netcdf("V10", netcdf)
    forecast = np.sqrt(np.power(U10, 2) + np.power(V10, 2))
    #percentiles = get_file_percentiles(WINVARS, dom, ppath)
    percentiles = estep2(ppath, WINVARS, get_var_netcdf("XLAT", netcdf)[0,::,0], get_var_netcdf("XLONG", netcdf)[0][0,:], "VIENTO_dom" + str(dom))
    alert = alert_values(forecast, percentiles, WINVALUES)
    var = {}
    var.update(netCDFVarTime(np.arange(121), datetime.today().strftime(FORMAT) + " 00:00:00"))
    var.update(netcdf_var_latlon(dom, get_var_netcdf("XLAT", netcdf)[0,::,0], get_var_netcdf("XLONG", netcdf)[0][0,:]))
    var.update(netcdf_var_win(alert, np.array([np.amax(alert, axis=0)])))
    dim = {}
    dim.update(netcdf_dim_latlon(dom))
    dim.update(netcdf_dim_time())
    create_netcdf_file(spath + "VIENTO_dom" + str(dom) + "_" +  datetime.today().strftime(FORMAT) + ".nc", var, dim)


#funcion que ajusta los puntos interpolando los os.listdir(path + sYear)dados por raul 
def estep2(path, pvars,  lat, lon, name):
    if not os.path.isfile(path):
        raise IOError("main percentiles file not found ", path)
    netcdf = Dataset(path, "r", format="NETCDF4")
    wnetcdf = Dataset("aux_" + name + ".nc", "w", format="NETCDF4")
    netcdf_dim(wnetcdf, "Latitude", lat.shape[0])
    netcdf_var(wnetcdf, "Latitude", "f4", ("Latitude",), lat, {})
    netcdf_dim(wnetcdf, "Longitude", lon.shape[0])
    netcdf_var(wnetcdf, "Longitude", "f4", ("Longitude", ), lon, {})
    netcdf_dim(wnetcdf, "Time")
    netcdf_var(wnetcdf, "Time", "f4", ("Time", ), np.array([1]), {})
    data = {}
    x = get_var_netcdf("Latitude", netcdf)
    y = get_var_netcdf("Longitude", netcdf)
    print("lat: " + str(x.shape) + " lon: " + str(y.shape))
    print("nlat: " + str(lat.shape) + " nlon: " + str(lon.shape))
    for var in pvars:
        vvar = get_var_netcdf(var, netcdf)
        f = interpolate.interp2d(x, y, np.transpose(vvar), kind='linear')
        data[var] = np.transpose(f(lat, lon))
        print(data[var].shape)
        netcdf_var(wnetcdf, var, "f4", ("Time", "Latitude", "Longitude", ), np.array([data[var]]), {})
    netcdf.close()
    wnetcdf.close()
    return data

def copy(fFile, target, sFile=None):
    dsinf = Dataset(fFile, "r", format="NETCDF4")
    if not sFile is None:
        dsins = Dataset(sFile, "r", format="NETCDF4")
    dsout = Dataset(target, "w", format="NETCDF4")
    for dname, the_dim in dsinf.dimensions.iteritems():
        print(dname + " dim  " + str(len(the_dim)))
        dsout.createDimension(dname, len(the_dim) if not the_dim.isunlimited() else None)
    for v_name, varin in dsinf.variables.iteritems():
        outVar = dsout.createVariable(v_name, varin.datatype, varin.dimensions)
        print(varin.datatype)
        outVar.setncatts({k: varin.getncattr(k) for k in varin.ncattrs()})
        outVar[:] = varin[:]
    if not sFile is None:
        for dname, the_dim in dsins.dimensions.iteritems():
            print(dname + " dim  " + str(len(the_dim)))
            if not dname in dsinf.dimensions.iteritems():
                dsout.createDimension(dname, len(the_dim) if not the_dim.isunlimited() else None)
        for v_name, varin in dsins.variables.iteritems():
            if not v_name in dsinf.variables.iteritems():
                outVar = dsout.createVariable(v_name, varin.datatype, varin.dimensions)
                print(varin.datatype)
                outVar.setncatts({k: varin.getncattr(k) for k in varin.ncattrs()})
                outVar[:] = varin[:]
    dsout.close()

#elimina los archivos que se crearon un dia anterior
def remove(path):
    if path == "":
        path = os.getcwd()
        print(path)
    files = os.listdir(path)
    yesterday = datetime.today() - timedelta(days=1)
    ystr = yesterday.strftime(FORMAT)
    for filen in files:
        if re.search(ystr + ".nc", filen):
            print("archivo a eliminar: ", filen)
            os.remove(path + TOKENFILE + filen)

#funcion principal
def main(argv):
    if len(argv) > 3:
        #archivo donde se guarda el archivo(spath), ruta donde se encuentra el archivo de pronostico(fpath), ruta donde se encuentra el archivo de percentiles, respectivamente(ppath)
        #argv[1], argv[2], argv[3]
        remove(argv[1])
        alert_t2(argv[1], 1, argv[2], argv[3])#para el dominio 1
        alert_t2(argv[1], 2, argv[2], argv[3])#para el dominio 2
        alert_wind(argv[1], 1, argv[2], argv[3])#para el dominio 1
        alert_wind(argv[1], 2, argv[2], argv[3])#para el dominio 2

if __name__ == "__main__":
    main(sys.argv)
