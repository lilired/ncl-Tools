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

; Arreglo que contiene el rango de valores para T2
TLim = createArray(71,-20)

; Arreglo que contiene el rango de valores para T2
;PLim = createArray(51,0)

; Arreglo que contiene el rango de valores para T2
VLim = createArray(81,0)

;==================================
archivo := addfile("/home/raul/Hito/out/histogramas/Histograma_Merge.nc", "r")
T2_RES = archivo->T2_RES
;PREC_RES = archivo->PREC_RES
VIENTO_RES = archivo->VIENTO_RES
;===============================

; Numero total de años procesados
ANIOS = 19

; La suma de elementos por pixel 
SumByPixel = 24 * 365 * ANIOS

; El valor del 1% del total de elementos
STEP = SumByPixel / 100.0

; Arreglo de valores de los percentiles
PERCENTILES = (/1, 5, 10, 25, 50, 75, 90, 95, 99, 99.9/)
dimPERC = dimsizes(PERCENTILES)

; Malla con todos los percentiles
T2_TOTAL_PER = new((/dimPERC, 348, 617/), float)

; Malla con todos los percentiles
;PREC_TOTAL_PER = new((/dimPERC, 348, 617/), float)

; Malla con todos los percentiles
VIENTO_TOTAL_PER = new((/dimPERC, 348, 617/), float)

do p = 0, (dimPERC - 1)
    th = STEP * PERCENTILES(p)
    do i = 0, 347
        do j = 0, 616
            
            ;================= T2 =======================
            idx_T2 = 0
            sHist_T2 = T2_RES(i,j,idx_T2)
            sHistP_T2 = 0.0
                        
            do while(sHist_T2 .le. th)
                idx_T2 = idx_T2 + 1
                sHistP_T2 = sHist_T2
                sHist_T2 = sHist_T2 + T2_RES(i,j,idx_T2)                
            end do

            idxP_T2 = idx_T2 - 1

            if(idx_T2 .eq. 0) then
                T2_TOTAL_PER(p, i, j) = TLim(0)
            else if (idx_T2 .gt. 70) then
                T2_TOTAL_PER(p, i, j) = TLim(70)
            else
                T2_TOTAL_PER(p, i, j) = TLim(idx_T2) + ((TLim(idx_T2) - TLim(idxP_T2)) / (sHist_T2 - sHistP_T2)) * (th - sHistP_T2)
            end if
            end if

            ;======================== PREC ================
;            idx_P = 0
;            sHist_P = PREC_RES(i,j,idx_P)
;            sHistP_P = 0.0            
            
;            do while(sHist_P .le. th)
;                idx_P = idx_P + 1
;                sHistP_P = sHist_P
;                sHist_P = sHist_P + PREC_RES(i,j,idx_P)                
;            end do

;            idxP_P = idx_P - 1

;            if(idx_P .eq. 0) then
;                PREC_TOTAL_PER(p, i, j) = PLim(0)
;            else if (idx_P .gt. 70) then
;              PREC_TOTAL_PER(p, i, j) = PLim(70)
;            else
;                PREC_TOTAL_PER(p, i, j) = PLim(idx_P) + ((PLim(idx_P) - PLim(idxP_P)) / (sHist_P - sHistP_P)) * (th - sHistP_P)
;            end if
;            end if

            ;======================== VIENTO ================
            idx_V = 0
            sHist_V = VIENTO_RES(i,j,idx_V)
            sHistP_V = 0.0           
            
            do while(sHist_V .le. th)
                idx_V = idx_V + 1
                sHistP_V = sHist_V
                sHist_V = sHist_V + VIENTO_RES(i,j,idx_V)                
            end do

            idxP_V = idx_V - 1

            if(idx_V .eq. 0) then
                VIENTO_TOTAL_PER(p, i, j) = VLim(0)
            else if (idx_V .gt. 80) then
                VIENTO_TOTAL_PER(p, i, j) = VLim(80)
            else
                VIENTO_TOTAL_PER(p, i, j) = VLim(idx_V) + ((VLim(idx_V) - VLim(idxP_V)) / (sHist_V - sHistP_V)) * (th - sHistP_V)
            end if
            end if

        end do
    end do
