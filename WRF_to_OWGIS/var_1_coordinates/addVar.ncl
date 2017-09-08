procedure addVar(varNames,fin,fout,dim_time) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$

        ;newVar = new((/dim_time/), "float", 0)
        ;newVar(:) = (/origVar/)

        
        if(varNames(varIdx) .eq. "HFX_FORCE") then
            origVar@long_name = "surface_upward_latent_heat_flux";
            origVar@standar_name = "surface_upward_latent_heat_flux";
        end if

        if(varNames(varIdx) .eq. "LH_FORCE") then
            origVar@long_name = "surface_upward_sensible_heat_flux";
            origVar@standar_name = "surface_upward_sensible_heat_flux";
        end if

	   
        filevardef(fout, varNames(varIdx) ,typeof(origVar), (/"Time"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),origVar); copy T attributes
        fout->$varNames(varIdx)$ = (/origVar/)
        delete(origVar)

        ;filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time"/) ) ; time dimension
     
        ;copy_VarAtts(origVar,newVar) ; Copy origial attributes
        ; delete_VarAtts(newVar, (/"coordinates"/))
     
        ;filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        ;fout->$varNames(varIdx)$ = (/newVar/)
        ;delete(newVar)
        ;delete(origVar)
        print("Done!")
    end do
end																																																																																																																																																																																																																																																																								
