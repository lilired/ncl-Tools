procedure add4DVars(varNames,fin,fout,dim_time,dim_depth,dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
                origVar2 = fin->$varNames(varIdx)$
   
        origVar=origVar2(:,:,2:86,2:86)


        if(varNames(varIdx) .eq. "QCLOUD") then
          cloud = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
          cloud_fraccion_1=fin->CLDFRA
 cloud_fraccion=cloud_fraccion_1(:,2:86,2:86)
          do it=0, dim_time-1 
             cloud(it,:,:)=cloud_fraccion(it,0,:,:)+cloud_fraccion(it,1,:,:)+cloud_fraccion(it,2,:,:)+cloud_fraccion(it,3,:,:)+\
             cloud_fraccion(it,4,:,:)+cloud_fraccion(it,5,:,:)+cloud_fraccion(it,6,:,:)+2*(cloud_fraccion(it,7,:,:)+cloud_fraccion(it,8,:,:)+\
             cloud_fraccion(it,9,:,:)+cloud_fraccion(it,10,:,:)+cloud_fraccion(it,11,:,:))+3*(cloud_fraccion(it,12,:,:)+cloud_fraccion(it,13,:,:)+\
             cloud_fraccion(it,14,:,:)+cloud_fraccion(it,15,:,:)+cloud_fraccion(it,16,:,:))+2*(cloud_fraccion(it,17,:,:)+cloud_fraccion(it,18,:,:)+\
             cloud_fraccion(it,19,:,:)+cloud_fraccion(it,20,:,:)+cloud_fraccion(it,21,:,:))+cloud_fraccion(it,22,:,:)+cloud_fraccion(it,23,:,:)+\
             cloud_fraccion(it,24,:,:)+cloud_fraccion(it,25,:,:)+cloud_fraccion(it,26,:,:)
             wrf_smooth_2d (cloud, 3)
          end do

          cloud=(cloud/25)*100
          cloud@long_name = "cloud_liquid_water_mixing_ratio";atributes
          cloud@standar_name = "cloud_liquid_water_mixing_ratio";atributes
          cloud@units = "%" 
          delete_VarAtts(cloud, -1)

          filevardef(fout, varNames(varIdx) ,typeof(cloud), (/"Time","Latitude","Longitude"/) ) ; time dimension
          filevarattdef(fout,varNames(varIdx),cloud); copy T attributes
          fout->$varNames(varIdx)$ = (/cloud/)   

        
        else
          newVar = new((/dim_time, dim_depth, dim_lat, dim_lon/), "float", 0.0)
          newVar(:,:,:,:) = (/origVar/)
          if (varNames(varIdx) .eq. "o3") then
          
          newVar=newVar*1000
          end if
 if (varNames(varIdx) .eq. "so2") then
             
          
          newVar=newVar*1000
          end if
         
          filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Depth","Latitude","Longitude" /) ) ; time dimension
          copy_VarAtts(origVar,newVar) ; Copy origial attributes
          delete_VarAtts(newVar, (/"coordinates"/))

          filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
          fout->$varNames(varIdx)$ = (/newVar/)
          delete(newVar)
          delete(origVar)
        end if
        print("Done!")
    end do
end																																																																																																																																																																																																																																																																						