end do

T2_1 = T2_TOTAL_PER(0,:,:)
T2_5 = T2_TOTAL_PER(1,:,:)
T2_10 = T2_TOTAL_PER(2,:,:)
T2_25 = T2_TOTAL_PER(3,:,:)
T2_50 = T2_TOTAL_PER(4,:,:)
T2_75 = T2_TOTAL_PER(5,:,:)
T2_90 = T2_TOTAL_PER(6,:,:)
T2_95 = T2_TOTAL_PER(7,:,:)
T2_99 = T2_TOTAL_PER(8,:,:)
T2_99_9 = T2_TOTAL_PER(9,:,:)

;PREC_1 = PREC_TOTAL_PER(0,:,:)
;PREC_5 = PREC_TOTAL_PER(1,:,:)
;PREC_10 = PREC_TOTAL_PER(2,:,:)
;PREC_25 = PREC_TOTAL_PER(3,:,:)
;PREC_50 = PREC_TOTAL_PER(4,:,:)
;PREC_75 = PREC_TOTAL_PER(5,:,:)
;PREC_90 = PREC_TOTAL_PER(6,:,:)
;PREC_95 = PREC_TOTAL_PER(7,:,:)
;PREC_99 = PREC_TOTAL_PER(8,:,:)

VIENTO_1 = VIENTO_TOTAL_PER(0,:,:) 
VIENTO_5 = VIENTO_TOTAL_PER(1,:,:) 
VIENTO_10 = VIENTO_TOTAL_PER(2,:,:)
VIENTO_25 = VIENTO_TOTAL_PER(3,:,:)
VIENTO_50 = VIENTO_TOTAL_PER(4,:,:)
VIENTO_75 = VIENTO_TOTAL_PER(5,:,:)
VIENTO_90 = VIENTO_TOTAL_PER(6,:,:)
VIENTO_95 = VIENTO_TOTAL_PER(7,:,:)
VIENTO_99 = VIENTO_TOTAL_PER(8,:,:)
VIENTO_99_9 = VIENTO_TOTAL_PER(9,:,:)

; ================================================================================
;                           CREAMOS EL ARCHIVO DE SALIDA
; ================================================================================

;------------------------------------------------------------------------------
; Cargamos el archivo donde se encuentran las dimensiones de latitud y longitud 
;------------------------------------------------------------------------------
archivo_dimensiones := addfile("/ServerData/KRAKEN-CFSR_Met_v2/a2000/wrfout_c_anio_d01_2000-01-01_00:00:00.2000", "r")

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
;  Creamos los atributos para T2_1
;--------------------------------
T2_1@units         = "C"
T2_1@standard_name = "Percentil 1% de Temperatura a 2 mts" 
T2_1@long_name     = "Percentil 1% de Temperatura a 2 mts"
T2_1@description   = "Percentil 1% de Temperatura a 2 mts"

;--------------------------------
;  Creamos los atributos para T2_5
;--------------------------------
T2_5@units         = "C"
T2_5@standard_name = "Percentil 5% de Temperatura a 2 mts"
T2_5@long_name     = "Percentil 5% de Temperatura a 2 mts"
T2_5@description   = "Percentil 5% de Temperatura a 2 mts"

;--------------------------------
;  Creamos los atributos para T2_10
;--------------------------------
T2_10@units         = "C"
T2_10@standard_name = "Percentil 10% de Temperatura a 2 mts"
T2_10@long_name     = "Percentil 10% de Temperatura a 2 mts"
T2_10@description   = "Percentil 10% de Temperatura a 2 mts"

;--------------------------------
;  Creamos los atributos para T2_1
;--------------------------------
T2_25@units         = "C"
T2_25@standard_name = "Percentil 25% de Temperatura a 2 mts"
T2_25@long_name     = "Percentil 25% de Temperatura a 2 mts"
T2_25@description   = "Percentil 25% de Temperatura a 2 mts"

