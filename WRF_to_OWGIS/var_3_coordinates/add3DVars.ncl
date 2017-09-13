;start procedure add3DVars
procedure add3DVars(varNames,fin,fout,dim_time, dim_lat, dim_lon) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$;get variable in fin

        newVar = new((/dim_time, dim_lat, dim_lon/), "float", 0);declare variable newVar
        newVar(:,:,:) = (/origVar/);assing origVar to newVar 

	; --- Add specific attributes ----
        ; ---------- For U10 ----------
        if(varNames(varIdx) .eq. "U10") then
			newVar@units = "m/s" ;;atributes
			newVar@long_name= "U at 10 M" ;;atributes
			newVar@standard_name = "eastward_wind_ten_velocity" ;;atributes
			varNames(varIdx) = "Uat10";atributes
        	print("Adding as "+varNames(varIdx)+"...")
        end if

        ; ---------- For V10 ----------
        if(varNames(varIdx) .eq. "V10") then
			newVar@units = "m/s" ;;atributes
			newVar@long_name= "V at 10 M" ;;atributes
			newVar@standard_name = "northward_wind_ten_velocity" ;;atributes;atributes
			varNames(varIdx) = "Vat10"
        	print("Adding as "+varNames(varIdx)+"...")
        end if

     
        ; ---------- For QFX ----------
        if(varNames(varIdx) .eq. "QFX") then
			newVar@long_name= "Evaporation" ;;atributes
			newVar@standard_name = "Evaporation" ;;atributes
			Print("Adding as "+varNames(varIdx)+"...")
        end if

        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude" /) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/);add in file fout
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
    ;end of variables cycle 
end
;end procedure add3DVars
