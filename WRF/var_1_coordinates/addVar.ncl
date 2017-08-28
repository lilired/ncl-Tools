procedure addVar(varNames,fin,fout,dim_time) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$


; --- Add specific attributes ----
        ; ---------- For HFX ----------
        if(varNames(varIdx) .eq. "HFX_FORCE") then
        newVar = new((/dim_time/), "float", 0)
        newVar(:) = (/origVar/)
 copy_VarAtts(origVar,newVar) ; Copy origial attributes

   newVar@long_name= "sensible heat flux " ;
			newVar@standard_name = "sensible heat flux " ;
			
	
        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time"/) ) ; time dimension
     
       

        end if


        ; ---------- For LH ----------
        if(varNames(varIdx) .eq. "LH_FORCE") then
        newVar = new((/dim_time/), "float", 0)
        newVar(:) = (/origVar/)
 copy_VarAtts(origVar,newVar) ; Copy origial attributes

   newVar@long_name= "Latent heat flux" ;
			newVar@standard_name = "Latent heat flux" ;
			
	
        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time"/) ) ; time dimension
     
       

        end if







        ; delete_VarAtts(newVar, (/"coordinates"/))
     
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end																																																																																																																																																																																																																																																																								
