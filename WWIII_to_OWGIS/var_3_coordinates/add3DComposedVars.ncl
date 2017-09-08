procedure add3DComposedVars(varNames, fin,fout, dim_time, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

   

       ; ---------- For U----------
        if(varNames(varIdx) .eq. "U") then
          
          u = fin->uwnd

          		u@long_name = "U" ;
		u@standard_name = "eastward_wind_ten_velocity" ;
		u@globwave_name = "eastward_wind";
		u@units = "m s-1" ;
		u@valid_min = -990 ;
		u@valid_max = 990 ;
		u@comment = "cur=sqrt(U**2+V**2)" ;


                   ;	u@standard_name = "eastward_wind_ten_velocity" ;
		;	u(varIdx) = "U"
        	print("Adding as "+varNames(varIdx)+"...")


            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0)
            newVar = u
     
        end if

	; ---------- For V ----------
        if(varNames(varIdx) .eq. "V") then
          
           v = fin->vwnd
		v@long_name = "V" ;
		v@standard_name = "northward_wind_ten_velocity" ;
		v@globwave_name = "northward_wind" ;
		v@units = "m s-1" ;
		v@comment = "cur=sqrt(U**2+V**2)" ;

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

