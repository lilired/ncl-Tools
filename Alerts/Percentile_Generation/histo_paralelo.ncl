;================================================
;Autor : Raúl Medina 
; Se generan los histogrmas de forma paralela
;================================================

; --  Funcion que regresa el maximo de dos numeros ---------------------
function maximo(n1, n2) begin if (n1 .le. n2) then return n2  else return n1 end if end

; --  Funcion que regresa el minimo de dos numeros ---------------------
function minimo(n1, n2) begin if (n1 .le. n2) then return n1  else return n2 end if end

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

; ================================================================================
;                           CREAMOS EL ARCHIVO DE SALIDA
; ================================================================================

;============================================================
; Funcion que crea 12 archivos que representan los 12 meses,
; para alguna variable
;============================================================
;function guardarHisto(t2, viento, i)
function guardarHisto(t2, prec, viento, i)
begin

    T2_RES := t2
    PREC_RES := prec
    VIENTO_RES :=viento

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
    depth_2 = createArray(401,0)
    depth_2@standard_name = "depth"
    depth_2@long_name     = "Depth"
    depth_2@units         = ""
    depth_2@axis          = "Z"
    ndepth2 = dimsizes(depth_2)

    ;----------------------------------
    ;  Creamos la dimension profundidad 3
    ;----------------------------------
    depth_3 = createArray(101,0)
    depth_3@standard_name = "depth"
    depth_3@long_name     = "Depth"
    depth_3@units         = ""
    depth_3@axis          = "Z"
    ndepth3 = dimsizes(depth_3)

    ;------------------------------------------------------------------------------
    ; Cargamos el archivo donde se encuentran las dimensiones de latitud y longitud 
    ;------------------------------------------------------------------------------
    archivo_dimensiones := addfile("/KRAKEN/DATOS3/a2000/wrfout_c_anio_d01_2000-01-01_00:00:00.2000", "r")

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
    T2_RES@units         = "C"
    T2_RES@standard_name = "T2 Histograma"
    T2_RES@long_name     = "T2 Histograma"
    T2_RES@description   = "Histograma de TEMP at 2 M"

    ;--------------------------------
    ;  Creamos los atributos para PREC
    ;--------------------------------
    PREC_RES@units         = "mm"
    PREC_RES@standard_name = "PREC Histograma"
    PREC_RES@long_name     = "PREC Histograma"
    PREC_RES@description   = "Histograma de la precipitacion"

    ;--------------------------------
    ;  Creamos los atributos para VIENTO (Magnitud)
    ;--------------------------------
    VIENTO_RES@units         = "m s-1"
    VIENTO_RES@standard_name = "Magnitud Viento Histograma"
    VIENTO_RES@long_name     = "Magnitud Viento Histograma"
    VIENTO_RES@description   = "Histograma de Magnitud Viento "

    ;------------------------------------------
    ;  Creamos el archivo de salida 
    ;------------------------------------------
    diro = "/home/rmedina/out/out-Histogramas-Total/tmp/"                     ; Output directory
    filo = "histograma_" + i + ".nc"             ; Output file
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
    dimNames = (/ "Latitude", "Longitude", "Depth_1", "Depth_2", "Depth_3"/)
    dimSizes = (/ nlat      ,  nlon      ,  ndepth1 , ndepth2  , ndepth3/)
    dimUnLim = (/ False     ,  False     ,  False   , False    , False/)
    
    filedimdef(fout, dimNames, dimSizes, dimUnLim)

    ;----------------------------------------------------------------------
    ;  Pre-cargamos las variables que se escribiran en el archivo de salida 
    ;----------------------------------------------------------------------
    filevardef(fout, "Latitude" , typeof(lat) , "Latitude") ;Dimension latitud
    filevardef(fout, "Longitude", typeof(lon) , "Longitude") ;Dimension longitud

    filevardef(fout, "Depth_1"    , typeof(depth_1), "Depth_1")     ;Dimension profundidad
    filevardef(fout, "Depth_2"    , typeof(depth_2), "Depth_2")     ;Dimension profundidad
    filevardef(fout, "Depth_3"    , typeof(depth_3), "Depth_3")     ;Dimension profundidad

    filevardef(fout, "T2_RES"   , typeof(T2_RES)     , (/"Latitude", "Longitude", "Depth_1"/))          ;Temperatura del aire a 2m
    filevardef(fout, "PREC_RES"   , typeof(PREC_RES)     , (/"Latitude", "Longitude", "Depth_2"/))      ;Precipitacion
    filevardef(fout, "VIENTO_RES"   , typeof(VIENTO_RES)     , (/"Latitude", "Longitude", "Depth_3"/))  ;Magnitud del Viento

    ;----------------------------------------------------------------------
    ;  Copiar atributos asociados con cada variable a el archivo de salida
    ;----------------------------------------------------------------------
    filevarattdef(fout, "Latitude" , lat )  ;copia los atributos de latitud
    filevarattdef(fout, "Longitude", lon )  ;copia los atributos de longitud
    filevarattdef(fout, "Depth_1"    , depth_1) ;copia los atributos de profundidad
    filevarattdef(fout, "Depth_2"    , depth_2) ;copia los atributos de profundidad
    filevarattdef(fout, "Depth_3"    , depth_3) ;copia los atributos de profundidad

    filevarattdef(fout, "T2_RES"     , T2_RES     )  ;copia los atributos de T2
    filevarattdef(fout, "PREC_RES"   , PREC_RES   )  ;copia los atributos de PREC
    filevarattdef(fout, "VIENTO_RES" , VIENTO_RES )  ;copia los atributos de VIENTO

    ;------------------------------------------------
    ;  Obtenemos unicamente los valores de los datos 
    ;------------------------------------------------
    fout->Latitude  = (/lat/)
    fout->Longitude = (/lon/)
    fout->Depth_1 = (/depth_1/)
    fout->Depth_2 = (/depth_2/)
    fout->Depth_3 = (/depth_3/)

    fout->T2_RES        = (/T2_RES/)
    fout->PREC_RES        = (/PREC_RES/)
    fout->VIENTO_RES        = (/VIENTO_RES/)

    return True
