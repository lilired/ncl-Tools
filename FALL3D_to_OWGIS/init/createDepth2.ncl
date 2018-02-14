function addDepth2(fin,fout) begin
    ; Adding latitude variable
    ZNU = fin[0]->alt
    temp = dimsizes(ZNU)

    dim_depth2 = temp(0)
    depth2 = new(dim_depth2,float)
    depth2 = ZNU
   ; delete_VarAtts(depth,-1)
    depth2@standard_name = "depth2"
    depth2@long_name= "depth2"
   ; depth2@units = "m" ;
    depth2@positive = "down" ;
    depth2@axis = "Z" ;

    filedimdef(fout, (/"Depth2"/), dim_depth2 , (/ False /))
    filevardef(fout, "Depth2" ,typeof(depth2),"Depth2") ; depth dimension
    filevarattdef(fout,"Depth2",depth2)                  ; copy latitude attributes
    fout->Depth2  = (/depth2/)
    return dim_depth2
end
