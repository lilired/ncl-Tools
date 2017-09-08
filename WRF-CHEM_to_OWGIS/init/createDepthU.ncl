function addDepthU(fin,fout) begin
    ; Adding latitude variable
    ZNW = fin->ZNW
    temp = dimsizes(ZNW)
    dim_depthU = temp(1)
    depthU = new(dim_depthU,float)
    depthU = ZNW(0,:)
    delete_VarAtts(depthU,-1)
    depthU@standard_name = "depthU"
    depthU@long_name= "ZNW"
    filedimdef(fout, (/"Depth_U"/), dim_depthU , (/ False /))
    filevardef(fout, "Depth_U" ,typeof(depthU),"Depth_U") ; depth dimension
    filevarattdef(fout,"Depth_U",depthU)                  ; copy latitude attributes
    fout->Depth_U  = (/depthU/)
    return dim_depthU
end
