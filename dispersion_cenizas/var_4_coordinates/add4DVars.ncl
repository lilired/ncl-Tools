procedure add4DVars(varNames,fin,fout,dim_time, dim_lat,dim_lon,dim_depth) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        
do con=0,0;dimsizes(dim_depth)-1,1
 
    if  con .eq. 0 then
           varNamesO=(/"C_GRND"/)

           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	   nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth(con)/), "float", 0)
           nueva(:,:,:,con)=  newVar    
;printVarSummary(nueva)   	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
            ;delete_VarAtts(newVar, (/"coordinates"/))

        filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
        fout->$varNames(varIdx)$ = (/nueva/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end if

    if  con .eq. 1 then
           varNamesO=(/"C_FL50"/)

           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	   nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth(con)/), "float", 0)
           nueva(:,:,:,con)=  newVar    
;printVarSummary(nueva)   	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
            ;delete_VarAtts(newVar, (/"coordinates"/))
    
  filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
        fout->$varNames(varIdx)$ = (/nueva/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end if

    if  con .eq. 2 then
           varNamesO=(/"C_FL100"/)

           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	   nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth(con)/), "float", 0)
           nueva(:,:,:,con)=  newVar    
      ;     printVarSummary(nueva)   	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
            ;delete_VarAtts(newVar, (/"coordinates"/))

      filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
        fout->$varNames(varIdx)$ = (/nueva/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end if
    if  con .eq. 3 then
           varNamesO=(/"C_FL150"/)

           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	   nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth(con)/), "float", 0)
           nueva(:,:,:,con)=  newVar    
        ;   printVarSummary(nueva)   	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
            ;delete_VarAtts(newVar, (/"coordinates"/))

             filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
        fout->$varNames(varIdx)$ = (/nueva/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end if

    if  con .eq. 4 then
           varNamesO=(/"C_FL200"/)

           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	   nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth(con)/), "float", 0)
           nueva(:,:,:,con)=  newVar    
         ;  printVarSummary(nueva)   	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
            ;delete_VarAtts(newVar, (/"coordinates"/))

              filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
        fout->$varNames(varIdx)$ = (/nueva/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end if
    if  con .eq. 5 then
           varNamesO=(/"C_FL2150"/)

           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	   nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth(con)/), "float", 0)
           nueva(:,:,:,con)=  newVar    
         ;  printVarSummary(nueva)   	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
            ;delete_VarAtts(newVar, (/"coordinates"/))

             filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
        fout->$varNames(varIdx)$ = (/nueva/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end if
    if  con .eq. 6 then
           varNamesO=(/"C_FL300"/)

           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	   nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth(con)/), "float", 0)
           nueva(:,:,:,con)=  newVar    
;printVarSummary(nueva)   	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
            ;delete_VarAtts(newVar, (/"coordinates"/))
      filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
        fout->$varNames(varIdx)$ = (/nueva/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end if
    if  con .eq. 7 then
           varNamesO=(/"C_FL350"/)

           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	   nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth(con)/), "float", 0)
           nueva(:,:,:,con)=  newVar    
;printVarSummary(nueva)   	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
            ;delete_VarAtts(newVar, (/"coordinates"/))

          filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
        fout->$varNames(varIdx)$ = (/nueva/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end if
    if  con .eq. 8 then
           varNamesO=(/"C_FL400"/)

           origVar = fin->$varNamesO(varIdx)$
           newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
           newVar(:,:,:) = (/origVar/)
	   nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth(con)/), "float", 0)
           nueva(:,:,:,con)=  newVar    
;printVarSummary(nueva)   	
           ; ---- Copy the original variables 
             copy_VarAtts(origVar,newVar) ; Copy origial attributes
            ;delete_VarAtts(newVar, (/"coordinates"/))
      filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
        fout->$varNames(varIdx)$ = (/nueva/)
        delete(newVar)
        delete(origVar)
        print("Done!")
    end if


end do


    end do
end


