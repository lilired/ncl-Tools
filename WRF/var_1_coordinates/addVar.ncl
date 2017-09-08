procedure addVar(varNames,fin,fout,dim_time) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$

        newVar = new((/dim_time/), "float", 0)
        newVar(:) = (/origVar/)

	
        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time"/) ) ; time dimension
     
        copy_VarAtts(origVar,newVar) ; Copy origial attributes
        ; delete_VarAtts(newVar, (/"coordinates"/))
     
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end																																																																																																																																																																																																																																																																								
