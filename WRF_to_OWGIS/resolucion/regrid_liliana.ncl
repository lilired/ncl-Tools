;start procedure add3DComposedVars
procedure addresolucion(varNames,var3Por,fin,fin1,fout,dim_time, dim_lat, dim_lon,thisDay,Dom) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
do varIdxPercentil =0,dimsizes(var3Por)-1,1 ; This loop iterates over the variables 
;begin

;*************************
; Lectura archivo wrf_dom1
;************************

domm      = "d01"
arch1     = "/ServerData/OWGIS/percentiles/Percentiles_99.9.nc"

;"/LUSTRE/HOME/fernando/operativo/EXTERNO-salidas/WRF/2017/11_noviembre/wrfout_"+domm+"_2017-11-21_00.nc"

wrf_dom1  = addfile(arch1,"r")
 nueva= new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
        
;T2_11=fin1->varNames(varIdx)
;printVarSummary(T2_11) 
; Matriz de datos fuente
nameCom=varNames(varIdx)+"_"+var3Por(varIdxPercentil)

m              = wrf_user_getvar(wrf_dom1,nameCom,-1) ; Se interpola solo un tiempo
;printVarSummary(m) 
;m              = m-273.0
m@description  = "" ; printVarSummary(m) ;[south_north | 262] x [west_east | 338]
printVarSummary(m) 
; Coordenadas

lat2a = wrf_user_getvar(wrf_dom1,"Latitude",-1)
lon2a = wrf_user_getvar(wrf_dom1,"Longitude",-1)

lat_wrf_1d1 = lat2a(:)
lon_wrf_1d1 = lon2a(:)
;print(lat_wrf_1d1)
;print(lon_wrf_1d1)
;*************************
; Lectura archivo wrf_dom2
;*************************

;domm     = "d02"
;arch2    ="/ServerData/Pronosticos/Salidas/WRF/2017/11_noviembre/wrfout_"+domm+"_2017-11-21_00.nc"

; "/LUSTRE/HOME/fernando/operativo/EXTERNO-salidas/WRF/2017/11_noviembre/wrfout_"+domm+"_2017-11-21_00.nc"

;wrf_dom2 = addfile(arch2,"r")

; Matriz con propiedades de la malla del dominio a interpolar. No la genero con el comando new para que herede las propiedades de lat, lon, etc..
if varNames(varIdx) .eq. "PREC" then
arch2     = "/ServerData/OWGIS/WRF/Dom"+Dom+"_"+thisDay(0)+"-"+thisDay(1)+"-"+sprintf("%02g",thisDay(2))+".nc";2017-11-30.nc"
wrf_dom2 = addfile(arch2,"r")
nm              = wrf_user_getvar(wrf_dom2 ,"PREC2",24)
end if

if varNames(varIdx) .eq. "T2" then
nm              = wrf_user_getvar(fin,"T2",24)
end if

if varNames(varIdx) .eq. "VIENTO" then
arch2="/ServerData/OWGIS/WRF/Dom"+Dom+"_"+thisDay(0)+"-"+thisDay(1)+"-"+sprintf("%02g",thisDay(2))+".nc";_2017-11-30.nc"
wrf_dom2 = addfile(arch2,"r")
print(arch2)
;WS10=arch2->WS10
;printVarSummary(WS10)
nm              = wrf_user_getvar(wrf_dom2 ,"WS10",24)
end if

;nm              = nm-273

nm@description  = ""
printVarSummary(nm) ; [south_north | 156] x [west_east | 273]

lat2b       = wrf_user_getvar(fin,"lat",0)
lon2b       = wrf_user_getvar(fin,"lon",0)

lat_wrf_1d2 = lat2b(:,1)
lon_wrf_1d2 = lon2b(1,:)
;print(lat_wrf_1d2)
;print(lon_wrf_1d2)
;***************
; Interpolación

;nueva= linint2(lon_wrf_1d1,lat_wrf_1d1,m,True,lon_wrf_1d2,lat_wrf_1d2,0)
;nueva= linint2_Wrap(lon_wrf_1d1,lat_wrf_1d1,m,True,lon_wrf_1d2,lat_wrf_1d2,0) 
;nueva= area_hi2lores_Wrap(lon_wrf_1d1,lat_wrf_1d1,m, lon_wrf_1d2,lat_wrf_1d2, False) 
if Dom .eq. 1 then
 nueva  = f2gsh_Wrap(m(:,:),(/262,338/),0)
else
 nueva  = f2gsh_Wrap(m(:,:),(/156,273/),0)
end if


nm := nueva

if varNames(varIdx) .eq. "T2" then
     nueva@long_name = "Percentil "+var3Por(varIdxPercentil)+"% TEMP at 2 M" ;atributes
               nueva@description="Percentil "+var3Por(varIdxPercentil)+"% TEMP at 2 M" 
               nueva@standard_name = "Percentil "+var3Por(varIdxPercentil)+"% TEMP at 2 M"     ;atributes 
               nueva@units = "C" 
end if
if varNames(varIdx) .eq. "VIENTO" then
     nueva@long_name = "Percentil "+var3Por(varIdxPercentil)+"% Magnitud de Viento";atributes
               nueva@description="Percentil "+var3Por(varIdxPercentil)+"% Magnitud de Viento";atributes
               nueva@standard_name = "Percentil "+var3Por(varIdxPercentil)+"% Magnitud de Viento";atributes    ;atributes 
               nueva@units = "Km/Hr" 
end if
if varNames(varIdx) .eq. "PREC" then
     nueva@long_name = "Percentil "+var3Por(varIdxPercentil)+"% Precipitacion";atributes
               nueva@description="Percentil "+var3Por(varIdxPercentil)+"% Precipitacion";
               nueva@standard_name = "Percentil "+var3Por(varIdxPercentil)+"% Precipitacion";   ;atributes 
               nueva@units = "%" 
end if
nameCom=varNames(varIdx)+"_"+var3Por(varIdxPercentil)
   filevardef(fout, nameCom ,typeof(nueva), (/"Time","Latitude","Longitude"/) ) ; time dimension
               filevarattdef(fout,nameCom,nueva); copy T attributes
               fout->$nameCom$ = (/nueva/)
;print(nueva)
delete(nm)
; Se reemplaza la información de la matriz que se generó primero por la información que se obtuvo con interpolación

        print("Done!")
    end do
    ;end of variables cycle percentil
    end do
    ;end of variables cycle 
end																																																																																																																																																																																																																																																																						
;end procedure add4DCars 
