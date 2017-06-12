procedure add4DVars(varNames,fin,fout,dim_time, dim_depth, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$
        newVar = new((/dim_time, dim_depth, dim_lat, dim_lon/), "float", 0)
        newVar(:,:,:,:) = (/origVar/)


; --- Add specific attributes ----
        ; ---------- For P ----------
      ;  if(varNames(varIdx) .eq. "QVAPOR") then
	;		newVar@units = "kg kg-1" ;
	;		newVar@long_name= "Relative Humidity"
	;		newVar@standard_name = "Water vapor mixing ratio" ;
	;		varNames(varIdx) = "qv"
        ;	print("Adding as "+varNames(varIdx)+"...")
        ;end if



       filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Depth","Latitude","Longitude" /) ) ; time dimension
        copy_VarAtts(origVar,newVar) ; Copy origial attributes
        delete_VarAtts(newVar, (/"coordinates"/))

        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end
