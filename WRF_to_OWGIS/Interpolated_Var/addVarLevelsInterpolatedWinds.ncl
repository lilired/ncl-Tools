;start procedure addInter
procedure addVarLevelsInter(fin,fout,dim_time, dim_lat, dim_lon,dim_depth) begin
 ;   do varIdx=0,3;dimsizes(pressure_levels)-1,1 ; This loop iterates over the variables
        print("Interpolating variables for pressure level:");+ pressure_levels(varIdx) )
       ; print("Adding "+varNames(varIdx)+"...")
    
nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth/),double)
nuevaU=  new((/dim_time,dim_lat,dim_lon,dim_depth/),"float", 0)
nuevaV=  new((/dim_time,dim_lat,dim_lon,dim_depth/),"float", 0)
        do contador=0,3;dimsizes(dim_depth)-1
 
           if  contador .eq. 0 then
               varNamesO=(/"WSat850"/)
               varNames1=(/"Uat850"/)
               varNames2=(/"Vat850"/)

               origVar = fout->$varNamesO$
               newVar = new((/dim_time,dim_lat,dim_lon/),double)
               newVar(:,:,:) = (/origVar/) 
print(newVar(0,0,0))

               nueva(:,:,:,0)=  newVar    
print(nueva(0,0,0,0))
               nueva@description = "Wind Speed at 850 Hp/Velocidad del viento a 850 Hp";atributes
               nueva@units = "km/hr";atributes
               nueva@standard_name = "upward_wind_velocity_850";atributes 
               
               origVarU = fout->$varNames1$
               newVarU = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVarU(:,:,:) = (/origVarU/) 
               nuevaU(:,:,:,0)=  newVarU     
               nuevaU@description = "U at 850 hPA" ;;atributes
               nuevaU@units = "Km/hr" ;;atributes
               nuevaU@standard_name = "eastward_wind_850";atributes

               origVarV = fout->$varNames2$
               newVarV = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVarV(:,:,:) = (/origVarV/) 
               nuevaV(:,:,:,0)=  newVarV 
               nuevaV@description = "V at 850 hPA" ;;atributes
               nuevaV@units = "Km/hr" ;;atributes
               nuevaV@standard_name = "northward_wind_850";atributeS


