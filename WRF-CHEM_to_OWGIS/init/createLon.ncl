function addLon(fin,fout) begin
    ; Adding longitude variable
    XLONG = fin->XLONG
    temp = dimsizes(XLONG)
    dim_lon = temp(2)
    lon = new(dim_lon,float)
    lon = XLONG(0,0,:)
lon2=lon (2:86)
temp = dimsizes(lon2)
dim_lon= temp(1)
    delete_VarAtts(lon2,-1)
    lon2@standard_name = "longitude"
    lon2@long_name= "Longitude"
    lon2@units = "degrees_east"

    filedimdef(fout, (/"Longitude"/), dim_lon, (/ False /))
    filevardef(fout, "Longitude" ,typeof(lon2),"Longitude") ; lon dimension
    filevarattdef(fout,"Longitude",lon2)                  ; copy longitude attributes
    fout->Longitude  = (/lon2/)
    return dim_lon
end
