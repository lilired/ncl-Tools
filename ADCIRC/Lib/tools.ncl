; Function to create 1D arrays
function createArray(size)
begin
    myarray = new(size,float)
    do n=0,size-1
        myarray(n) = n
    end do 
    return myarray
end

; Function to split year,month,day from a string with a date
function getDate(strDate)
begin
    date = str_split(strDate(0),"-")
    return (/date(0), date(1), date(2)/)
end

; This function will copy one variable from the original netcdf file
; to the new one. 'varNames' is an array
procedure copyVarExactly(varNames,fin,fout) begin
    ; Adding latitude variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$
        filevardef(fout, varNames(varIdx) ,typeof(origVar), getvardims(origVar)) ; time dimension
        filevarattdef(fout,varNames(varIdx),origVar); copy T attributes
        fout->$varNames(varIdx)$ = origVar
        delete(origVar)
    end do
end

; This function copies one variable from the original netCDF to the new one
; but with a different name.
procedure copyVarReplaceName(varNames,newNames, fin,fout) begin
    ; Adding latitude variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+" as "+ newNames(varIdx))
        origVar = fin->$varNames(varIdx)$

		; Verify if we need to create it as a new dimension
        filevardef(fout, newNames(varIdx) ,typeof(origVar), getvardims(origVar)) ; time dimension
        filevarattdef(fout, newNames(varIdx),origVar); copy T attributes
        fout->$newNames(varIdx)$ = origVar
        delete(origVar)
    end do
end



