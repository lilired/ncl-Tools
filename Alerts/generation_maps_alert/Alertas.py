# coding=utf-8
#se importan bibliotecas necesarias para leer los datos
import sys
import os
import re
import time
import gc
from netCDF4 import Dataset
from datetime import datetime
from datetime import timedelta
import numpy as np
from scipy import interpolate


#constantes de archivo
TOKENFILE = "/"
MONTHS = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"]
#constantes para T2
T2VARS = ["T2_5", "T2_1", "T2_0_1", "T2_95", "T2_99", "T2_99_9"]#el orden si importa
T2VALUES = [5, 1, 0.1, 95, 99, 99.9]#el orden si importa
#constantes para viento
WINVARS = ["VIENTO_5", "VIENTO_1", "VIENTO_0_1", "VIENTO_95", "VIENTO_99", "VIENTO_99_9"]#el orden si importa
WINVALUES = [50, 50, 50, 95, 99, 99.9]#el orden si importa
#constantes para precipitacion
PRECVARS = ["PREC_5", "PREC_1", "PREC_0_1", "PREC_95", "PREC_99", "PREC_99_9"]#verificar
PRECVALUES = [50, 50, 50, 95, 99, 99.9]#el orden si importa
#constantes para el tiempo
FORMAT = "%Y-%m-%d"
CALENDAR = "gregorian"
SINCE = "hours since 2017-11-26 00:00:00"#si no se especifica una esta se ocupa por omision
#dimenciones de latitud y longitud
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
    smount = str(mount)
    if mount < 10:
        smount = "0" + smount
    nfile = path + TOKENFILE + str(year) + TOKENFILE + smount \
            + "_" + MONTHS[mount - 1]  + TOKENFILE + "wrfout_d0" \
            + str(dom) + "_" + today.strftime(FORMAT) + "_00.nc"#direccion del archivo path/año/mesEntero_mesCadena/wrfout_d0(dominio 1 o 2)_(año_mes_dia)_00.nc
    if not os.path.isfile(nfile):
        raise IOError("forecast file not found ", nfile)
    print("Forecast file: " + nfile)
    return Dataset(nfile, "r", format="NETCDF4")

#obtine el archivo de percentiles
def get_file_percentiles(pvars, dom, path):
    per = {}
    if dom != 1:
        dom = 2
    #nfile = path + TOKENFILE + "Percentil_Dom" + str(dom) \
    #        + "_" + datetime.today().strftime(FORMAT) + ".nc"#path/Percentil_Dom(dominio 1 o 2)_(año_mes_dia).nc
    nfile = path + TOKENFILE + "Percentil_Dom" + str(dom) + ".nc"
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
    raise ValueError("variable not found: " + nameVar)

#obtiene los valores de alerta segun la variable
def alert_values(forecast, percentiles, percentilesValues):
    aler = np.empty(forecast.shape)
    aler.fill(50)
    k = 0
    for dayforecast in forecast:#itera sobre las horas
        i = 0
        for ky in percentiles.keys():#sobre los percentiles
            percentil = percentiles[ky]
            if(len(percentil.shape) == (len(dayforecast.shape) + 1)):
                percentil = percentil[0]
            if(percentilesValues[i] < 50):
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
    
