procedure add3DComposedVars(varNames, fin,fout, dim_time, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

   

       ; ---------- For U----------
        if(varNames(varIdx) .eq. "U") then
          
           direccion = fin->dir

           u=direccion
           u=sin((direccion+180)*3.141516/180.)

            printVarSummary(u)

                     ; u@units = "degree" ;
			u@long_name= "U" ;
			u@standard_name = "eastward_wind_ten_velocity" ;
		;	u(varIdx) = "U"
        	print("Adding as "+varNames(varIdx)+"...")


            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = u
     
        end if

	; ---------- For V ----------
        if(varNames(varIdx) .eq. "V") then
          
           direccion = fin->dir

           v=direccion
           v=cos((direccion+180)*3.141516/180.)	;printVarSummary(u)

            printVarSummary(v)

                	;v@units = "degree" ;
			v@long_name= "V";
			v@standard_name = "northward_wind_ten_velocity";
			;v(varIdx) = "V"
        	

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = v
     
        end if
     


        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude" /) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)

        delete(newVar)
        print("Done!")
    end do
end