;--------------------------------
;  Creamos los atributos para T2_1
;--------------------------------
T2_50@units         = "C"
T2_50@standard_name = "Percentil 50% de Temperatura a 2 mts"
T2_50@long_name     = "Percentil 50% de Temperatura a 2 mts"
T2_50@description   = "Percentil 50% de Temperatura a 2 mts"

;--------------------------------
;  Creamos los atributos para T2_1
;--------------------------------
T2_75@units         = "C"
T2_75@standard_name = "Percentil 75% de Temperatura a 2 mts"
T2_75@long_name     = "Percentil 75% de Temperatura a 2 mts"
T2_75@description   = "Percentil 75% de Temperatura a 2 mts"

;--------------------------------
;  Creamos los atributos para T2_1
;--------------------------------
T2_90@units         = "C"
T2_90@standard_name = "Percentil 90% de Temperatura a 2 mts"
T2_90@long_name     = "Percentil 90% de Temperatura a 2 mts"
T2_90@description   = "Percentil 90% de Temperatura a 2 mts"

;--------------------------------
;  Creamos los atributos para T2_1
;--------------------------------
T2_95@units         = "C"
T2_95@standard_name = "Percentil 95% de Temperatura a 2 mts"
T2_95@long_name     = "Percentil 95% de Temperatura a 2 mts"
T2_95@description   = "Percentil 95% de Temperatura a 2 mts"

;--------------------------------
;  Creamos los atributos para T2_1
;--------------------------------
T2_99@units         = "C"
T2_99@standard_name = "Percentil 99% de Temperatura a 2 mts"
T2_99@long_name     = "Percentil 99% de Temperatura a 2 mts"
T2_99@description   = "Percentil 99% de Temperatura a 2 mts"

;--------------------------------
;  Creamos los atributos para T2_1
;--------------------------------
T2_99_9@units         = "C"
T2_99_9@standard_name = "Percentil 99.9% de Temperatura a 2 mts"
T2_99_9@long_name     = "Percentil 99.9% de Temperatura a 2 mts"
T2_99_9@description   = "Percentil 99.9% de Temperatura a 2 mts"
;==========================================================
;--------------------------------
;  Creamos los atributos para PREC_
;--------------------------------
;PREC_1@units         = ""
;PREC_1@standard_name = "Percentil"
;PREC_1@long_name     = "Percentil"
;PREC_1@description   = "Percentil % Precipitacion"

;--------------------------------
;  Creamos los atributos para PREC_
;--------------------------------
;PREC_5@units         = ""
;PREC_5@standard_name = "Percentil"
;PREC_5@long_name     = "Percentil"
;REC_5@description   = "Percentil % Precipitacion"

;--------------------------------
;  Creamos los atributos para PREC_
;--------------------------------
;PREC_10@units         = ""
;PREC_10@standard_name = "Percentil"
;PREC_10@long_name     = "Percentil"
;PREC_10@description   = "Percentil % Precipitacion"

;--------------------------------
;  Creamos los atributos para PREC_
;--------------------------------
;PREC_25@units         = ""
;PREC_25@standard_name = "Percentil"
;PREC_25@long_name     = "Percentil"
;PREC_25@description   = "Percentil % Precipitacion"

;--------------------------------
;  Creamos los atributos para PREC_
;--------------------------------
;PREC_50@units         = ""
;PREC_50@standard_name = "Percentil"
;PREC_50@long_name     = "Percentil"
;PREC_50@description   = "Percentil % Precipitacion"

;--------------------------------
;  Creamos los atributos para PREC_
;--------------------------------
;PREC_75@units         = ""
;PREC_75@standard_name = "Percentil"
;PREC_75@long_name     = "Percentil"
;PREC_75@description   = "Percentil % Precipitacion"

;--------------------------------
;  Creamos los atributos para PREC_
;--------------------------------
;PREC_90@units         = ""
;PREC_90@standard_name = "Percentil"
;PREC_90@long_name     = "Percentil"
;PREC_90@description   = "Percentil % Precipitacion"

