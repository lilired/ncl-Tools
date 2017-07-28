procedure add3DComposedVars(varNames, fin,fout, dim_time, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

   
       ; ---------- For U_T01 ----------
        if(varNames(varIdx) .eq. "U_T01") then
          
           direccion = fin->dir

           u_t01=direccion
           u_t01=sin((direccion+180)*3.141516/180.)

            printVarSummary(u_t01)

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = u_t01
     
        end if

	; ---------- For V_T01 ----------
        if(varNames(varIdx) .eq. "V_T01") then
          
           direccion = fin->dir

           v_t01=direccion
           v_t01=cos((direccion+180)*3.141516/180.)	;printVarSummary(u)

            printVarSummary(v_t01)

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = v_t01
     
        end if

        ; ---------- For U_HS ----------
        if(varNames(varIdx) .eq. "U_HS") then
          
           direccion = fin->dir

           u_hs=direccion
           u_hs=sin((direccion+180)*3.141516/180.)

            printVarSummary(u_hs)

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = u_hs
     
        end if

        ; ---------- For V_HS ----------
        if(varNames(varIdx) .eq. "V_HS") then
          
           direccion = fin->dir

           v_hs=direccion
           v_hs=sin((direccion+180)*3.141516/180.)

            printVarSummary(v_hs)

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = v_hs
     
        end if


        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude" /) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)

        delete(newVar)
        print("Done!")
    end do
end
