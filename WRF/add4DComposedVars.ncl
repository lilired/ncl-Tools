procedure add4DComposedVars(varNames, fin,fout, dim_time, dim_depth, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

        ; ---------- For PA ----------
        if(varNames(varIdx) .eq. "PA") then
            p= fin->P
            pb= fin->PB

            newVar = new( (/dim_time, dim_depth, dim_lat, dim_lon/),"float", 0)
            newVar = p+pb
        end if

        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Depth","Latitude","Longitude" /) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)

        delete(newVar)
        print("Done!")
    end do
end
