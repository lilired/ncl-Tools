;start fuction addDepth
function addDepth(fin,fout) begin
    ; Adding latitude variable
    ZNU =  (/850, 700, 500, 200/);fin->ZNU;get variable in fin
    temp = dimsizes(ZNU)

    dim_depth = temp(0)
    depth = new(dim_depth,float)
    depth = ZNU
    delete_VarAtts(depth,-1)
    depth@standard_name = "depth";atributes
    depth@units = "Pressure";atributes
    depth@long_name= "ZNU";atributes
    depth@axis = "Z";atributes
    filedimdef(fout, (/"Depth"/), dim_depth , (/ False /))
    filevardef(fout, "Depth" ,typeof(depth),"Depth") ; depth dimension
    filevarattdef(fout,"Depth",depth)                  ; copy latitude attributes
    fout->Depth  = (/depth/);add in file fout
    return dim_depth
end
;end fuction addDepth
