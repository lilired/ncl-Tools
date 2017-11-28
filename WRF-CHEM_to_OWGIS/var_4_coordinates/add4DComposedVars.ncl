procedure add4DComposedVars(varNames, fin,fout, dim_time, dim_depth, dim_lat, dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

        ; ---------- For PA ----------
        if(varNames(varIdx) .eq. "PA") then
            p= fin->P
            pb= fin->PB

            newVar = new( (/dim_time, dim_depth, dim_lat, dim_lon/),"float", 0)
            newVar = p+pb
          end if

       ; ---------- For NOX ----------
        if(varNames(varIdx) .eq. "NOX") then
            no= fin->no
            no2= fin->no2
             
            newVar = new( (/dim_time, dim_depth, dim_lat, dim_lon/),"float", 0)
            newVar = (no2+no)*1000
        end if       



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
