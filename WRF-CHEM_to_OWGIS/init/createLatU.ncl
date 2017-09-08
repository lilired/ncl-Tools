function addLatU(fin,fout) begin
    ; Adding latitude variable
    XLATU = fin->XLAT_U
    temp = dimsizes(XLATU)
    dim_latU = temp(1)
    latU = new(dim_latU,float)
    latU = XLATU(0,:,0)
    delete_VarAtts(latU,-1)
    latU@standard_name = "latitude"
    latU@long_name= "Latitude"
    latU@units = "degrees_north"
    filedimdef(fout, (/"Latitude_U"/), dim_latU , (/ False /))
    filevardef(fout, "Latitude_U" ,typeof(latU),"Latitude") ; lat dimension
    filevarattdef(fout,"Latitude_U",latU)                  ; copy latitude attributes
    fout->Latitude_U = (/latU/)
    return dim_latU
end
