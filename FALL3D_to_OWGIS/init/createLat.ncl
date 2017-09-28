function addLat(fin,fout) begin
    ; Adding latitude variable
    latitude = fin->lat
    temp = dimsizes(latitude)
    dim_lat = temp
    lat = new(dim_lat,double)
;printVarSummary(lat)
;printVarSummary(latitude)

    lat = latitude
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
