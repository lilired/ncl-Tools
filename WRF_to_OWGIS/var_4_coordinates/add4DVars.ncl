;start procedure add4DVars  
procedure add4DVars(varNames,fin,fout,dim_time,dim_depth,dim_lat, dim_lon) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
     ;   origVar = fin->$varNames(varIdx)$;get variable in fin

        ;valid if there are variables  QCLUOD
        if(varNames(varIdx) .eq. "QCLOUD") then
          origVar = fin->$varNames(varIdx)$;get variable in fin
          nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth/),"float", 0)
           
            presion=(/850, 700, 500, 200/)
            do nivel=0,3
               P  = fin->P
               Pb=fin->PB
               P=P+Pb

               origVar2 = wrf_user_intrp3d(origVar,P,"h",presion(nivel),-1.,False)
               origVar2@long_name = "cloud_liquid_water_mixing_ratio";atributes
               origVar2@standar_name = "cloud_liquid_water_mixing_ratio";atributes

               delete_VarAtts(origVar2, -1)
               nueva(:,:,:,nivel)=   wrf_user_intrp3d(origVar,P,"h",presion(nivel),-1.,False)
               qcloudName = "cloud_liquid_water_mixing_ratio_at_"+presion(nivel)

               filevardef(fout, qcloudName,typeof(origVar2), (/"Time","Latitude","Longitude" /) ) ; time dimension	
               filevarattdef(fout,qcloudName,origVar2); copy T attributes
               fout->$qcloudName$ = (/origVar2/);add in file fout
               
               delete(origVar2)
            end do
               nueva@long_name = "cloud_liquid_water_mixing_ratio";atributes
               nueva@standar_name = "cloud_liquid_water_mixing_ratio";atributes
               delete_VarAtts(nueva, -1)

               filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
               filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
               fout->$varNames(varIdx)$ = (/nueva/)
        end if
       if(varNames(varIdx) .eq. "QCLOUD2") then
 cloud = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
cloud_fraccion=fin->CLDFRA
do it=0, dim_time-1
cloud(it,:,:)=cloud_fraccion(it,0,:,:)+cloud_fraccion(it,1,:,:)+cloud_fraccion(it,2,:,:)+cloud_fraccion(it,3,:,:)+\
cloud_fraccion(it,4,:,:)+cloud_fraccion(it,5,:,:)+cloud_fraccion(it,6,:,:)+2*(cloud_fraccion(it,7,:,:)+cloud_fraccion(it,8,:,:)+\
cloud_fraccion(it,9,:,:)+cloud_fraccion(it,10,:,:)+cloud_fraccion(it,11,:,:))+3*(cloud_fraccion(it,12,:,:)+cloud_fraccion(it,13,:,:)+\
cloud_fraccion(it,14,:,:)+cloud_fraccion(it,15,:,:)+cloud_fraccion(it,16,:,:))+2*(cloud_fraccion(it,17,:,:)+cloud_fraccion(it,18,:,:)+\
cloud_fraccion(it,19,:,:)+cloud_fraccion(it,20,:,:)+cloud_fraccion(it,21,:,:))+cloud_fraccion(it,22,:,:)+cloud_fraccion(it,23,:,:)+\
cloud_fraccion(it,24,:,:)+cloud_fraccion(it,25,:,:)+cloud_fraccion(it,26,:,:)
wrf_smooth_2d (cloud, 3 )
end do
;print(cloud)
cloud=(cloud/25)*100
   cloud@long_name = "cloud_liquid_water_mixing_ratio";atributes
               cloud@standar_name = "cloud_liquid_water_mixing_ratio";atributes
               delete_VarAtts(cloud, -1)

               filevardef(fout, varNames(varIdx) ,typeof(cloud), (/"Time","Latitude","Longitude"/) ) ; time dimension
               filevarattdef(fout,varNames(varIdx),cloud); copy T attributes
               fout->$varNames(varIdx)$ = (/cloud/)
end if 
        print("Done!")
    end do
    ;end of variables cycle 
end																																																																																																																																																																																																																																																																						
;end procedure add4DCars 
