procedure add4DVars(varNames,fin,fout,dim_time, dim_lat,dim_lon,dim_depth) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
    
        nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth/), "float", 0)
    
        do contador=0,8;dimsizes(dim_depth)-1
 
           if  contador .eq. 0 then
               varNamesO=(/"C_GRND"/)

               origVar = fin[:]->$varNamesO(varIdx)$
               newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVar(:,:,:) = (/origVar/) 
               nueva(:,:,:,0)=  newVar    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(origVar)
               delete(varNamesO)	
               print("Done! 0")
           end if

           if  contador .eq. 1 then
               varNamesO=(/"C_FL050"/)

               origVar = fin[:]->$varNamesO(varIdx)$
               newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVar(:,:,:) = (/origVar/)
               nueva(:,:,:,1)=  newVar    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(origVar)
               delete(varNamesO)
               print("Done! 1")
           end if

           if  contador .eq. 2 then
               varNamesO=(/"C_FL100"/)

               origVar = fin[:]->$varNamesO(varIdx)$
               newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVar(:,:,:) = (/origVar/)
               nueva(:,:,:,2)=  newVar    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(varNamesO)
               delete(origVar)
               print("Done! 2")
           end if
           if  contador .eq. 3 then
               varNamesO=(/"C_FL150"/)

               origVar = fin[:]->$varNamesO(varIdx)$
               newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVar(:,:,:) = (/origVar/)
               nueva(:,:,:,3)=  newVar    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(varNamesO)
               delete(origVar)
               print("Done! 3")
           end if

           if  contador .eq. 4 then
               varNamesO=(/"C_FL200"/)

               origVar = fin[:]->$varNamesO(varIdx)$
               newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVar(:,:,:) = (/origVar/)
	       nueva(:,:,:,4)=  newVar    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(varNamesO)
               delete(origVar)
               print("Done! 4")
           end if
           if  contador .eq. 5 then
               varNamesO=(/"C_FL250"/)

               origVar = fin[:]->$varNamesO(varIdx)$
               newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVar(:,:,:) = (/origVar/)
	       nueva(:,:,:,5)=  newVar    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(varNamesO)
               delete(origVar)
               print("Done! 5")
           end if
           if  contador .eq. 6 then
               varNamesO=(/"C_FL300"/)

               origVar = fin[:]->$varNamesO(varIdx)$
               newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVar(:,:,:) = (/origVar/)
               nueva(:,:,:,6)=  newVar    
               nueva@units = "g/m3" 
              delete(varNamesO)               
              delete(newVar)
              delete(origVar)
               print("Done! 6")
           end if
           if  contador .eq. 7 then
               varNamesO=(/"C_FL350"/)

               origVar = fin[:]->$varNamesO(varIdx)$
               newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVar(:,:,:) = (/origVar/)
	       nueva(:,:,:,7)=  newVar    
               nueva@units = "mcg/m3" 
               delete(newVar)
               delete(origVar)
               delete(varNamesO)
              print("Done! 7")
           end if
           if  contador .eq. 8 then
               varNamesO=(/"C_FL400"/)

               origVar = fin[:]->$varNamesO(varIdx)$
               newVar = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVar(:,:,:) = (/origVar/)
	       nueva(:,:,:,8)=  newVar    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(varNamesO)
               delete(origVar)
               print("Done! 8")	
           end if
end do

               filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
               filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
               fout->$varNames(varIdx)$ = (/nueva/)
    end do
end

 
