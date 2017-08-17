procedure add3DVars(varNames,fin,fout,dim_time, dim_lat) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        
        if varNames(varIdx) .eq. "elev" then
           varNamesO=(/"zeta"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat/), "double", 0)
           newVar(:,:) = (/origVar/)
	   newVar@units= "m" ;
	   newVar@standard_name = "sea_surface_height_above_geoid" ;
	   newVar@long_name=  "water surface elevation above geoid" 
	      	
           ; ---- Copy the original variables 
           ;  copy_VarAtts(origVar,newVar) ; Copy origial attributes
         ;  delete_VarAtts(newVar, (/"coordinates"/))
	end if
    
        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude"/));time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end
