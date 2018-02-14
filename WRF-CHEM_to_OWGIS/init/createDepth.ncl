function addDepth(fin,fout) begin
    ; Adding latitude variable
;*****************************************************************************************

               Ph_1  = fin->PH                     ; perturbation;get variable in fin
               Phb_1=fin->PHB
     PH= Ph_1(:,:,2:86,2:86)
     PHB= Phb_1(:,:,2:86,2:86)
printVarSummary(PH)
printVarSummary(PHB)
Altura_en_metros= (PH+PHB)/9.81
printVarSummary(Altura_en_metros)
;i -  dimension este-oeste
;j - dimension norte-sur
;k - dimension vertical
    ZNU = Altura_en_metros(0,1:29,0,0)
;******************************************************************************************

    temp = dimsizes(ZNU)
    dim_depth = temp
    depth = new(dim_depth,float)
    ; Only if Flipping the depth dimension
    ;depth = ZNU(0,::-1)
    depth = ZNU(:)
    delete_VarAtts(depth,-1)
    depth@standard_name = "depth"
    depth@long_name= "ZNU"
    depth@axis = "Z"
    depth@units = "m" ;
    filedimdef(fout, (/"Depth"/), dim_depth , (/ False /))
    filevardef(fout, "Depth" ,typeof(depth),"Depth") ; depth dimension
    filevarattdef(fout,"Depth",depth)                  ; copy latitude attributes
    fout->Depth  = (/depth/)
    return dim_depth
end
