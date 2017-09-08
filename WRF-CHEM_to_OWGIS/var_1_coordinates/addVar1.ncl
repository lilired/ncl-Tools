procedure addVar(varNames,fin,fout,dim_time) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$

        newVar = new((/dim_time/), "float", 0)
        newVar(:) = (/origVar/)

	       ; ---------- For HFX_FORCE ----------
        if(varNames(varIdx) .eq. "HFX_FORCE") then
          
            newVar@units = "W m-2"  ;
			newVar@long_name= "Sensible heat flux" ;
			newVar@standard_name = "Sensible heat flux" ;
			;varNames(varIdx) = "Uat10"
        	                  
        end if

	       ; ---------- For LX_FORCE ----------
        if(varNames(varIdx) .eq. "LX_FORCE") then
          
            newVar@units = "W m-2"  ;
			newVar@long_name= "Latent heat flux" ;
			newVar@standard_name = "Latent heat flux" ;
			;varNames(varIdx) = "Uat10"
        	                  
        end if

 
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
