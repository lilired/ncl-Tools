;start procedure add4DVars  
procedure add4DVars(varNames,fin,fout,dim_time,dim_depth,dim_lat, dim_lon) begin
    ;start of variables cycle 
    ;;;;;;; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
        origVar = fin->$varNames(varIdx)$;get variable in fin

        ;valid if there are variables  QCLUOD
        if(varNames(varIdx) .eq. "QCLOUD") then           
            origVar@long_name = "cloud_liquid_water_mixing_ratio";atributes
            origVar@standar_name = "cloud_liquid_water_mixing_ratio";atributes
        end if


        filevardef(fout, varNames(varIdx) ,typeof(origVar), (/"Time","Depth","Latitude","Longitude" /)) ; time dimension
        delete_VarAtts(origVar, (/"coordinates"/))    
        filevarattdef(fout,varNames(varIdx),origVar); copy T attributes
        fout->$varNames(varIdx)$ = (/origVar/);add in file fout

        delete(origVar)
        print("Done!")
    end do
    ;end of variables cycle 
end																																																																																																																																																																																																																																																																						
;end procedure add4DCars 
