function addDepth(fin,fout) begin
    ; Adding latitude variable
    ZNU = fin->ZNU
    temp = dimsizes(ZNU)

    dim_depth = temp(1)
    depth = new(dim_depth,float)
    depth = ZNU(0,:)
    delete_VarAtts(depth,-1)
    depth@standard_name = "depth"
    depth@long_name= "ZNU"
depth@positive = "down" ;
    depth@axis = "Z" ;
    filedimdef(fout, (/"Depth"/), dim_depth , (/ False /))
    filevardef(fout, "Depth" ,typeof(depth),"Depth") ; depth dimension
    filevarattdef(fout,"Depth",depth)                  ; copy latitude attributes
    fout->Depth  = (/depth/)
    return dim_depth
end
