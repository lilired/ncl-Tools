function addLon(fin,fout) begin
    ; Adding longitude variable
    longitude = fin->longitude
    temp = dimsizes(longitude)
    dim_lon = temp
    lon = new(dim_lon,float)
    lon = longitude(:)
    delete_VarAtts(lon,-1)
    lon@standard_name = "longitude"
    lon@long_name= "Longitude"
    lon@units = "degrees_east"

    filedimdef(fout, (/"Longitude"/), dim_lon, (/ False /))
    filevardef(fout, "Longitude" ,typeof(lon),"Longitude") ; lon dimension
    filevarattdef(fout,"Longitude",lon)                  ; copy longitude attributes
    fout->Longitude  = (/lon/)
    return dim_lon
end