print(newVarU(0,0,0))
print(nuevaU(0,0,0,0))
print(newVarV(0,0,0))
print(nuevaV(0,0,0,0))
               delete(newVar)
               delete(origVar)
               delete(varNamesO)	
               delete(newVarU)
               delete(origVarU)
               delete(varNames1)	
               delete(newVarV)
               delete(origVarV)
               delete(varNames2)	
               print("Done! 0")
           end if

           if  contador .eq. 1 then
               varNamesO=(/"WSat700"/)
               varNames1=(/"Uat700"/)
               varNames2=(/"Vat700"/)

               origVar = fout->$varNamesO$
               newVar =  new((/dim_time,dim_lat,dim_lon/),double)
               newVar(:,:,:) = (/origVar/) 
               nueva(:,:,:,1)=  newVar    
               nueva@description = "Wind Speed at 700 Hp/Velocidad del viento a 700 Hp";atributes
               nueva@units = "km/hr";atributes
               nueva@standard_name = "upward_wind_velocity_700";atributes 
               
               origVarU = fout->$varNames1$
               newVarU = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVarU(:,:,:) = (/origVarU/) 
               nuevaU(:,:,:,1)=  newVarU     
               nuevaU@description = "U at 700 hPA" ;;atributes
               nuevaU@units = "Km/hr" ;;atributes
               nuevaU@standard_name = "eastward_wind_700";atributes

               origVarV = fout->$varNames2$
               newVarV = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVarV(:,:,:) = (/origVarV/) 
               nueva(:,:,:,1)=  newVarV 
               nuevaV@description = "V at 700 hPA" ;;atributes
               nuevaV@units = "Km/hr" ;;atributes
               nuevaV@standard_name = "northward_wind_700";atributeS

               delete(newVar)
               delete(origVar)
               delete(varNamesO)	
               delete(newVarU)
               delete(origVarU)
               delete(varNames1)	
               delete(newVarV)
               delete(origVarV)
               delete(varNames2)	
               print("Done! 1")
           end if

           if  contador .eq. 2 then
               varNamesO=(/"WSat500"/)
               varNames1=(/"Uat500"/)
               varNames2=(/"Vat500"/)

               origVar = fout->$varNamesO$
               newVar =  new((/dim_time,dim_lat,dim_lon/),double)
               newVar(:,:,:) = (/origVar/) 
               nueva(:,:,:,2)=  newVar    
               nueva@description = "Wind Speed at 500 Hp/Velocidad del viento a 500 Hp";atributes
               nueva@units = "km/hr";atributes
               nueva@standard_name = "upward_wind_velocity_500";atributes 
               
               origVarU = fout->$varNames1$
               newVarU = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVarU(:,:,:) = (/origVarU/) 
               nuevaU(:,:,:,2)=  newVarU     
               nuevaU@description = "U at 500 hPA" ;;atributes
               nuevaU@units = "Km/hr" ;;atributes
               nuevaU@standard_name = "eastward_wind_500";atributes

               origVarV = fout->$varNames2$
               newVarV = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVarV(:,:,:) = (/origVarV/) 
               nueva(:,:,:,2)=  newVarV 
               nuevaV@description = "V at 500 hPA" ;;atributes
               nuevaV@units = "Km/hr" ;;atributes
               nuevaV@standard_name = "northward_wind_500";atributeS

               delete(newVar)
               delete(origVar)
               delete(varNamesO)	
               delete(newVarU)
               delete(origVarU)
               delete(varNames1)	
               delete(newVarV)
               delete(origVarV)
               delete(varNames2)	
               print("Done! 2")
           end if
           if  contador .eq. 3 then
               varNamesO=(/"WSat250"/)
               varNames1=(/"Uat250"/)
               varNames2=(/"Vat250"/)

               origVar = fout->$varNamesO$
               newVar =  new((/dim_time,dim_lat,dim_lon/),double)
               newVar(:,:,:) = (/origVar/) 
               nueva(:,:,:,3)=  newVar    
               nueva@description = "Wind Speed at  levels Hp/Velocidad del viento a levels Hp";atributes
               nueva@units = "km/hr";atributes
               nueva@standard_name = "upward_wind_velocity_levels";atributes 
               
               origVarU = fout->$varNames1$
               newVarU = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVarU(:,:,:) = (/origVarU/) 
               nuevaU(:,:,:,3)=  newVarU     
               nuevaU@description = "U at levels hPA" ;;atributes
               nuevaU@units = "Km/hr" ;;atributes
               nuevaU@standard_name = "eastward_wind";atributes

               origVarV = fout->$varNames2$
               newVarV = new((/dim_time,dim_lat,dim_lon/), "float", 0)
               newVarV(:,:,:) = (/origVarV/) 
               nueva(:,:,:,3)=  newVarV 
               nuevaV@description = "V at levels hPA" ;;atributes
               nuevaV@units = "Km/hr" ;;atributes
               nuevaV@standard_name = "northward_wind";atributeS

               delete(newVar)
               delete(origVar)
               delete(varNamesO)	
               delete(newVarU)
               delete(origVarU)
               delete(varNames1)	
               delete(newVarV)
               delete(origVarV)
               delete(varNames2)	
               print("Done! 3")
           end if
end do

        wsName = "WS"
             nueva@description = "Wind Speed at  levels Hp/Velocidad del viento a levels Hp";atributes
               nueva@units = "km/hr";atributes
               nueva@standard_name = "upward_wind_velocity_levels";atributes 
               
        uVarName = "U";
            nuevaU@description = "U at levels hPA" ;;atributes
               nuevaU@units = "Km/hr" ;;atributes
               nuevaU@standard_name = "eastward_wind";atributes

        vVarName = "V";
               nuevaV@description = "V at levels hPA" ;;atributes
               nuevaV@units = "Km/hr" ;;atributes
               nuevaV@standard_name = "northward_wind";atributeS

   filevardef(fout, wsName  ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
               filevarattdef(fout,wsName ,nueva); copy T attributes
               fout->$wsName$ = (/nueva/) 
 
  filevardef(fout, uVarName  ,typeof(nuevaU), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
               filevarattdef(fout,uVarName,nuevaU); copy T attributes
               fout->$wsName$ = (/nuevaU/) 

   filevardef(fout,vVarName  ,typeof(nuevaV), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
               filevarattdef(fout,vVarName ,nuevaV); copy T attributes
               fout->$wsName$ = (/nuevaV/) 
 
end
;end procedure addInter

