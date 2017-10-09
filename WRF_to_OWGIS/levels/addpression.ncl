;start procedure addpression
procedure addpression(fin,fout,dim_time, dim_lat, dim_lon) begin
   
P        = fin->P
PB       = fin->PB
p        = (P+PB)*0.01
PH       = fin->PH
PHB      = fin->PHB
T        = fin->T
W        = fin->W
var      = PH
var      = var + PHB
z        = wrf_user_unstagger(var,var@stagger)
T        = T + 300.
P        = P + PB
t        = wrf_tk(P,T)

    ;Distintos niveles de Presion
    pressure_levels =(/250, 500, 700, 850/);set variable

    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(pressure_levels)-1,1 ; This loop iterates over the variables
        print(" variables for pressure level:"+ pressure_levels(varIdx) )

        geo = wrf_user_intrp3d( z,p,"h",pressure_levels(varIdx),0.,False)
        wrf_smooth_2d (geo, 3 )
   
        geoNew = new((/dim_time,dim_lat,dim_lon/),double)
        geoNew = geo ; km/hr
      
        geoNew!0           = "Time"
        geoNew!1           = "Latitude"
        geoNew!2           = "Longitude"
        geoNew@units       = "(m)"
        geoNew@long_name   = "m"
        geoNew@description = "Altura Geopotencial"
    
    ; Guardando en archivo NetCDF
        ;Se guardan U,V a diferentes niveles de presion 200,500,700,850
        geoName = "geo"+pressure_levels(varIdx)


        filevardef(fout, geoName, typeof(geoNew),(/"Time","Latitude","Longitude" /) ); time dimension

       ; filevarattdef(fout,wsName,spd); copy u_plane attributes

        fout->$geoName$= (/geoNew/);;add in file fout
        
        print("Done!")
        delete(geoNew)

    end do
    ;end of variables cycle 
end
;end procedure addInter

