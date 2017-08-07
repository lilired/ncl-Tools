procedure add3DVars(varNames,fin,fout, dim_time,dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
varNamesO=(/"SSH"," mixed_layer_u_velocity"," mixed_layer_v_velocity "," mixed_layer_temperature","mixed_layer_salinity"/)
        origVar = fin->$varNamesO(varIdx)$

      newVar = new((/dim_time(0),dim_lat(0), dim_lon(0)/), "float", 0)
      newVar(:,:,:) = (/origVar/)

		; ---- Copy the original variables 
        copy_VarAtts(origVar,newVar) ; Copy origial attributes
        ;delete_VarAtts(newVar, (/"coordinates"/))

;var3=(/"ssh","u","v","temp2m","salinity_s"/)

        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude"/) ) ; time dimension

        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end do
end
