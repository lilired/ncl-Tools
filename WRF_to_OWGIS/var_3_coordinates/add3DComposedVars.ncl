;start procedure add3DComposedVars
procedure add3DComposedVars(varNames,fin_sesgo,dominio, fin,fout, dim_time, dim_lat, dim_lon) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

        ;valid if there are variable ws10
        ;;;;;;; ---------- For WS10 ----------
        if(varNames(varIdx) .eq. "WS10") then
            u10= fin->U10                   ;get variable in fin
            v10= fin->U10                   ;get variable in fin

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar = sqrt(u10^2 + v10^2)*3.6 ;assing sqrt(u10^2 + v10^2)*3.6 to newVar 
            newVar@units = "km/hr";atributes
      
        end if

        ;valid if there are variable prec2
        ;;;;;;; ---------- For PREC2 ----------
        if(varNames(varIdx) .eq. "PREC2") then
            rainc= fin->RAINC               ;get variable in fin
            rainnc= fin->RAINNC             ;get variable in fin

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar = rainc+rainnc         ;assing rainc+rainnc to newVar 
        end if

        ;valid if there are variable t2c
        ;;;;;;; ---------- For T2C ----------
        if(varNames(varIdx) .eq. "T2C") then
            
               t2_sesgo1 = new( (/dim_time, 262,338/),"float", "No_FillValue");declare variable newVar
               t2_sesgo=fin_sesgo->BIAS
               do tiempo=0,120
                  if tiempo .eq. 120 then
                     t2_sesgo1(120,:,:)=0
                  else
                     t2_sesgo1(tiempo,:,:)=t2_sesgo(tiempo,:,:)
                  end if
               end do
            t2= fin->T2              ;get variable in fin
t2_1=t2-273.15 
if dominio .eq. 2 then

t2_sesgo2 = new((/dim_time, dim_lat, dim_lon/),"float", "No_FillValue");declare variable newVar
t2_sesgo2=f2gsh_Wrap(t2_sesgo1,(/156,273/),0)
;t2_1 := t2_sesgo2

end if
         
            
            t2_2 = new( (/dim_time, dim_lat, dim_lon/),"float", "No_FillValue");declare variable newVar
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", "No_FillValue");declare variable newVar
            
            if dominio .eq. 2 then
              do tiempo=0,120
                  t2_2(tiempo,:,:)=t2_1(tiempo,:,:)-(t2_sesgo2(tiempo,:,:)) 
end do
            end if

            if dominio .eq. 1 then
               do tiempo=0,120
                  t2_2(tiempo,:,:)=t2_1(tiempo,:,:)-(t2_sesgo1(tiempo,:,:)) 
               end do
            end if

            newVar=t2_2
            newVar@units = "C";atributes

end if
        ;valid if there are variable sstc
        ;;;;;;; ---------- For SSTC----------
        if(varNames(varIdx) .eq. "SSTC") then
            sst= fin->SST             ;get variable in fin
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar = sst-273.15                ;assing sst-273.15 to newVar 
            newVar@units = "C";atributes
        end if

        ;valid if there are variable prec2b
        ;;;;;;; ---------- For PREC2B----------
        if(varNames(varIdx) .eq. "PREC2B") then
            temp= fout->PREC2               ;get variable in fin
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar = temp*1  ;assing temp*1 to newVar
        end if

        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude" /) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/);add in file fout

        delete(newVar)
        print("Done!")
    end do
    ;end of variables cycle 
end
;end procedure add3DComposedVars