#crea los valores de las variables de longitud y Latitud para el formato netcdf
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



 ["T2_5", "T2_1", "T2_0_1", "T2_95", "T2_99", "T2_99_9"
PYTHON="/usr/local/anaconda/bin/python"
ROOT="/home/vladimir/CENAPRED/Alertas"
PERCENTILES="Alertas.py"


#archivo donde se encuentran los percentiles
PER_FILE="/ServerData/OutTempRaul/percentil/Percentiles.nc"
#archivo donde se encuentran los pronosticos
FCT_FILE="/ServerData/Pronosticos/Salidas/WRF"
#archivo de salida
OUT=""


#crea la dimencion de las variables latitud y longitud para el formato netcdf
def netcdf_dim_latlon(dom, lat=DIMLAT, lon=DIMLON):
    if dom != 1:
        lat = DIMLAT_2
        lon = DIMLON_2
    return {"Latitude": {"size": lat}, "Longitude": {"size": lon}}

#crea la variable tiempo para el formato netcdf
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

#crea la dimencion de la variable tiempo para el formato netcdf
def netcdf_dim_time(time=None):
    return {"Time": {"size": time},
            "OTime" : {"size": None}}

#crea una variable T2 con los valores -1,-2,-3,1,2,3, dependiendo si sobrepasa o esta por debajo de algun percentil
def netcdf_var_t2(value, value2, fill=None):
    return {"T2" : {"type" : "f4", 
                    "depends" : ("Time", "Latitude", "Longitude", ), 
                    "value" : value, 
                    "fill": fill, 
                    "attributes" : {"units": "%", 
                                    "descripcion": "TEMP at 2M", 
                                    "long_name": "TEMP a 2M", 
                                    "standard_name": "TEMP a 2M"}}, 
            "T2A" : {"type" : "f4", 
                     "depends" : ("OTime", "Latitude", "Longitude", ), 
                     "value" : value2, 
                     "fill": fill,
                     "attributes" : {"units": "%", 
                                     "descripcion": "TEMP at 2M", 
                                     "long_name": "TEMP a 2M", 
                                     "standard_name": "TEMP a 2M"}}}

#crea una variable VIENTO con los valores 0,0,0,1,2,3, dependiendo si sobrepasa o esta por debajo de algun percentil
def netcdf_var_win(value, value2, fill=None):
    return {"VIENTO" : {"type" : "f4", 
                        "depends" : ("Time", "Latitude", "Longitude", ), 
                        "value" : value, 
                        "fill": fill, 
                        "attributes" : {"units": "%", 
                                        "descripcion": "Magnitud del viento", 
                                        "long_name": "Magnitud del viento", 
                                        "standard_name": "Magnitud del viento"}},
            "VIENTOA" : {"type" : "f4", 
                         "depends" : ("OTime", "Latitude", "Longitude", ), 
                         "value" : value2, 
                         "fill": fill, 
                         "attributes" : {"units": "%", 
                                         "descripcion": "Magnitud del viento", 
                                         "long_name": "Magnitud del viento", 
                                         "standard_name": "Magnitud del viento"}}}

#crea una variable PREC con los valores 0,0,0,1,2,3, dependiendo si pasa sobrepasa o esta por debajo de algun percentil
def netcdf_var_prec(value, value2, fill=None):
    return {"PREC" : {"type" : "f4", 
                      "depends" : ("Time", "Latitude", "Longitude", ), 
                      "value" : value, 
                      "fill": fill, 
                      "attributes" : {"units": "%", 
                                      "descripcion": "Precipitacion", 
                                      "long_name": "Precipitacion", 
                                      "standard_name": "Precipitacion"}}, 
            "PRECA" : {"type" : "f4", 
                       "depends" : ("OTime", "Latitude", "Longitude", ), 
                       "value" : value2, 
                       "fill": fill, 
                       "attributes" : {"units": "%", 
                                       "descripcion": "Precipitacion", 
                                       "long_name": "Precipitacion", 
                                       "standard_name": "Precipitacion"}}}


#crea una nueva dimencion en un archivo netcdf
def netcdf_dim(netcdf, name, size=None):
    netcdf.createDimension(name, size)

#crea una nueva variable en un archivo netcdf
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
    if dom == 1:
        alert[:,0:50,:] = 50
        alert[:,222:,:] = 50
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
    if dom == 1:
        alert[:,0:50,:] = 50
        alert[:,222:,:] = 50
    var = {}
    var.update(netCDFVarTime(np.arange(121), datetime.today().strftime(FORMAT) + " 00:00:00"))
    var.update(netcdf_var_latlon(dom, get_var_netcdf("XLAT", netcdf)[0,::,0], get_var_netcdf("XLONG", netcdf)[0][0,:]))
    var.update(netcdf_var_win(alert, np.array([np.amax(alert, axis=0)])))
    dim = {}
    dim.update(netcdf_dim_latlon(dom))
    dim.update(netcdf_dim_time())
    create_netcdf_file(spath + "VIENTO_dom" + str(dom) + "_" +  datetime.today().strftime(FORMAT) + ".nc", var, dim)

#crea las alertas para la precipitacion
def alert_prec(spath, dom, fpath, ppath):
    netcdf = get_file_day(dom, fpath)
    RAINC = get_var_netcdf("RAINC", netcdf)
    RAINNC = get_var_netcdf("RAINNC", netcdf)
    forecast = RAINC + RAINNC
    vrange = range(0, 120, 24)
    for i in range(0, len(vrange) - 1):
        j = vrange[i + 1]
        res = j - 1
        forecast[j:] = forecast[j:] - forecast[res]
    #percentiles = get_file_percentiles(WINVARS, dom, ppath)
    percentiles = estep2(ppath, PRECVARS, get_var_netcdf("XLAT", netcdf)[0,::,0], get_var_netcdf("XLONG", netcdf)[0][0,:], "PREC_dom" + str(dom))
    alert = alert_values(forecast, percentiles, PRECVALUES)
    if dom == 1:
        alert[:,0:50,:] = 50
        alert[:,222:,:] = 50
    var = {}
    var.update(netCDFVarTime(np.arange(121), datetime.today().strftime(FORMAT) + " 00:00:00"))
    var.update(netcdf_var_latlon(dom, get_var_netcdf("XLAT", netcdf)[0,::,0], get_var_netcdf("XLONG", netcdf)[0][0,:]))
    var.update(netcdf_var_prec(alert, np.array([np.amax(alert, axis=0)])))
    dim = {}
    dim.update(netcdf_dim_latlon(dom))
    dim.update(netcdf_dim_time())
    create_netcdf_file(spath + "PREC_dom" + str(dom) + "_" +  datetime.today().strftime(FORMAT) + ".nc", var, dim)



#funcion que ajusta los puntos interpolando dados por Raul 
def estep2(path, pvars,  lat, lon, name):
    if not os.path.isfile(path):
        raise IOError("main percentiles file not found ", path)
    netcdf = Dataset(path, "r", format="NETCDF4")
    wnetcdf = Dataset(name + ".nc", "w", format="NETCDF4")
    netcdf_dim(wnetcdf, "Latitude", lat.shape[0])
    netcdf_var(wnetcdf, "Latitude", "f4", ("Latitude",), lat, {})
    netcdf_dim(wnetcdf, "Longitude", lon.shape[0])
    netcdf_var(wnetcdf, "Longitude", "f4", ("Longitude", ), lon, {})
    netcdf_dim(wnetcdf, "Time")
    netcdf_var(wnetcdf, "Time", "f4", ("Time", ), np.array([1]), {})
    data = {}
    x = get_var_netcdf("Latitude", netcdf)
    y = get_var_netcdf("Longitude", netcdf)
    for var in pvars:
        vvar = get_var_netcdf(var, netcdf)
        f = interpolate.interp2d(x, y, np.transpose(vvar), kind='linear')
        data[var] = np.transpose(f(lat, lon))
        netcdf_var(wnetcdf, var, "f4", ("Time", "Latitude", "Longitude", ), np.array([data[var]]), {})
    netcdf.close()
    wnetcdf.close()
    return data

#elimina los archivos que se crearon un dia anterior, no es necesario en el cluster
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
        #Genera los archivos de salida del step 2, solo necesarios la primera vez
        #lat1 = np.loadtxt("lat1.txt")
        #lon1 = np.loadtxt("lon1.txt")
        #lat2 = np.loadtxt("lat2.txt")
        #lon2 = np.loadtxt("lon2.txt")
        #alvars = []
        #alvars.extend(T2VARS)
        #alvars.extend(WINVARS)
        #alvars.extend(PRECVARS)
        #dominio 1
        #percentiles = estep2(argv[3], alvars, lat1, lon1, "Percentil_Dom1")
        #dominio 2
        #percentiles = estep2(argv[3], alvars, lat2, lon2, "Percentil_Dom2")
        #crea las alertas
        alert_t2(argv[1], 1, argv[2], argv[3])#para el dominio 1
        alert_t2(argv[1], 2, argv[2], argv[3])#para el dominio 2
        alert_wind(argv[1], 1, argv[2], argv[3])#para el dominio 1
        alert_wind(argv[1], 2, argv[2], argv[3])#para el dominio 2
        alert_prec(argv[1], 1, argv[2], argv[3])#para el dominio 1
        alert_prec(argv[1], 2, argv[2], argv[3])#para el dominio 2

if __name__ == "__main__":
    main(sys.argv)