;--------------------------------
;  Creamos los atributos para PREC_
;--------------------------------
;PREC_95@units         = ""
;PREC_95@standard_name = "Percentil"
;PREC_95@long_name     = "Percentil"
;PREC_95@description   = "Percentil % Precipitacion"

;--------------------------------
;  Creamos los atributos para PREC_
;--------------------------------
;PREC_99@units         = ""
;PREC_99@standard_name = "Percentil"
;PREC_99@long_name     = "Percentil"
;PREC_99@description   = "Percentil % Precipitacion"
;=========================================================

;--------------------------------
;  Creamos los atributos para VIENTO_
;--------------------------------
VIENTO_1@units         = "m s-1"
VIENTO_1@standard_name = "Percentil 1% de la Magnitud del Viento"
VIENTO_1@long_name     = "Percentil 1% de la Magnitud del Viento"
VIENTO_1@description   = "Percentil 1% de la Magnitud del Viento"

;--------------------------------
;  Creamos los atributos para VIENTO_
;--------------------------------
VIENTO_5@units         = "m s-1"
VIENTO_5@standard_name = "Percentil 5% de la Magnitud del Viento"
VIENTO_5@long_name     = "Percentil 5% de la Magnitud del Viento"
VIENTO_5@description   = "Percentil 5% de la Magnitud del Viento"

;--------------------------------
;  Creamos los atributos para VIENTO_
;--------------------------------
VIENTO_10@units         = "m s-1"
VIENTO_10@standard_name = "Percentil 10% de la Magnitud del Viento"
VIENTO_10@long_name     = "Percentil 10% de la Magnitud del Viento"
VIENTO_10@description   = "Percentil 10% de la Magnitud del Viento"

;--------------------------------
;  Creamos los atributos para VIENTO_
;--------------------------------
VIENTO_25@units         = "m s-1"
VIENTO_25@standard_name = "Percentil 25% de la Magnitud del Viento"
VIENTO_25@long_name     = "Percentil 25% de la Magnitud del Viento"
VIENTO_25@description   = "Percentil 25% de la Magnitud del Viento"

;--------------------------------
;  Creamos los atributos para VIENTO_
;--------------------------------
VIENTO_50@units         = "m s-1"
VIENTO_50@standard_name = "Percentil 50% de la Magnitud del Viento"
VIENTO_50@long_name     = "Percentil 50% de la Magnitud del Viento"
VIENTO_50@description   = "Percentil 50% de la Magnitud del Viento"

;--------------------------------
;  Creamos los atributos para VIENTO_
;--------------------------------
VIENTO_75@units         = "m s-1"
VIENTO_75@standard_name = "Percentil 75% de la Magnitud del Viento"
VIENTO_75@long_name     = "Percentil 75% de la Magnitud del Viento"
VIENTO_75@description   = "Percentil 75% de la Magnitud del Viento"

;--------------------------------
;  Creamos los atributos para VIENTO_
;--------------------------------
VIENTO_90@units         = "m s-1"
VIENTO_90@standard_name = "Percentil 90% de la Magnitud del Viento"
VIENTO_90@long_name     = "Percentil 90% de la Magnitud del Viento"
VIENTO_90@description   = "Percentil 90% de la Magnitud del Viento"

;--------------------------------
;  Creamos los atributos para VIENTO_
;--------------------------------
VIENTO_95@units         = "m s-1"
VIENTO_95@standard_name = "Percentil 95% de la Magnitud del Viento"
VIENTO_95@long_name     = "Percentil 95% de la Magnitud del Viento"
VIENTO_95@description   = "Percentil 95% de la Magnitud del Viento"

;--------------------------------
;  Creamos los atributos para VIENTO_
;--------------------------------
VIENTO_99@units         = "m s-1"
VIENTO_99@standard_name = "Percentil 99% de la Magnitud del Viento"
VIENTO_99@long_name     = "Percentil 99% de la Magnitud del Viento"
VIENTO_99@description   = "Percentil 99% de la Magnitud del Viento"

