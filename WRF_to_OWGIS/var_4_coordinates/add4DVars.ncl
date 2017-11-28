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
        cloud2 = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
        
        cloud_fraccion=fin->CLDFRA

        do it=0, dim_time-1
           cloud = cloud_fraccion(it,0,:,:)*0
           ;printVarSummary(cloud)
           do nivels = 0,49-1
              cloud= cloud + cloud_fraccion(it,nivels,:,:)
           end do

cloud = (cloud )*6

if (any(cloud.gt.1.)) then
       cloud1D      = ndtooned (cloud)                  ; convert to 1D array
       i50      = ind(cloud1D.gt.1.)               ; all indices x1D > 50 
      ; print(i50)
       cloud1D(i50) = cloud1D(i50) + 30.                           ; set all  array syntax
       cloud        = onedtond(cloud1D, dimsizes(cloud)); return to the original array
       delete (cloud1D)                             ; x1D no longer needed
       delete (i50)                             ; i50 no longer needed
   end if
cloud2(it,:,:)=cloud
end do

               cloud2@long_name = "cloud_liquid_water_mixing_ratio";atributes
               cloud2@standar_name = "cloud_liquid_water_mixing_ratio";atributes
               cloud2@units = "%" 
               delete_VarAtts(cloud2, -1)

               filevardef(fout, varNames(varIdx) ,typeof(cloud2), (/"Time","Latitude","Longitude"/) ) ; time dimension
               filevarattdef(fout,varNames(varIdx),cloud2); copy T attributes
               fout->$varNames(varIdx)$ = (/cloud2/)
end if 
        print("Done!")
    end do
    ;end of variables cycle 
end																																																																																																																																																																																																																																																																						
;end procedure add4DCars 
