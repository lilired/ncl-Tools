procedure add3DComposedVars(varNames, fin,fout, dim_time, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

        ; ---------- For WS10 ----------
        if(varNames(varIdx) .eq. "WS10") then
            u10= fin->U10
            v10= fin->U10

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = sqrt(u10^2 + v10^2)*3.6
            newVar@units = "km/hr"
        end if

        ; ---------- For PREC2 ----------
        if(varNames(varIdx) .eq. "PREC2") then
            rainc= fin->RAINC
            rainnc= fin->RAINNC

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = rainc+rainnc
        end if

        ; ---------- For T2C ----------
        if(varNames(varIdx) .eq. "T2C") then
            t2= fin->T2
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = t2-273.15
            newVar@units = "C"
        end if

        ; ---------- For SSTC----------
        if(varNames(varIdx) .eq. "SSTC") then
            sst= fin->SST
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = sst-273.15
            newVar@units = "C"
        end if

        ; ---------- For PREC2B----------
        if(varNames(varIdx) .eq. "PREC2B") then
            temp= fout->PREC2
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = temp*1
        end if


        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude" /) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)

        delete(newVar)
        print("Done!")
    end do
end
