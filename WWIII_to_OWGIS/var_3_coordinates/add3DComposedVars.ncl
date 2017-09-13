;start procedure add4DComposedVars
procedure add3DComposedVars(varNames, fin,fout, dim_time, dim_lat, dim_lon) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
 
        ;valid if there are variables u
        ;;;;;;; ---------- For U----------
        if(varNames(varIdx) .eq. "U") then
          
                u = fin->uwnd

          	u@long_name = "U" ;;atributes
		u@standard_name = "eastward_wind_ten_velocity" ;;atributes
		u@globwave_name = "eastward_wind";;atributes
		u@units = "m s-1" ;;atributes
		u@valid_min = -990 ;;atributes
		u@valid_max = 990 ;;atributes
		u@comment = "cur=sqrt(U**2+V**2)" ; ;atributes
 
         	print("Adding as "+varNames(varIdx)+"...")

                newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
                newVar = u  ;assing u to newVar 
     
        end if

        ;valid if there are variables v
	;;;;;;; ---------- For V ----------
        if(varNames(varIdx) .eq. "V") then
          
                v = fin->vwnd
		v@long_name = "V" ;;atributes
		v@standard_name = "northward_wind_ten_velocity" ;;atributes
		v@globwave_name = "northward_wind" ;;atributes
		v@units = "m s-1" ;;atributes
		v@comment = "cur=sqrt(U**2+V**2)" ;;atributes
                v@long_name= "V";;atributes
		v@standard_name = "northward_wind_ten_velocity";;atributes
			
                newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
                newVar = v;assing v to newVar 
     
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

