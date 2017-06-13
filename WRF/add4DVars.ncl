procedure add4DVars(varNames,dominio,fin,fout,dim_time, dim_depth, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$
   if(dominio .eq. 1) then																																																																																																																																																																																																																																																																																																																																																																																																																																
              dim_lon=326
print(dim_lon)
             end if 
        newVar = new((/dim_time, dim_depth, dim_lat, dim_lon/), "float", 0)
        newVar(:,:,:,:) = (/origVar/)

printVarSummary(origVar)

printVarSummary(newVar)

		
       filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Depth","Latitude","Longitude" /) ) ; time dimension
        ;copy_VarAtts(origVar,newVar) ; Copy origial attributes
print("2 voy aqui")  
       ; delete_VarAtts(newVar, (/"coordinates"/))
printVarSummary(newVar)
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
prin																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																								t(fout)
otra=(/newVar/)
printVarSummary(otra)
        fout->$varNames(varIdx)$ = (/newVar/)
print(fout)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end																																																																																																																																																																																																																																																																								
