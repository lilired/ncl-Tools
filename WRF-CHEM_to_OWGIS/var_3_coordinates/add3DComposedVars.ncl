procedure add3DComposedVars(varNames, fin,fout, dim_time, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
dim_time=73
        ; ---------- For WS10 ----------
        if(varNames(varIdx) .eq. "WS10") then
            u10_1= fin->U10
            v10_1= fin->U10
u10=u10_1(:,2:86,2:86)
v10=v10_1(:,2:86,2:86)
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
printVarSummary(newVar)
            newVar = sqrt(u10^2 + v10^2)*3.6
            newVar@units = "km/hr"
        end if

        ; ---------- For PREC2 ----------
        if(varNames(varIdx) .eq. "PREC2") then
            rainc_1= fin->RAINC
            rainnc_1= fin->RAINNC
rainc=rainc_1(:,2:86,2:86)
rainnc=rainnc_1(:,2:86,2:86)

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = rainc+rainnc
        end if

        ; ---------- For T2C ----------
        if(varNames(varIdx) .eq. "T2C") then
            t2_1= fin->T2
t2=t2_1(:,2:86,2:86)

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = t2-273.15
            newVar@units = "C"
        end if

        ; ---------- For SSTC----------
        if(varNames(varIdx) .eq. "SSTC") then
            sst_1= fin->SST
sst=sst_1(:,2:86,2:86)

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = sst-273.15
            newVar@units = "C"
        end if

        ; ---------- For PREC2B----------
        if(varNames(varIdx) .eq. "PREC2B") then
            temp_1= fout->PREC2
temp=temp_1(:,2:86,2:86)

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
