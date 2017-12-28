;start procedure add4DComposedVars
procedure add4DComposedVars(varNames, fin,fout, dim_time, dim_depth, dim_lat, dim_lon) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

        ;valid if there are variables PA
        ; ---------- For PA ----------
        if(varNames(varIdx) .eq. "PA") then
            p= fin->P;get variable in fin
            pb= fin->PB;get variable in fin

            newVar = new( (/dim_time, dim_depth, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar = p+pb          ;assing  p+pb to newVar 
        end if
  
       ;valid if there are variables RH
       ; ---------- For RH ----------
        if(varNames(varIdx) .eq. "RH") then
nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth/),"float", 0)

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            presion=(/850, 700, 500, 200/)
            do nivel=0,3

               QVAPOR = fin->QVAPOR               ;get variable in fin
               P  = fin->P                     ; perturbation;get variable in fin
               Pb=fin->PB
               P=P+Pb
               theta= fin->T
               theta=theta+300
               TK=wrf_tk(P,theta)
               RH=wrf_rh(QVAPOR,P,TK)

               humedad = wrf_user_intrp3d(RH,P,"h",presion(nivel),-1.,False)
               humedad@long_name = "relative_humidity "+presion(nivel);atributes
               humedad@standard_name = "relative_humidity "+presion(nivel)      ;atributes 
            
               delete_VarAtts(humedad, -1)
                     nueva(:,:,:,nivel)=   wrf_user_intrp3d(RH,P,"h",presion(nivel),-1.,False);humedad 
        nueva@long_name = "relative_humidity ";+presion(nivel);atributes
               nueva@standard_name = "relative_humidity ";+presion(nivel)      ;atributes 
            
               delete_VarAtts(nueva, -1)
               rhName = "RHat"+presion(nivel)

               ;filevardef(fout, rhName,typeof(humedad), (/"Time","Latitude","Longitude"/) ) ; time dimension
               ;filevarattdef(fout,rhName,humedad); copy T attributes
              ; fout->$rhName$ = (/humedad/);add in file fout

               delete(humedad)
if nivel .eq. 3 then
print("LLEGUE A 200")
end if
       
            end do

    nueva@long_name = "relative_humidity ";+presion(nivel);atributes
               nueva@standard_name = "relative_humidity ";+presion(nivel)      ;atributes 
               nueva@units = "%" 
   filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
               filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
               fout->$varNames(varIdx)$ = (/nueva/)
        end if

 ;valid if there are variables tem-pot-eq
       ; ---------- For tem-pot-eq ----------
        if(varNames(varIdx) .eq. "TPE") then
nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth/),"float", 0)

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            presion=(/850, 700, 500, 200/)
            do nivel=0,3
     T = wrf_user_getvar(fin,"T",-1)
     P = wrf_user_getvar(fin,"P",-1)
     PB = wrf_user_getvar(fin,"PB",-1)
     qv = wrf_user_getvar(fin,"QVAPOR",-1)

     T  = T -273.15          ; potential temperature in c.
      P  = P + PB          ; full pressure in Pa.   
      tk = wrf_tk( P , T ) ; temperature in K.
      eth = wrf_eth ( qv, tk, P )
      ;plevs = nivel
      eth_plane = wrf_user_intrp3d(eth,p,"h",presion(nivel),0.,False)

      delete_VarAtts(eth_plane, -1)
    
      eth_plane@description=""
      eth_plane@_FillValue =9.96921e+36
              nueva(:,:,:,nivel)= wrf_user_intrp3d(eth,p,"h",presion(nivel),0.,False)
        nueva@long_name = "Temp_Pot_Eq";+presion(nivel);atributes
               nueva@standard_name = "Temp_Pot_Eq ";+presion(nivel)      ;atributes 
            
               delete_VarAtts(nueva, -1)

      delete_VarAtts(eth_plane, -1)
    
     ; eth_plane@description=""
      ;eth_plane@_FillValue =9.96921e+36
      ;eth_plane@long_name = "Temp_Pot_Eq_at_"+presion(nivel);atributes
      ;eth_plane@standard_name = "Temp_Pot_Eq_at_"+presion(nivel)      ;atributes 
      
      ;delete_VarAtts(eth_plane, -1)
              
      ;tpeName = "Temp_Pot_Eq_at"+presion(nivel)

       ;        filevardef(fout, tpeName,typeof(eth_plane), (/"Time","Latitude","Longitude" /) ) ; time dimension
        ;       filevarattdef(fout,tpeName,eth_plane); copy T attributes
         ;      fout->$rhName$ = (/eth_plane/);add in file fout

          ;     delete(humedad)
       
            end do
     nueva@long_name = "Temp_Pot_Eq";+presion(nivel);atributes
               nueva@standard_name = "Temp_Pot_Eq ";+presion(nivel)      ;atributes 
               nueva@units = "C" 
   filevardef(fout, varNames(varIdx) ,typeof(nueva), (/"Time","Latitude","Longitude","Depth"/) ) ; time dimension
               filevarattdef(fout,varNames(varIdx),nueva); copy T attributes
               fout->$varNames(varIdx)$ = (/nueva/)
        end if

        print("Done!")

    end do
    ;end of variables cycle 
end
;end procedure add4DComposedVars
