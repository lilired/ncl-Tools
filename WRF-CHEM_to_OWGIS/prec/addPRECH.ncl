function addPRECH(fin,fout,Time,dim_time, dim_lat, dim_lon) begin
    print("Adding TimePRECH...")
    timePrech = Time(0:dim_time-2) ;Time steps 
    timePrech@standard_name = "time"
    timePrech@long_name = "Time PRECH"
    timePrech@units = Time@units
    timePrech@calendar = Time@calendar
    filedimdef(fout, (/"TimePRECH"/), (dim_time-1)  , (/ False/))
    filevardef(fout, "TimePRECH", typeof(timePrech), (/"TimePRECH" /) ); Crea la variable en el NetCDF, con sus respectivos atributos y dimensiones
    filevarattdef(fout, "TimePRECH", timePrech)
    fout->TimePRECH = (/timePrech/)
    print("Done!")

    ; ---------------------  Add the PRECH variable ------
    print("Adding PRECH...")
    PREC2B = fout->PREC2B; Toma la variable PREC2B del archivo                 

    ; Crea la variable prech y escribe los nombres de las dimensiones
    ;print("Dims of PRECH:"+(dim_time-1)+","+dim_lat+","+dim_lon)
    ;print("Dims of PREC2B:"+dimsizes(PREC2B))
    prech = new( (/dim_time-1,dim_lat,dim_lon/) ,float)
    ;
    ; Crea los atributos de la variable
    prech@description = "HOURLY PRECIPITATION/PRECIPITACIÓN HORARIA"
    prech@units       = "mm"
    prech@standard_name = "acc_prec"
    prech@long_name     = "Hourly precipitation"

    ;Llena los datos de la variable
    prech(:,:,:)= PREC2B(1:dim_time-1,:,:)-PREC2B(0:dim_time-2,:,:); Hace la operacion aritmetica de la precipitacion horaria

    ;Crea la variable PRECH en el NetCDF y la guarda en el NetCDF
    filevardef(fout, "PRECH", typeof(prech), (/"TimePRECH", "Latitude", "Longitude" /) ); Crea la variable en el NetCDF, con sus respectivos atributos y dimensiones
    filevarattdef(fout, "PRECH", prech)

    fout->PRECH = (/prech/);Guarda la variable creada en el NetCDF                      
    return prech
end
