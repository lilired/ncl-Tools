function addLonU(fin,fout) begin
    ; Adding longitude variable
    XLONGU = fin->XLONG_U
    temp = dimsizes(XLONGU)
    dim_lonU = temp(2)
    lonU = new(dim_lonU,float)
    lonU = XLONGU(0,0,:)
    delete_VarAtts(lonU,-1)
    lonU@standard_name = "longitude"
    lonU@long_name= "Longitude"
    lonU@units = "degrees_east"

    filedimdef(fout, (/"Longitude_U"/), dim_lonU, (/ False /))
    filevardef(fout, "Longitude_U" ,typeof(lonU),"Longitude_U") ; lon dimension
    filevarattdef(fout,"Longitude_U",lonU)                  ; copy longitude attributes
    fout->Longitude_U = (/lonU/)
    return dim_lonU
end
