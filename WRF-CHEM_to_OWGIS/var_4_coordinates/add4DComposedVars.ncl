procedure add4DComposedVars(varNames, fin,fout, dim_time, dim_depth, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
dim_time=73
        ; ---------- For PA ----------
        if(varNames(varIdx) .eq. "PA") then
            p_1= fin->P
            pb_1= fin->PB
     p= p_1(:,:,2:86,2:86)
     pb=pb_1(:,:,2:86,2:86)

            newVar = new( (/dim_time, dim_depth, dim_lat, dim_lon/),"float", 0)
            newVar = p+pb
          end if

       ; ---------- For NOX ----------
        if(varNames(varIdx) .eq. "NOX") then
            no_1= fin->no
            no2_1= fin->no2
             
     no= no_1(:,:,2:86,2:86)
     no2= no2_1(:,:,2:86,2:86)

            newVar = new( (/dim_time, dim_depth, dim_lat, dim_lon/),"float", 0)
            newVar = (no2+no)*1000
newVar@units = "ppm" 
        end if       



       ; ---------- For RH ----------
        if(varNames(varIdx) .eq. "RH") then
nueva=  new((/dim_time,dim_lat,dim_lon,dim_depth/),"float", 0)

            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            presion=(/850, 700, 500, 200/)
            do nivel=0,3

               QVAPOR_1 = fin->QVAPOR               ;get variable in fin
   QVAPOR= QVAPOR_1(:,:,2:86,2:86)
               P_1  = fin->P                     ; perturbation;get variable in fin
               Pb_1=fin->PB
     P= P_1(:,:,2:86,2:86)
     Pb= Pb_1(:,:,2:86,2:86)

               P=P+Pb
;print(P); >> /ServerScripts/Logs/texto_presion.txt

               theta_1= fin->T
      theta= theta_1(:,:,2:86,2:86)

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
                
   ;     end if
 else
     filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Depth","Latitude","Longitude" /) ) ; time dimension
     filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
     fout->$varNames(varIdx)$ = (/newVar/)

     delete(newVar)
end if     
   print("Done!")
    end do
end
