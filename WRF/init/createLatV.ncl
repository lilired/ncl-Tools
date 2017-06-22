function addLatV(fin,fout) begin
    ; Adding latitude variable
    XLATV = fin->XLAT_V
    temp = dimsizes(XLATV)
    dim_latV = temp(1)
    latV = new(dim_latV,float)
    latV = XLATV(0,:,0)
    delete_VarAtts(latV,-1)
    latV@standard_name = "latitude"
    latV@long_name= "Latitude"
    latV@units = "degrees_north"
    filedimdef(fout, (/"Latitude_V"/), dim_latV , (/ False /))
    filevardef(fout, "Latitude_V" ,typeof(latV),"Latitude") ; lat dimension
    filevarattdef(fout,"Latitude_V",latV)                  ; copy latitude attributes
    fout->Latitude_V = (/latV/)
    return dim_latV
end
