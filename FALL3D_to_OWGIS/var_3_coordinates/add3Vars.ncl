procedure add3Vars(varNames,fin,fout,dim_time,dim_time2,dim_lat,dim_lon) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")

        if varNames(varIdx) .eq. "PM10" then
          do con_time=1,36
            varNamesO=(/"C_PM10_GRND"/)
           PM10 = fin[con_time-1]->$varNamesO(varIdx)$
                   PM10@long_name= "PM10_"+con_time ;
                    PM10@standard_name = "PM10_"+con_time ;
                    PM10@units = "mcg/m3" 
name=(/"PM10_"+con_time/)
print(name)
;$name=PM10
name2=(/"Time"+con_time/)

        filevardef(fout,name,typeof(PM10), (/name2,"Latitude","Longitude"/) ) ; time dimension
        filevarattdef(fout,name,PM10); copy T attributes
        fout->$name$ = (/PM10/);add in file fout
     ;  fout->$name$=PM10

           
 delete(varNamesO)
        delete(PM10)
          end do
      
        end if

        if varNames(varIdx) .eq. "LOAD" then
          do con_time=1,36
            varNamesO=(/"LOAD"/)
           LOAD = fin[con_time-1]->$varNamesO(varIdx)$
                   LOAD@long_name= "LOAD_"+con_time ;
                    LOAD@standard_name = "LOAD_"+con_time ;
                    LOAD@units = "kg/m2"  
name=(/"LOAD_"+con_time/)
print(name)
;$name=PM10
name2=(/"Time"+con_time/)

        filevardef(fout,name,typeof(LOAD), (/name2,"Latitude","Longitude"/) ) ; time dimension
        filevarattdef(fout,name,LOAD); copy T attributes
        fout->$name$ = (/LOAD/);add in file fout
     ;  fout->$name$=LOAD

           
 delete(varNamesO)
        delete(LOAD)
          end do
      
        end if

        if varNames(varIdx) .eq. "AOD" then
          do con_time=1,36
            varNamesO=(/"AOD"/)
           AOD= fin[con_time-1]->$varNamesO(varIdx)$
                   AOD@long_name= "AOD_"+con_time ;
                    AOD@standard_name = "AOD_"+con_time ;
                    AOD@units =  "mcg/m3" 
name=(/"AOD_"+con_time/)
print(name)
;$name=PM10
name2=(/"Time"+con_time/)
print(name2)
        filevardef(fout,name,typeof(AOD), (/name2,"Latitude","Longitude"/) ) ; time dimension
        filevarattdef(fout,name,AOD); copy T attributes
        fout->$name$ = (/AOD/);add in file fout

           
 delete(varNamesO)
        delete(AOD)
          end do
      
        end if

end do
end
