function addDepth(fin,fout) begin
    ; Adding depth variable
     Depth = fin->Depth
    temp = dimsizes(Depth)

    dim_depth =(/temp,1/)
    depth = new(dim_depth,float)
    depth =  Depth(:)
    delete_VarAtts(depth,-1)
    depth@standard_name = "depth"
    depth@long_name= "Depth"
    depth@units = "m" ;
    depth@positive = "down" ;
    depth@axis = "Z" ;

    filedimdef(fout, (/"Depth"/), dim_depth , (/ False /))
    filevardef(fout, "Depth" ,typeof(depth),"Depth") ; depth dimension
    filevarattdef(fout,"Depth",depth)                  ; copy latitude attributes
    fout->Depth  = (/depth/)
    return dim_depth
end

