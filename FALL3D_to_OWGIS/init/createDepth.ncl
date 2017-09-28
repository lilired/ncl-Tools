function addDepth(fin,fout) begin
    ; Adding latitude variable
    ;ZNU = fin->ZNU
ZNU=(/0,50,100,150,200,250,300,350,400/)

    temp = dimsizes(ZNU)

    dim_depth = temp(0)
    depth = new(dim_depth,float)
    depth = ZNU(:)
   ; delete_VarAtts(depth,-1)
    depth@standard_name = "depth"
    depth@long_name= "depth"
   ; depth@units = "m" ;
    depth@positive = "down" ;
    depth@axis = "Z" ;

    filedimdef(fout, (/"Depth"/), dim_depth , (/ False /))
    filevardef(fout, "Depth" ,typeof(depth),"Depth") ; depth dimension
    filevarattdef(fout,"Depth",depth)                  ; copy latitude attributes
    fout->Depth  = (/depth/)
    return dim_depth
end