end

;--- Ruta base ---
BASE = "/KRAKEN/DATOS3/"

;--- Prefijo ---
PREFIX_FILE_C1H = "wrfout_c1h_d01_"

;Valor minimo del rango T2
MIN_T2 = -20  
;Valor maximo del rango
MAX_T2 = 50
;Numero de elementos del rango
N_ELEMS_T2 = MAX_T2 - MIN_T2 + 1

;Valor minimo del rango PREC
MIN_PREC = 0  
;Valor maximo del rango
MAX_PREC = 400
;Numero de elementos del rango
N_ELEMS_PREC = MAX_PREC - MIN_PREC + 1

;Valor minimo del rango Viento
MIN_VIENTO = 0  
;Valor maximo del rango
MAX_VIENTO = 100
;Numero de elementos del rango
N_ELEMS_VIENTO = MAX_VIENTO - MIN_VIENTO + 1

; ----------------------------------------;
; ---- Inicializar las variables en 0 ----;

; --- Temperatura del aire a 2 mts ----
T2_RES = new ((/348, 617, 71/), float)
T2_RES(:,:,:) = 0.0 

; --- RAINC Precipitación  acumulada ---
PREC_RES = new ((/348, 617, 401/), float)
PREC_RES(:,:,:) = 0.0

; --- U10 Viento a 10 M ----
VIENTO_RES = new ((/348, 617, 101/), float)
VIENTO_RES(:,:,:) = 0.0

folders = systemfunc("ls " + BASE)

nFolders = dimsizes(folders)


;myDay es el número del día del año que va a procesar
myDay = md    
;numNucleos, el numero total de nucleos
numNucleos = N + 1

;El ciclo inicia en el dia que le corresponde procesar para todos los años
do bz = myDay, 364, numNucleos    
    
    ; -- Recorremos las carpetas por Año ----;
    do anio = 1, (nFolders - 2) ; Las salidas del ultimo año 2017 no estan completas

        ruta_archivos_anio := BASE + folders(anio) + "/" + PREFIX_FILE_C1H
        archivos_X_anio := systemfunc("ls " + ruta_archivos_anio + "*")                

        ;--- carga el archivo --- 
        archivo := addfile(archivos_X_anio(bz), "r")

        ;Obtenemos la temperatura T2 en grados Kelvin
        T2_actual := archivo->T2
        ;Hacemos la conversion a grados Celsius
        T2_actual := T2_actual(:,:,:) - 273.15

        ;obtenemos las variables para calcular PREC2
        RAINC_actual := archivo->RAINC
        RAINNC_actual := archivo->RAINNC

        U10_actual := archivo->U10
        V10_actual := archivo->V10
        
        do i = 0, 347
           
            do j = 0, 616

                ;Calculamos PREC2 del dia correspondiente, se resta la hora 0 por que es un acumulado anual.
                PREC_actual := RAINC_actual(23,i,j) + RAINNC_actual(23,i,j) - (RAINC_actual(0,i,j) + RAINNC_actual(0,i,j))
                ;Obtenemos el índice al que le corresponde el valor de PREC2 para cada i,j de cada dia
                ;Acotamos dicho índice con el valor mínimo y máximo del rango de valores para PREC2
                indice_ij_PREC := minimo(maximo (floattointeger(ceil(PREC_actual) - MIN_PREC), 0), N_ELEMS_PREC -1)
                ;Sumamos 1 al rango de valores de la posición ij de la malla, para calcular su histograma 
                PREC_RES(i, j, indice_ij_PREC) = PREC_RES(i, j, indice_ij_PREC) + 1  

                do hora = 0, 23
                    VIENTO_actual := sqrt((U10_actual(hora,i,j) * U10_actual(hora,i,j)) + (V10_actual(hora,i,j) * V10_actual(hora,i,j)))                   


                    indice_ij_T2 = minimo(maximo (floattointeger(ceil(T2_actual(hora,i,j)) - MIN_T2), 0), N_ELEMS_T2 -1)
                    indice_ij_VIENTO = minimo(maximo (floattointeger(ceil(VIENTO_actual) - MIN_VIENTO), 0), N_ELEMS_VIENTO -1)
                    
                    T2_RES(i, j, indice_ij_T2) = T2_RES(i, j, indice_ij_T2) + 1
                    VIENTO_RES(i, j, indice_ij_VIENTO) = VIENTO_RES(i, j, indice_ij_VIENTO) + 1
                end do

            end do

        end do       
        
    end do         

end do

res = guardarHisto(T2_RES, PREC_RES, VIENTO_RES, myDay)
