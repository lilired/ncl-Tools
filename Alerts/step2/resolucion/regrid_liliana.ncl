;start procedure add3DComposedVars
procedure addresolucion(varNames,varNames2, fin,fin1,fout, dim_time, dim_lat, dim_lon) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

;begin

;*************************
; Lectura archivo wrf_dom1
;************************

domm      = "d01"
arch1     = "/ServerData/OWGIS/percentiles/Percentiles.nc"

;"/LUSTRE/HOME/fernando/operativo/EXTERNO-salidas/WRF/2017/11_noviembre/wrfout_"+domm+"_2017-11-21_00.nc"

wrf_dom1  = addfile(arch1,"r")
 nueva= new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
        
;T2_11=fin1->varNames(varIdx)
;printVarSummary(T2_11) 
; Matriz de datos fuente
m              = wrf_user_getvar(wrf_dom1,varNames(varIdx),-1) ; Se interpola solo un tiempo
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
nm              = wrf_user_getvar(fin,"T2",24)
nm              = nm-273

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

nueva= linint2(lon_wrf_1d1,lat_wrf_1d1,m,True,lon_wrf_1d2,lat_wrf_1d2,0) 

nm := nueva

     nueva@long_name = "Percentil "+varNames2(varIdx)+"% TEMP at 2 M" ;atributes
               nueva@description="Percentil "+varNames2(varIdx)+"% TEMP at 2 M" 
               nueva@standard_name = "Percentil "+varNames2(varIdx)+"% TEMP at 2 M"     ;atributes 
               nueva@units = "C" 

   filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude"/) ) ; time dimension
               filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
               fout->$varNames(varIdx)$ = (/nueva/)
;print(nueva)
; Se reemplaza la información de la matriz que se generó primero por la información que se obtuvo con interpolación

        print("Done!")
    end do
    ;end of variables cycle 
end																																																																																																																																																																																																																																																																						
;end procedure add4DCars 