;--------------------------------
;  Creamos los atributos para VIENTO_
;--------------------------------
VIENTO_99_9@units         = "m s-1"
VIENTO_99_9@standard_name = "Percentil 99.9% de la Magnitud del Viento"
VIENTO_99_9@long_name     = "Percentil 99.9% de la Magnitud del Viento"
VIENTO_99_9@description   = "Percentil 99.9% de la Magnitud del Viento"

;------------------------------------------
;  Creamos el archivo de salida 
;------------------------------------------
diro = "/home/raul/Hito/out/percentil/"  ; Output directory
filo = "Percentiles.nc"             ; Output file
system("rm -f " + diro + filo)               ; remove if exists
fout  = addfile (diro + filo, "c")           ; open output file

;-----------------------------------------
;  Creamos las variables globales 
;-----------------------------------------
fAtt               = True            ; asignamos atributos al archivo
fAtt@title         = "Percentiles 1, 5, 10, 25, 50, 75, 90, 95, 99"  
fAtt@institution   = "UNAM, Centro de Ciencias de la Atmósfera"  
fAtt@source        = "Synthetic data"  
fAtt@history       = "First version"  
fAtt@Conventions   = "CF-1.6"   
fAtt@creation_date = systemfunc ("date")        
fileattdef( fout, fAtt )            ; copiamos los atributos globales

;-------------------------------------------------------
;  Definimos las variables coordenadas y sus dimensiones
;-------------------------------------------------------
dimNames = (/"Latitude", "Longitude"/)
dimSizes = (/ nlat     ,  nlon      /)
dimUnLim = (/ False    ,  False     /)
filedimdef(fout, dimNames, dimSizes, dimUnLim)

;----------------------------------------------------------------------
;  Pre-cargamos las variables que se escribiran en el archivo de salida 
;----------------------------------------------------------------------
filevardef(fout, "Latitude" , typeof(lat) , "Latitude") ;Dimension latitud
filevardef(fout, "Longitude", typeof(lon) , "Longitude") ;Dimension longitud

filevardef(fout, "T2_1"       , typeof(T2_1)     , (/"Latitude", "Longitude"/))        ;Percentil 1% Temperatura del aire a 2m
filevardef(fout, "T2_5"       , typeof(T2_5)     , (/"Latitude", "Longitude"/))        ;Percentil 5% Temperatura del aire a 2m
filevardef(fout, "T2_10"       , typeof(T2_10)     , (/"Latitude", "Longitude"/))      ;Percentil 10% Temperatura del aire a 2m
filevardef(fout, "T2_25"       , typeof(T2_25)     , (/"Latitude", "Longitude"/))      ;Percentil 25% Temperatura del aire a 2m
filevardef(fout, "T2_50"       , typeof(T2_50)     , (/"Latitude", "Longitude"/))      ;Percentil 50% Temperatura del aire a 2m
filevardef(fout, "T2_75"       , typeof(T2_75)     , (/"Latitude", "Longitude"/))      ;Percentil 75% Temperatura del aire a 2m
filevardef(fout, "T2_90"       , typeof(T2_90)     , (/"Latitude", "Longitude"/))      ;Percentil 90% Temperatura del aire a 2m
filevardef(fout, "T2_95"       , typeof(T2_95)     , (/"Latitude", "Longitude"/))      ;Percentil 95% Temperatura del aire a 2m
filevardef(fout, "T2_99"       , typeof(T2_99)     , (/"Latitude", "Longitude"/))      ;Percentil 99% Temperatura del aire a 2m
filevardef(fout, "T2_99_9"       , typeof(T2_99_9)     , (/"Latitude", "Longitude"/))      ;Percentil 99.9% Temperatura del aire a 2m

