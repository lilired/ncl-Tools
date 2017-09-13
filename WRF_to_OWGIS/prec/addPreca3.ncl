;start procedure addPrecAcu3
function addPrecAcu3(PRECH, fout, dim_lat, dim_lon) begin
    Time = fout->Time
    dim_timeprec3 = floattointeger(ceil(dimsizes(Time)/3))

    timePrecAcu3 = Time(0:dim_timeprec3*3-1:3) ;Time steps 
    timePrecAcu3@standard_name = "time";atributes
    timePrecAcu3@long_name = "Time";atributes
    timePrecAcu3@extra_info = "Time for prec acu 3";atributes
    timePrecAcu3@units = Time@units;atributes
    timePrecAcu3@calendar = Time@calendar;atributes

    ; ------- Add the time dimension and variable to the file ---
    filedimdef(fout, (/"TimePreca3"/), dim_timeprec3, (/ False /))
    filevardef(fout, "TimePreca3", typeof(timePrecAcu3), (/"TimePreca3" /) ); Crea la variable en el NetCDF, con sus respectivos atributos y dimensiones
    filevarattdef(fout, "TimePreca3", timePrecAcu3)

    ; Crea la variable preca3 y escribe los nombres de las dimensiones
    preca3 = new( (/dim_timeprec3,dim_lat,dim_lon/) ,float)

    ; Crea los atributos de la variable
    preca3@description = "ACCUMULATED PRECIPITATION EACH 3 HRS/PRECIPITACION ACUMULADA CADA 3 HRS"
    preca3@units       = "mm"
    preca3@standard_name = "prec_acu_three"
    preca3@long_name     = "Precipitation Accu 3hr"

    ;print("Dims of PRECA3:"+(dim_timeprec3-1)+","+dim_lat+","+dim_lon)
    ;print("Dims of PRECH:"+dimsizes(PRECH))

    ;Llena los datos de la variable
    ;preca3(:,:,:) = PRECH(0:dim_timeprec3-3:3,:,:)+PRECH(1:dim_timeprec3-2:3,:,:)+PRECH(2:dim_timeprec3-1:3,:,:); Realiza la operación
    k = 0
    do while (k.lt.dim_timeprec3); Reliza el ciclo
        preca3(k,:,:) = (PRECH(k*3,:,:)+PRECH(k*3+1,:,:)+PRECH(k*3+2,:,:)); Realiza la operación
        k = k+1; Incrementa en 3 la variable debido a que se van sumando de 3 en 3 Por ejemplo preca3(1)=1+2+3 preca3(2)=4+5+6 
    end do; Cierra loop

    ;Crea la variable PRECH en el NetCDF y la guarda en el NetCDF
    filevardef(fout, "PRECA3", typeof(preca3), (/"TimePreca3", "Latitude", "Longitude" /) ); Crea la variable en el NetCDF, con sus respectivos atributos y dimensiones
    filevarattdef(fout, "PRECA3", preca3)

    fout->PRECA3 = (/preca3/);Guarda la variable creada en el NetCDF    ;add in file fout                  
    fout->TimePreca3 = (/timePrecAcu3/);add in file fout
    return preca3
end
;end procedure addPrecAcu3
