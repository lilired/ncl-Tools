function addLat(fin,fout) begin
    ; Adding latitude variable
    XLAT = fin->XLAT
    latDims = dimsizes(XLAT)
    dim_lat = latDims(1)
    lat = new(dim_lat,float)
    lat = XLAT(0,:,0)
    lat2=lat(2:86)
    latDims = dimsizes(lat2)
    dim_lat = latDims(1)
    delete_VarAtts(lat2,-1)
    lat2@standard_name = "latitude"
    lat2@long_name= "Latitude"
    lat2@units = "degrees_north"
    filedimdef(fout, (/"Latitude"/), dim_lat , (/ False /))
    filevardef(fout, "Latitude" ,typeof(lat2),"Latitude") ; lat dimension
    filevarattdef(fout,"Latitude",lat2)                  ; copy latitude attributes
    fout->Latitude  = (/lat2/)
    return dim_lat
end
