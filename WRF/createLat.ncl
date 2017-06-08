function addLat(fin,fout) begin
    ; Adding latitude variable
    XLAT = fin->XLAT
    temp = dimsizes(XLAT)
    dim_lat = temp(1)
    lat = new(dim_lat,float)
    lat = XLAT(0,:,0)
    delete_VarAtts(lat,-1)
    lat@standard_name = "latitude"
    lat@long_name= "Latitude"
    lat@units = "degrees_north"
    filedimdef(fout, (/"Latitude"/), dim_lat , (/ False /))
    filevardef(fout, "Latitude" ,typeof(lat),"Latitude") ; lat dimension
    filevarattdef(fout,"Latitude",lat)                  ; copy latitude attributes
    fout->Latitude  = (/lat/)
    return dim_lat
end
