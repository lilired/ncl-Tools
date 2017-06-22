function addLonV(fin,fout) begin
    ; Adding longitude variable
    XLONGV = fin->XLONG_V
    temp = dimsizes(XLONGV)
    dim_lonV = temp(2)
    lonV = new(dim_lonV,float)
    lonV = XLONGV(0,0,:)
    delete_VarAtts(lonV,-1)
    lonV@standard_name = "longitude"
    lonV@long_name= "Longitude"
    lonV@units = "degrees_east"

    filedimdef(fout, (/"Longitude_V"/), dim_lonV, (/ False /))
    filevardef(fout, "Longitude_V" ,typeof(lonV),"Longitude_V") ; lon dimension
    filevarattdef(fout,"Longitude_V",lonV)                  ; copy longitude attributes
    fout->Longitude_V = (/lonV/)
    return dim_lonV
end
