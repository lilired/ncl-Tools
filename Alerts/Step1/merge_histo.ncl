;------------------------------------------------------------------
; --- Funcion que crea un arreglo de una dimension ---
function createArray(size, first_value)
begin
    myarray = new(size,float)
    do n=0,size-1
        myarray(n) = first_value
        first_value = first_value + 1 
    end do 
    return myarray
end

print("Hora de inicio :  " + systemfunc ("date"))
;--- Ruta base ---
RUTA = "/home/olmozavala/out/out-Histogramas-Total/"
; Se cargan en los archivos
ARCHIVOS := systemfunc("ls " + RUTA + "*")
; Número de archivos
num_archivos := dimsizes(ARCHIVOS)

; --- Se obtienen las inicializan las variables, donde se guardara el resultado
archivo := addfile(ARCHIVOS(0), "r")
T2_RES = archivo->T2_RES
;PREC_RES = archivo->PREC_RES
VIENTO_RES = archivo->VIENTO_RES

; Se iteran sobre todos los archivos 
do i = 1 , (num_archivos - 1)
    archivo := addfile(ARCHIVOS(i), "r")
    T2_RES_actual := archivo->T2_RES
    ;PREC_RES_actual := archivo->PREC_RES
    VIENTO_RES_actual := archivo->VIENTO_RES

    T2_RES = T2_RES + T2_RES_actual
    ;PREC_RES = PREC_RES + PREC_RES_actual
    VIENTO_RES = VIENTO_RES + VIENTO_RES_actual

end do




; ================================================================================
;                           CREAMOS EL ARCHIVO DE SALIDA
; ================================================================================



;----------------------------------
;  Creamos la dimension profundidad 
;----------------------------------
depth_1 = createArray(71,0)
depth_1@standard_name = "depth"
depth_1@long_name     = "Depth"
depth_1@units         = ""
depth_1@axis          = "Z"
ndepth1 = dimsizes(depth_1)

;----------------------------------
;  Creamos la dimension profundidad 2
;----------------------------------
;depth_2 = createArray(51,0)
;depth_2@standard_name = "depth"
;depth_2@long_name     = "Depth"
;depth_2@units         = ""
;depth_2@axis          = "Z"
;ndepth2 = dimsizes(depth_2)

;----------------------------------
;  Creamos la dimension profundidad 3
;----------------------------------
depth_3 = createArray(81,0)
depth_3@standard_name = "depth"
depth_3@long_name     = "Depth"
depth_3@units         = ""
depth_3@axis          = "Z"
ndepth3 = dimsizes(depth_3)

;------------------------------------------------------------------------------
; Cargamos el archivo donde se encuentran las dimensiones de latitud y longitud 
;------------------------------------------------------------------------------
archivo_dimensiones := addfile("/KRAKEN/DATOS2/SALIDAS_WRF_ii/a2000/wrfout_c_anio_d01_2000-01-01_00:00:00.2000", "r")

;----------------------------------------
;   Obtenemos la dimension de Latitud 
;----------------------------------------
latAux = archivo_dimensiones->XLAT
lat = latAux(0,:,0)
delete_VarAtts(lat,-1)
nlat = dimsizes(lat)

lat@standard_name =  "latitude"
lat@long_name     =  "Latitude"
lat@units         =  "degrees_north"

;-------------------------------------
;  Obtenemos la dimension de Longitud 
;-------------------------------------
lonAux = archivo_dimensiones->XLONG
lon = lonAux(0,0,:)
delete_VarAtts(lon,-1)
nlon = dimsizes(lon)

lon@standard_name =  "longitude"
lon@long_name     =  "Longitude"
lon@units         =  "degrees_east"

;--------------------------------
;  Creamos los atributos para T2 
;--------------------------------
T2_RES@units         = ""
T2_RES@standard_name = "T2 Histograma"
T2_RES@long_name     = "T2 Histograma"
T2_RES@description   = "Histograma de TEMP at 2 M"

;--------------------------------
;  Creamos los atributos para PREC
;--------------------------------
;PREC_RES@units         = ""
;PREC_RES@standard_name = "PREC Histograma"
;PREC_RES@long_name     = "PREC Histograma"
;PREC_RES@description   = "Histograma de la precipitacion"

;--------------------------------
;  Creamos los atributos para VIENTO (Magnitud)
;--------------------------------
VIENTO_RES@units         = ""
VIENTO_RES@standard_name = "Magnitud Viento Histograma"
VIENTO_RES@long_name     = "Magnitud Viento Histograma"
VIENTO_RES@description   = "Histograma de Magnitud Viento "

