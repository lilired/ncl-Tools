;start procedure add3DComposedVars
procedure addPComposedVars(varNames, fin,fout, dim_time, dim_lat, dim_lon) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")


        if(varNames(varIdx) .eq. "RES") then
           T2_PRONOSTICO=fout->T2C                ;get variable in fin
           T2_1=fout->T2C_1                ;get variable in fin
           T2_5=fout->T2C_5                ;get variable in fin
           T2_10=fout->T2C_10                ;get variable in fin
           T2_90=fout->T2C_90                ;get variable in fin
           T2_95=fout->T2C_95                ;get variable in fin
           T2_99=fout->T2C_99                ;get variable in fin
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar RES
            ;newVar@units = "C";atributes}
            
            do it=0, dim_time-1
               do lat=0, dim_lat-1
                  do lon=0, dim_lon-1
               ;# Buscando aquellos valores menores o iguales al
               ;# percentil 1
               t2_pon=T2_PRONOSTICO(it,lat,lon) 
               t2_1p=T2_1(it,lat,lon)
t2_5p=T2_5(it,lat,lon)
t2_10p=T2_10(it,lat,lon)
t2_90p=T2_90(it,lat,lon)
t2_95p=T2_95(it,lat,lon)
t2_99p=T2_99(it,lat,lon)

               if t2_pon.le.t2_1p
                ;# asignar -3
                newVar(it,lat,lon) = -3
                 ;# Buscando aquellos valores menores o iguales al
               ;# percentil 1
               end if 

        if t2_pon.le.t2_5p
                   if t2_pon.gt.t2_1p
                   newVar(it,lat,lon) = -2
                    end if
               end if



              end do
             end do
            end do
        end if


;****************************************************
otro=0
if otro .eq. 1 then
        if(varNames(varIdx) .eq. "T2C_1") then
            ;t2= fin->T2                 ;get variable in fin
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar@units = "C";atributes}
            
            do it=0, dim_time-1
              newVar(it,:,:)=-15
            end do
        end if

        if(varNames(varIdx) .eq. "T2C_5") then
            ;t2= fin->T2                 ;get variable in fin
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar@units = "C";atributes}
            
            do it=0, dim_time-1
              newVar(it,:,:)=-5
            end do
        end if

        if(varNames(varIdx) .eq. "T2C_10") then
            ;t2= fin->T2                 ;get variable in fin
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar@units = "C";atributes}
            
            do it=0, dim_time-1
               newVar(it,:,:)=0
            end do
        end if

        if(varNames(varIdx) .eq. "T2C_90") then
            ;t2= fin->T2                 ;get variable in fin
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar@units = "C";atributes}
            
            do it=0, dim_time-1
               newVar(it,:,:)=20
            end do
        end if
        if(varNames(varIdx) .eq. "T2C_95") then
            ;t2= fin->T2                 ;get variable in fin
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar@units = "C";atributes}
            
            do it=0, dim_time-1
               newVar(it,:,:)=25
            end do
        end if
        if(varNames(varIdx) .eq. "T2C_99") then
            ;t2= fin->T2                 ;get variable in fin
            newVar = new( (/dim_time, dim_lat, dim_lon/),"float", 0);declare variable newVar
            newVar@units = "C";atributes}
            
            do it=0, dim_time-1
               newVar(it,:,:)=30
            end do
        end if
end if
;****************************************************
        filevardef(fout, varNames(varIdx) ,typeof(newVar), (/"Time","Latitude","Longitude" /) ) ; time dimension
        filevarattdef(fout,varNames(varIdx),newVar); copy T attributes
        fout->$varNames(varIdx)$ = (/newVar/);add in file fout

        delete(newVar)
        print("Done!")
    end do
    ;end of variables cycle 
end
;end procedure add3DComposedVars
