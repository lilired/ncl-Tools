procedure add3DVars(varNames,fin,fout,dim_time, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar2 = fin->$varNames(varIdx)$
   
        origVar=origVar2(:,2:86,2:86)
  
        newVar = new((/dim_time, dim_lat, dim_lon/), "float", 0)
        newVar(:,:,:) = (/origVar/)

		; ---- Copy the original variables 
        ;copy_VarAtts(origVar,newVar) ; Copy origial attributes
        ;delete_VarAtts(newVar, (/"coordinates"/))
        

		; --- Add specific attributes ----
        ; ---------- For U10 ----------
        if(varNames(varIdx) .eq. "U10") then
			newVar@units = "km/hr" ;
			newVar@long_name= "U at 10 M" ;
			newVar@standard_name = "eastward_wind_ten_velocity" ;
			varNames(varIdx) = "Uat10"
        	print("Adding as "+varNames(varIdx)+"...")
        end if

        ; ---------- For V10 ----------
        if(varNames(varIdx) .eq. "V10") then
			newVar@units = "km/hr" ;
			newVar@long_name= "V at 10 M" ;
			newVar@standard_name = "northward_wind_ten_velocity" ;
			varNames(varIdx) = "Vat10"
        	print("Adding as "+varNames(varIdx)+"...")
        end if

     
        ; ---------- For QFX ----------
        if(varNames(varIdx) .eq. "QFX") then
			;newVar@units = "m/s" ;
			newVar@long_name= "Evaporation" ;
			newVar@standard_name = "Evaporation" ;
			;varNames(varIdx) = "Vat10"
        	print("Adding as "+varNames(varIdx)+"...")
        end if
   
        ; ---------- For PBLH ----------
        if(varNames(varIdx) .eq. "PBLH") then
			newVar@long_name= "boundary layer height" ;
			newVar@standard_name = "PBLH" ;
			newVar@units = "m" 
        	print("Adding as "+varNames(varIdx)+"...")
        end if

             

        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude" /) ) ; time dimension

        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end