;------------------------------------------
;  Creamos el archivo de salida 
;------------------------------------------
diro = "/home/olmozavala/out/out-Histograma-Merge/"                     ; Output directory
filo = "Histograma_Merge.nc"             ; Output file
system("rm -f " + diro + filo)    ; remove if exists
fout  = addfile (diro + filo, "c")  ; open output file

;-----------------------------------------
;  Creamos las variables globales 
;-----------------------------------------
fAtt               = True            ; asignamos atributos al archivo
fAtt@title         = "Histogramas"  
fAtt@institution   = "UNAM, Centro de Ciencias de la Atmósfera"  
fAtt@source        = "Synthetic data"  
fAtt@history       = "First version"  
fAtt@Conventions   = "CF-1.6"       
fAtt@creation_date = systemfunc ("date")        
fileattdef( fout, fAtt )            ; copiamos los atributos globales

;-------------------------------------------------------
;  Definimos las variables coordenadas y sus dimensiones
;-------------------------------------------------------
;dimNames = (/ "Latitude", "Longitude", "Depth_1", "Depth_2", "Depth_3"/)
;dimSizes = (/ nlat      ,  nlon      ,  ndepth1 , ndepth2  , ndepth3/)
;dimUnLim = (/ False     ,  False     ,  False   , False    , False/)

dimNames = (/ "Latitude", "Longitude", "Depth_1", "Depth_3"/)
dimSizes = (/ nlat      ,  nlon      ,  ndepth1 , ndepth3/)
dimUnLim = (/ False     ,  False     ,  False   , False/)

filedimdef(fout, dimNames, dimSizes, dimUnLim)

;----------------------------------------------------------------------
;  Pre-cargamos las variables que se escribiran en el archivo de salida 
;----------------------------------------------------------------------
filevardef(fout, "Latitude" , typeof(lat) , "Latitude") ;Dimension latitud
filevardef(fout, "Longitude", typeof(lon) , "Longitude") ;Dimension longitud
filevardef(fout, "Depth_1"    , typeof(depth_1), "Depth_1")     ;Dimension profundidad
;filevardef(fout, "Depth_2"    , typeof(depth_2), "Depth_2")     ;Dimension profundidad
filevardef(fout, "Depth_3"    , typeof(depth_3), "Depth_3")     ;Dimension profundidad

filevardef(fout, "T2_RES"   , typeof(T2_RES)     , (/"Latitude", "Longitude", "Depth_1"/))          ;Temperatura del aire a 2m
;filevardef(fout, "PREC_RES"   , typeof(PREC_RES)     , (/"Latitude", "Longitude", "Depth_2"/))      ;Precipitacion
filevardef(fout, "VIENTO_RES"   , typeof(VIENTO_RES)     , (/"Latitude", "Longitude", "Depth_3"/))  ;Magnitud del Viento

;----------------------------------------------------------------------
;  Copiar atributos asociados con cada variable a el archivo de salida
;----------------------------------------------------------------------
filevarattdef(fout, "Latitude" , lat )  ;copia los atributos de latitud
filevarattdef(fout, "Longitude", lon )  ;copia los atributos de longitud
filevarattdef(fout, "Depth_1"    , depth_1) ;copia los atributos de profundidad
;filevarattdef(fout, "Depth_2"    , depth_2) ;copia los atributos de profundidad
filevarattdef(fout, "Depth_3"    , depth_3) ;copia los atributos de profundidad

filevarattdef(fout, "T2_RES"     , T2_RES     )  ;copia los atributos de T2
;filevarattdef(fout, "PREC_RES"   , PREC_RES   )  ;copia los atributos de PREC
filevarattdef(fout, "VIENTO_RES" , VIENTO_RES )  ;copia los atributos de VIENTO

;------------------------------------------------
;  Obtenemos unicamente los valores de los datos 
;------------------------------------------------
fout->Latitude  = (/lat/)
print("copiamos lat ...")
fout->Longitude = (/lon/)
print("copiamos lon ...")
fout->Depth_1 = (/depth_1/)
print("copiamos depth ...")
;fout->Depth_2 = (/depth_2/)
;print("copiamos depth ...")
fout->Depth_3 = (/depth_3/)
print("copiamos depth ...")
fout->T2_RES        = (/T2_RES/)
print("copiamos T2_RES ...")
;fout->PREC_RES        = (/PREC_RES/)
;print("copiamos PREC_RES ...")
fout->VIENTO_RES        = (/VIENTO_RES/)
print("copiamos VIENTO_RES ...")


