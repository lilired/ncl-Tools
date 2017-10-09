;start procedure add4DComposedVars
procedure add4DVarsA(varNames, fin,fout, dim_time, dim_presion, dim_lat, dim_lon) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

if(varNames(varIdx) .eq. "geo") then           
           
    print("Guardando variable geo")

    P        = fin->P
    PB       = fin->PB
    p        = (P+PB)*0.01
    PHB      = fin->PHB
PH       = fin->PH
    var      = PH
    var      = var + PHB
    z        = wrf_user_unstagger(var,var@stagger)

      presion = (/850, 700, 500, 200/)
    lat=fout->Latitude
    lon=fout->Longitude
    ;geo = z ; Defincion de atributos
    geo = wrf_user_intrp3d( z,p,"h",presion,0.,False)
    wrf_smooth_2d (geo, 3 )
   time=fout->Time
    geo!0           = "time"
    geo!1           = "level"
    geo!2           = "lat"
    geo!3           = "lon"
    geo@units       = "(m)"
    geo@long_name   = "m"
    geo@description = "Altura Geopotencial"
    geo&time        = ispan(0,time,1)
    geo&level       = presion
    geo&lat         =lat
    geo&lon         =lon
    geo&lat@units   = "degrees_north"
    geo&lon@units   = "degrees_east"
    geo@_FillValue  = 9.96921e+36
    geo@standar_name = "Altura Geopotencial";atributes
    ; Guardando en archivo NetCDF
   
    filevardef(fout, "geo",typeof(geo),getvardims(geo))
    filevarattdef (fout, "geo", geo)
    fout->geo = (/ geo /)
  end if
    filevardef(fout, "geo",typeof(geo),getvardims(geo))
    filevarattdef (fout, "geo", geo)
    fout->geo = (/ geo /)
;        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","presion","Latitude","Longitude" /) ) ; time dimension
 ;       filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
  ;      fout->$varNames(varIdx)$ = (/newVar/);add in file fout

        delete(newVar)
        print("Done!")
    end do
    ;end of variables cycle 
end
;end procedure add4DComposedVars
