function addPrecAcu6(PRECH, fout, dim_lat, dim_lon) begin
    Time = fout->Time
    dim_timeprec6 = floattointeger(ceil(dimsizes(Time)/6))

    timePrecAcu6 = Time(0:dim_timeprec6*6-1:6) ;Time steps 
    timePrecAcu6@standard_name = "time"
    timePrecAcu6@long_name = "Time"
    timePrecAcu6@extra_info = "Time for prec acu 6"
    timePrecAcu6@units = Time@units
    timePrecAcu6@calendar = Time@calendar

    ; ------- Add the time dimension and variable to the file ---
    filedimdef(fout, (/"TimePreca6"/), dim_timeprec6, (/ False /))
    filevardef(fout, "TimePreca6", typeof(timePrecAcu6), (/"TimePreca6" /) ); Crea la variable en el NetCDF, con sus respectivos atributos y dimensiones
    filevarattdef(fout, "TimePreca6", timePrecAcu6)

    ; Crea la variable preca6 y escribe los nombres de las dimensiones
    preca6 = new( (/dim_timeprec6,dim_lat,dim_lon/) ,float)

    ; Crea los atributos de la variable
    preca6@description = "ACCUMULATED PRECIPITATION EACH 6 HRS/PRECIPITACION ACUMULADA CADA 6 HRS"
    preca6@units       = "mm"
    preca6@standard_name = "prec_acu_six"
    preca6@long_name     = "Precipitation Accu 6hr"

    ;print("Dims of PRECA6:"+(dim_timeprec6-1)+","+dim_lat+","+dim_lon)
    ;print("Dims of PRECH:"+dimsizes(PRECH))

    k = 0
    do while (k.lt.dim_timeprec6); Reliza el ciclo
        preca6(k,:,:) = (PRECH(k*6,:,:)+PRECH(k*6+1,:,:)+PRECH(k*6+2,:,:)+PRECH(k*6+3,:,:)+PRECH(k*6+4,:,:)+PRECH(k*6+5,:,:)); Realiza la operación
        k = k+1; 
    end do; Cierra loop

    ;Crea la variable PRECH en el NetCDF y la guarda en el NetCDF
    filevardef(fout, "PRECA6", typeof(preca6), (/"TimePreca6", "Latitude", "Longitude" /) ); Crea la variable en el NetCDF, con sus respectivos atributos y dimensiones
    filevarattdef(fout, "PRECA6", preca6)

    fout->PRECA6 = (/preca6/);Guarda la variable creada en el NetCDF                      
    fout->TimePreca6 = (/timePrecAcu6/)
    return preca6
end
