procedure add3DVars(varNames,fin,fout,dim_time, dim_lat,dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        
        if varNames(varIdx) .eq. "PM05" then
           varNamesO=(/"C_PM05_GRND"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	      	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
;delete_VarAtts(newVar, (/"coordinates"/))
              newVar@long_name= "PM05" ;
	      newVar@standard_name = "PM05" ;
	end if
    


if varNames(varIdx) .eq. "PM10" then
           varNamesO=(/"C_PM10_GRND"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	      	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
;delete_VarAtts(newVar, (/"coordinates"/))

              newVar@long_name= "PM10" ;
	      newVar@standard_name = "PM10" ;
            end if


if varNames(varIdx) .eq. "PM20" then
           varNamesO=(/"C_PM20_GRND"/)
           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	      	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
     ;delete_VarAtts(newVar, (/"coordinates"/))

              newVar@long_name= "PM20" ;
	      newVar@standard_name = "PM20" ;
	end if


        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end
