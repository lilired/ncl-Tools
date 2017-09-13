;start fuction addLon
function addLon(fin,fout) begin
    ; Adding longitude variable
    XLONG = fin->XLONG ;get variable in fin
    temp = dimsizes(XLONG)
    dim_lon = temp(2)
    lon = new(dim_lon,float)
    lon = XLONG(0,0,:)
    delete_VarAtts(lon,-1)
    lon@standard_name = "longitude";atributes
    lon@long_name= "Longitude";atributes
    lon@units = "degrees_east";atributes

    filedimdef(fout, (/"Longitude"/), dim_lon, (/ False /))
    filevardef(fout, "Longitude" ,typeof(lon),"Longitude") ; lon dimension
    filevarattdef(fout,"Longitude",lon)                  ; copy longitude attributes
    fout->Longitude  = (/lon/);add in file fout
    return dim_lon
end
;end fuction addLon
