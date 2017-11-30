# coding=utf-8
#se importan bibliotecas necesarias para leer los datos
import os
import re
import time
import numpy as np
from netCDF4 import Dataset
from datetime import datetime
import gc


#constantes
PATH = "/ServerData/Pronosticos/Salidas/WRF"
PATHF = "/ServerData/OWGIS/WRF/nuevo"
TOKENFILE = "/"
MONTHS = ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"]
PERFILES = ["Percentil_Dom1", "Percentil_Dom1"]
T2VARS = ["T2_1", "T2_5", "T2_10", "T2_90", "T2_95", "T2_99"]
T2VALUES = [-1, -2, -3, 1, 2, 3]#el orden si importa
WINVARS = ["VIENTO_1", "VIENTO_5", "VIENTO_10", "VIENTO_90", "VIENTO_95", "VIENTO_99"]#verificar
WINPRCVALUES = [-1, -2, -3, 1, 2, 3]#el orden si importa
PRECVARS = ["PREC_1", "PREC_5", "PREC_10", "PREC_90", "PREC_95", "PREC_99"]#verificar
PRECVALUES = [-1, -2, -3, 1, 2, 3]#el orden si importa
FORMAT = "%Y-%m-%d"
CALENDAR = "gregorian"
SINCE = "hours since 2017-11-26 00:00:00"
DIMLAT = 262
DIMLON = 338
DIMLAT_2 = 156
DIMLON_2 = 273
DIMTIME = 121

#obtine los archivos por dia
def getFileDay(dom):
    if dom != 1:
        dom = 2
    today = datetime.today()
    year = today.year
    mount = today.month
    nfile = PATH + TOKENFILE + str(year) + TOKENFILE + str(mount) + "_" + MONTHS[mount - 1]  + TOKENFILE + "wrfout_d0" + str(dom) + "_" + today.strftime(FORMAT) + "_00.nc"
    print("Forecast file: " + nfile)
    return Dataset(nfile, "r", format="NETCDF4")

def getFilePercentiles(pvars, dom):
    per = {}
    if dom != 1:
        dom = 2
    nfile = PATHF + TOKENFILE + "Percentil_Dom" + str(dom) + "_" + datetime.today().strftime(FORMAT) + ".nc"
    print("percentiles file: " + nfile)
    gsfFile = Dataset(nfile , "r", format="NETCDF4")
    for var in pvars:
        per[var] = getVarNetCDF(var, gsfFile)
    return per

#obtiene una variable del archivo netcdf
def getVarNetCDF(nameVar, netCDF):
    if nameVar in netCDF.variables:
    	return np.copy(netCDF.variables.get(nameVar))
    else:
    	print("no se encontro la variable: ", nameVar)

#obtiene los valores de alerta segun la variable
def alertValues(forecast, percentiles, percentilesValues):
    aler = np.empty(forecast.shape, dtype=int)
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
def createNETCDFFile(name, varsNCDF, dimensions, ow=None):
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
        print(var + " tam " + str(varsNCDF[var]["value"].shape))
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
    print("Cerrando archivo")
    
#obtiene los valores de las variables de longitud y Latitud
def netCDFVarLatLon(dom, lat=None, lon=None, fillLat=None, fillLon=None):
    net = {}
    if dom != 1:
        dom = 2
    if lat is None:
        lat = np.loadtxt("lat_" + str(dom))
    if lon is None:
        lon = np.loadtxt("lon_" + str(dom))
    net["Latitude"] = {"type" : "f4", "depends" : ("Latitude",), "value" : lat, "fill": fillLat, "attributes" : {"units": "degrees_north", "long_name": "Latitude", "standard_name": "Latitude"}}
    net["Longitude"] = {"type" : "f4", "depends" : ("Longitude",), "value" : lon, "fill": fillLon, "attributes" : {"units": "degrees_east", "long_name": "Longitude", "standard_name": "longitude"}}
    return net

#obtiene la dimencion de las variables latitud y longitud
def netCDFDimLatLon(dom, lat=DIMLAT, lon=DIMLON):
    if dom != 1:
        lat = DIMLAT_2
        lon = DIMLON_2
    return {"Latitude": {"size": lat}, "Longitude": {"size": lon}}

#obtiene la variable tiempo
def netCDFVarTime(time=None, calendar=CALENDAR, since=SINCE, fill=None):
    if time is None:
        time = np.loadtxt("time")
    return {"Time" : {"type" : "i4", "depends" : ("Time",), "value" : time, "fill": fill, "attributes" : {"units": since, "calendar": calendar, "long_name": "Time", "standard_name": "Time"}},
            "OTime" : {"type" : "i4", "depends" : ("OTime",), "value" : np.array([1]), "fill": fill, "attributes" : {"units": since, "calendar": calendar, "long_name": "Time", "standard_name": "Time"}}}

