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

       ; ---------- For RH ----------
        if(varNames(varIdx) .eq. "RH") then
           qv = fin->QVAPOR
           P  = fin->P                     ; perturbation
           Pb = fin->PB                    ; base state pressure
           P  = P + Pb                   ; total pressure

           theta = fin->T                  ; perturbation potential temperature (theta+t0)
           theta = theta + 300.

           TK = wrf_tk (P, theta)
           RH = wrf_rh (qv, P, TK)

           printVarSummary(RH)

           newVar = new( (/dim_time, dim_depth, dim_lat, dim_lon/),"float", 0)
           newVar = RH
           newVar@long_name = "relative_humidity"
           newVar@standard_name = "relative_humidity"       
        end if
 
        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Depth","Latitude","Longitude" /) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)

        delete(newVar)
        print("Done!")
    end do
end
