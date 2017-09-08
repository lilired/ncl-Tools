procedure add3DVars(varNames,fin,fout, dim_time,dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
       print("Adding "+varNames(varIdx)+"...")
     
        if varNames(varIdx) .eq. "ssh" then
           varNamesO=(/"ssh"/)
                         origVar = fin->$varNamesO(varIdx)$

      newVar = new((/dim_time(0),dim_lat(0), dim_lon(0)/), "float", 0)
      newVar(:,:,:) = (/origVar/)
		; ---- Copy the original variables 
        copy_VarAtts(origVar,newVar) ; Copy origial attributes
			newVar@long_name= "ssh" ;
	printVarSummary(newVar)
        end if
    
        if varNames(varIdx) .eq. "u" then
           varNamesO=(/"mixed_layer_u_velocity"/)
                      origVar = fin->$varNamesO(varIdx)$

      newVar = new((/dim_time(0),dim_lat(0), dim_lon(0)/), "float", 0)
      newVar(:,:,:) = (/origVar/)

		; ---- Copy the original variables 
        copy_VarAtts(origVar,newVar) ; Copy origial attributes
			newVar@long_name= "U" ;
			newVar@standard_name = "eastward_wind_ten_velocity" ;
			;varNames(varIdx) = "U"
        	print("Adding as "+varNames(varIdx)+"...")


        end if
    
        if varNames(varIdx) .eq. "v" then
           varNamesO=(/"mixed_layer_v_velocity"/)
       ; u@units = "degree" ;
        origVar = fin->$varNamesO(varIdx)$

      newVar = new((/dim_time(0),dim_lat(0), dim_lon(0)/), "float", 0)
      newVar(:,:,:) = (/origVar/)

		; ---- Copy the original variables 
        copy_VarAtts(origVar,newVar) ; Copy origial attributes
			newVar@long_name= "V" ;
			newVar@standard_name =  "northward_wind_ten_velocity";
	        	;varNames(varIdx) = "V"
        	print("Adding as "+varNames(varIdx)+"...")
        end if
    
        if varNames(varIdx) .eq. "temp2m" then
           varNamesO=(/"mixed_layer_temperature"/)
                       origVar = fin->$varNamesO(varIdx)$

      newVar = new((/dim_time(0),dim_lat(0), dim_lon(0)/), "float", 0)
      newVar(:,:,:) = (/origVar/)

		; ---- Copy the original variables 
        copy_VarAtts(origVar,newVar) ; Copy origial attributes   
		newVar@long_name= "temp2m" ;
	       ; newVar@standard_name = "eastward_wind_ten_velocity" ;
			;varNames(varIdx) = "temp2m"
        	print("Adding as "+varNames(varIdx)+"...")
        end if
    
        if varNames(varIdx) .eq. "salinity_s" then
           varNamesO=(/"mixed_layer_salinity"/)
                origVar = fin->$varNamesO(varIdx)$

      newVar = new((/dim_time(0),dim_lat(0), dim_lon(0)/), "float", 0)
      newVar(:,:,:) = (/origVar/)

		; ---- Copy the original variables 
        copy_VarAtts(origVar,newVar) ; Copy origial attributes
			newVar@long_name= "salinity_s" ;
		print("Adding as "+varNames(varIdx)+"...")
        end if
        
        filevardef(fout,varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude"/) ) ; time dimension

        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end