#obtiene la dimencion de la variable tiempo
def netCDFDimTime(time=DIMTIME):
    return {"Time": {"size": time}, "OTime" : {"size": 1}}

#crea una variable T2 con los valores -1,-2,-3,1,2,3, dependiendo si pasa algun percentil
def netCDFVarT2(value, value2, fill=None):
    return {"T2" : {"type" : "i1", "depends" : ("Time", "Latitude", "Longitude", ), "value" : value, "fill": fill, "attributes" : {"units": "C", "descripcion": "TEMP at 2M", "long_name": "TEMP a 2M", "standard_name": "TEMP a 2M"}}, 
            "T2A" : {"type" : "i1", "depends" : ("OTime", "Latitude", "Longitude", ), "value" : value2, "fill": fill, "attributes" : {"units": "C", "descripcion": "TEMP at 2M", "long_name": "TEMP a 2M", "standard_name": "TEMP a 2M"}}}

#crea una variable T2 con los valores -1,-2,-3,1,2,3, dependiendo si pasa algun percentil
def netCDFVarWin(value, value2, fill=None):
    return {"VIENTO" : {"type" : "i1", "depends" : ("Time", "Latitude", "Longitude", ), "value" : value, "fill": fill, "attributes" : {"units": "Km/Hr", "descripcion": "Magnitud del viento", "long_name": "Magnitud del viento", "standard_name": "Magnitud del viento"}}, 
            "VIENTOA" : {"type" : "i1", "depends" : ("OTime", "Latitude", "Longitude", ), "value" : value2, "fill": fill, "attributes" : {"units": "Km/Hr", "descripcion": "Magnitud del viento", "long_name": "Magnitud del viento", "standard_name": "Magnitud del viento"}}}

#crea una variable T2 con los valores -1,-2,-3,1,2,3, dependiendo si pasa algun percentil
def netCDFVarPrec(value, value2, fill=None):
    return {"PREC" : {"type" : "i1", "depends" : ("Time", "Latitude", "Longitude", ), "value" : value, "fill": fill, "attributes" : {"units": "&", "descripcion": "Precipitacion", "long_name": "Precipitacion", "standard_name": "Precipitacion"}}, 
            "PRECA" : {"type" : "i1", "depends" : ("OTime", "Latitude", "Longitude", ), "value" : value2, "fill": fill, "attributes" : {"units": "&", "descripcion": "Precipitacion", "long_name": "Precipitacion", "standard_name": "Precipitacion"}}}

#crea las alertas para temperatura
def alertT2(fname, dom=1):
    forecast = getVarNetCDF("T2", getFileDay(dom))
    percentiles = getFilePercentiles(T2VARS, dom)
    alert = alertValues(forecast, percentiles, T2VALUES)
    var = {}
    var.update(netCDFVarLatLon(dom))
    var.update(netCDFVarTime())
    var.update(netCDFVarT2(alert, np.array([np.amax(alert, axis=0)])))
    dim = {}
    dim.update(netCDFDimLatLon(dom))
    dim.update(netCDFDimTime())
    createNETCDFFile(fname, var, dim)

#crea las alertas para temperatura
def alertWIND(fname, dom=1):
    U10 = getVarNetCDF("U10", getFileDay(dom))
    V10 = getVarNetCDF("V10", getFileDay(dom))
    forecast = np.sqrt(np.power(U10, 2) + np.power(V10, 2))
    percentiles = getFilePercentiles(T2VARS, dom)
    alert = alertValues(forecast, percentiles, T2VALUES)
    var = {}
    var.update(netCDFVarLatLon(dom))
    var.update(netCDFVarTime())
    var.update(netCDFVarWin(alert, np.array([np.amax(alert, axis=0)])))
    dim = {}
    dim.update(netCDFDimLatLon(dom))
    dim.update(netCDFDimTime())
    createNETCDFFile(fname, var, dim)

#ejecuto el codigo de alertamiento para la variable T2 en sus 2 dominios
alertT2("T2_alert_d1.nc", 1);
alertT2("T2_alert_d2.nc", 2);
#para viento
alertWIND("VIENTO_alert_d1.nc", 1);
alertWIND("VIENTO_alert_d2.nc", 2);
#para Precipitacion
#alertPREC("PREC_alert_d1.nc", "PREC", netCDFVarPrec, 1);
#alertPREC("PREC_alert_d2.nc", "PREC", netCDFVarPrec, 2);
