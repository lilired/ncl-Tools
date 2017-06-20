procedure add3DVars4(varNames,fin,fout,dim_time,dim_depth,dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$
printVarSummary(origVar)
        newVar = new((/dim_time,dim_depth,dim_lat, dim_lon/), "float", 0)
printVarSummary(newVar)        
newVar(:,:,:,:) = (/origVar/)

																																																																																																																																																								
        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Depth","Latitude","Longitude"/) ) ; time dimension
print(fout)
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
print(fout)
printVarSummary(varNames(varIdx))

otra=(varNames(0))
otra2= (/newVar/)	
printVarSummary(otra)
printVarSummary(otra2)
        fout->$varNames(varIdx)$ = (/newVar/)					
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																							
