;start procedure add3DVars
procedure add3DVars(varNames,fin,fout,dim_time, dim_lat, dim_lon) begin
      ;start of variables cycle 
      ;;;;;;; Iterate over all the files and add each variable
      do varIdx =0,0;dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin[:]->$varNames(varIdx)$
printVarSummary(origVar)
        newVar = new((/dim_time, dim_lat, dim_lon/), "float", 0);declare variable newVar
printVarSummary(newVar)
        newVar(:,:,:) = (/origVar/);assing origVar to newVar 


        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude" /) ) ; time dimension
        copy_VarAtts(origVar,newVar) ; Copy origial attributes
       
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes

        fout->$varNames(varIdx)$ = (/newVar/);add in file fout
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
    ;end of variables cycle 
end
;end procedure add3DVars 
