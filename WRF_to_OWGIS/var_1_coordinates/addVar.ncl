;start procedure addVar
procedure addVar(varNames,fin,fout,dim_time) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$;get variable in fin
      
        ;valid if there are variable hfx_force
        if(varNames(varIdx) .eq. "HFX_FORCE") then
            origVar@long_name = "surface_upward_latent_heat_flux";;atributes
            origVar@standar_name = "surface_upward_latent_heat_flux";;atributes
        end if

        ;valid if there are variable lh_force
        if(varNames(varIdx) .eq. "LH_FORCE") then
            origVar@long_name = "surface_upward_sensible_heat_flux";;atributes
            origVar@standar_name = "surface_upward_sensible_heat_flux";;atributes
        end if
   
        filevardef(fout, varNames(varIdx) ,typeof(origVar), (/"Time"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),origVar); copy T attributes
        fout->$varNames(varIdx)$ = (/origVar/);add in file fout
        delete(origVar)
        print("Done!")
    end do
    ;end of variables cycle 
end			
;end procedure addVar 																																																																																																																																																																																																																																																																					
