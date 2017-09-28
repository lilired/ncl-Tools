;start fuction addDepth
function addDepth(fin,fout) begin
    ; Adding latitude variable
    ZNU = fin->ZNU;get variable in fin
    temp = dimsizes(ZNU)

    dim_depth = temp(1)
    depth = new(dim_depth,float)
    depth = ZNU(0,:)
    delete_VarAtts(depth,-1)
    depth@standard_name = "depth";atributes
    depth@long_name= "ZNU";atributes
    depth@axis = "Z";atributes
    filedimdef(fout, (/"Depth"/), dim_depth , (/ False /))
    filevardef(fout, "Depth" ,typeof(depth),"Depth") ; depth dimension
    filevarattdef(fout,"Depth",depth)                  ; copy latitude attributes
    fout->Depth  = (/depth/);add in file fout
    return dim_depth
end
;end fuction addDepth
