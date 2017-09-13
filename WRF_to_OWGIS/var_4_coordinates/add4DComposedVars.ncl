;start procedure add4DComposedVars
procedure add4DComposedVars(varNames, fin,fout, dim_time, dim_depth, dim_lat, dim_lon) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

        ;valid if there are variables PA
        ; ---------- For PA ----------
        if(varNames(varIdx) .eq. "PA") then
            p= fin->P;get variable in fin
            pb= fin->PB;get variable in fin

            newVar = new( (/dim_time, dim_depth, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar = p+pb          ;assing  p+pb to newVar 
        end if
  
       ;valid if there are variables RH
       ; ---------- For RH ----------
        if(varNames(varIdx) .eq. "RH") then
           qv = fin->QVAPOR               ;get variable in fin
           P  = fin->P                     ; perturbation;get variable in fin
           Pb = fin->PB                    ; base state pressure;get variable in fin
           P  = P + Pb                   ; total pressure;get variable in fin

           theta = fin->T                  ; perturbation potential temperature (theta+t0);get variable in fin
           theta = theta + 300.  ;calculate

           TK = wrf_tk (P, theta);function wrf for calculate tk
           RH = wrf_rh (qv, P, TK);function wrf for calculate rh

           ;printVarSummary(RH)

           newVar = new( (/dim_time, dim_depth, dim_lat, dim_lon/),"float", 0);declare variable newVar
           newVar = RH            ;assing RH to newVar 
           newVar@long_name = "relative_humidity";atributes
           newVar@standard_name = "relative_humidity"      ;atributes 
        end if
 
        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Depth","Latitude","Longitude" /) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/);add in file fout

        delete(newVar)
        print("Done!")
    end do
    ;end of variables cycle 
end
;end procedure add4DComposedVars