;filevardef(fout, "PREC_1"       , typeof(PREC_1)     , (/"Latitude", "Longitude"/))        ;Percentil 1% Precipitacion
;filevardef(fout, "PREC_5"       , typeof(PREC_5)     , (/"Latitude", "Longitude"/))        ;Percentil 5% Precipitacion
;filevardef(fout, "PREC_10"       , typeof(PREC_10)     , (/"Latitude", "Longitude"/))        ;Percentil 10% Precipitacion
;filevardef(fout, "PREC_25"       , typeof(PREC_25)     , (/"Latitude", "Longitude"/))        ;Percentil 25% Precipitacion
;filevardef(fout, "PREC_50"       , typeof(PREC_50)     , (/"Latitude", "Longitude"/))        ;Percentil 50% Precipitacion
;filevardef(fout, "PREC_75"       , typeof(PREC_75)     , (/"Latitude", "Longitude"/))        ;Percentil 75% Precipitacion
;filevardef(fout, "PREC_90"       , typeof(PREC_90)     , (/"Latitude", "Longitude"/))        ;Percentil 90% Precipitacion
;filevardef(fout, "PREC_95"       , typeof(PREC_95)     , (/"Latitude", "Longitude"/))        ;Percentil 95% Precipitacion
;filevardef(fout, "PREC_99"       , typeof(PREC_99)     , (/"Latitude", "Longitude"/))        ;Percentil 99% Precipitacion

filevardef(fout, "VIENTO_1"       , typeof(VIENTO_1)     , (/"Latitude", "Longitude"/))        ;Percentil 1% Magnitud del viento
filevardef(fout, "VIENTO_5"       , typeof(VIENTO_5)     , (/"Latitude", "Longitude"/))        ;Percentil 5% Magnitud del viento
filevardef(fout, "VIENTO_10"       , typeof(VIENTO_10)     , (/"Latitude", "Longitude"/))        ;Percentil 10% Magnitud del viento
filevardef(fout, "VIENTO_25"       , typeof(VIENTO_25)     , (/"Latitude", "Longitude"/))        ;Percentil 25% Magnitud del viento
filevardef(fout, "VIENTO_50"       , typeof(VIENTO_50)     , (/"Latitude", "Longitude"/))        ;Percentil 50% Magnitud del viento
filevardef(fout, "VIENTO_75"       , typeof(VIENTO_75)     , (/"Latitude", "Longitude"/))        ;Percentil 75% Magnitud del viento
filevardef(fout, "VIENTO_90"       , typeof(VIENTO_90)     , (/"Latitude", "Longitude"/))        ;Percentil 90% Magnitud del viento
filevardef(fout, "VIENTO_95"       , typeof(VIENTO_95)     , (/"Latitude", "Longitude"/))        ;Percentil 95% Magnitud del viento
filevardef(fout, "VIENTO_99"       , typeof(VIENTO_99)     , (/"Latitude", "Longitude"/))        ;Percentil 99% Magnitud del viento
filevardef(fout, "VIENTO_99_9"       , typeof(VIENTO_99_9)     , (/"Latitude", "Longitude"/))        ;Percentil 99.9% Magnitud del viento


;----------------------------------------------------------------------
;  Copiar atributos asociados con cada variable a el archivo de salida
;----------------------------------------------------------------------
filevarattdef(fout, "Latitude" , lat )  ;copia los atributos de latitud
filevarattdef(fout, "Longitude", lon )  ;copia los atributos de longitud

filevarattdef(fout, "T2_1" ,  T2_1      )  ;copia los atributos de T2_1
filevarattdef(fout, "T2_5" ,  T2_5      )  ;copia los atributos de T2_5
filevarattdef(fout, "T2_10",  T2_10     )  ;copia los atributos de T2_10
filevarattdef(fout, "T2_25",  T2_25     )  ;copia los atributos de T2_25
filevarattdef(fout, "T2_50",  T2_50     )  ;copia los atributos de T2_50
filevarattdef(fout, "T2_75",  T2_75     )  ;copia los atributos de T2_75
filevarattdef(fout, "T2_90",  T2_90     )  ;copia los atributos de T2_90
filevarattdef(fout, "T2_95",  T2_95     )  ;copia los atributos de T2_95
filevarattdef(fout, "T2_99",  T2_99     )  ;copia los atributos de T2_99
filevarattdef(fout, "T2_99_9",  T2_99_9     )  ;copia los atributos de T2_99_9

;filevarattdef(fout, "PREC_1" ,  PREC_1      )  ;copia los atributos de PREC_1
;filevarattdef(fout, "PREC_5" ,  PREC_5      )  ;copia los atributos de PREC_5
;filevarattdef(fout, "PREC_10",  PREC_10     )  ;copia los atributos de PREC_10
;filevarattdef(fout, "PREC_25",  PREC_25     )  ;copia los atributos de PREC_25
;filevarattdef(fout, "PREC_50",  PREC_50     )  ;copia los atributos de PREC_50
;filevarattdef(fout, "PREC_75",  PREC_75     )  ;copia los atributos de PREC_75
;filevarattdef(fout, "PREC_90",  PREC_90     )  ;copia los atributos de PREC_90
;ilevarattdef(fout, "PREC_95",  PREC_95     )  ;copia los atributos de PREC_95
;filevarattdef(fout, "PREC_99",  PREC_99     )  ;copia los atributos de PREC_99

filevarattdef(fout, "VIENTO_1" ,  VIENTO_1      )  ;copia los atributos de VIENTO_1
filevarattdef(fout, "VIENTO_5" ,  VIENTO_5      )  ;copia los atributos de VIENTO_5
filevarattdef(fout, "VIENTO_10",  VIENTO_10     )  ;copia los atributos de VIENTO_10
filevarattdef(fout, "VIENTO_25",  VIENTO_25     )  ;copia los atributos de VIENTO_25
filevarattdef(fout, "VIENTO_50",  VIENTO_50     )  ;copia los atributos de VIENTO_50
filevarattdef(fout, "VIENTO_75",  VIENTO_75     )  ;copia los atributos de VIENTO_75
filevarattdef(fout, "VIENTO_90",  VIENTO_90     )  ;copia los atributos de VIENTO_90
filevarattdef(fout, "VIENTO_95",  VIENTO_95     )  ;copia los atributos de VIENTO_95
filevarattdef(fout, "VIENTO_99",  VIENTO_99     )  ;copia los atributos de VIENTO_99
filevarattdef(fout, "VIENTO_99_9",  VIENTO_99_9     )  ;copia los atributos de VIENTO_99_9

;------------------------------------------------
;  Obtenemos unicamente los valores de los datos 
;------------------------------------------------
fout->Latitude  = (/lat/)
print("copiamos lat ...")
fout->Longitude = (/lon/)
print("copiamos lon ...")

fout->T2_1        = (/T2_1/)
fout->T2_5        = (/T2_5/)
fout->T2_10        = (/T2_10/)
fout->T2_25        = (/T2_25/)
fout->T2_50        = (/T2_50/)
fout->T2_75        = (/T2_75/)
fout->T2_90        = (/T2_90/)
fout->T2_95        = (/T2_95/)
fout->T2_99        = (/T2_99/)
fout->T2_99_9        = (/T2_99_9/)
print("copiamos T2_* ...")

;fout->PREC_1        = (/PREC_1/)
;fout->PREC_5        = (/PREC_5/)
;fout->PREC_10        = (/PREC_10/)
;fout->PREC_25        = (/PREC_25/)
;fout->PREC_50        = (/PREC_50/)
;fout->PREC_75        = (/PREC_75/)
;fout->PREC_90        = (/PREC_90/)
;fout->PREC_95        = (/PREC_95/)
;fout->PREC_99        = (/PREC_99/)
;print("copiamos PREC_* ...")

fout->VIENTO_1        = (/VIENTO_1/)
fout->VIENTO_5        = (/VIENTO_5/)
fout->VIENTO_10       = (/VIENTO_10/)
fout->VIENTO_25       = (/VIENTO_25/)
fout->VIENTO_50       = (/VIENTO_50/)
fout->VIENTO_75       = (/VIENTO_75/)
fout->VIENTO_90       = (/VIENTO_90/)
fout->VIENTO_95       = (/VIENTO_95/)
fout->VIENTO_99       = (/VIENTO_99/)
fout->VIENTO_99_9     = (/VIENTO_99_9/) 
print("copiamos VIENTO_* ...")

print("Hora de termino :  " + systemfunc("date"))