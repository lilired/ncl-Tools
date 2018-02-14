procedure add4DVars(varNames,fin,fout,dim_time, dim_time2, dim_time3,dim_depth2, dim_lat,dim_lon,dim_depth,metros) begin
    ; Iterate over all the files and add each variable
    do varIdx =0,dimsizes(varNames)-1,1 ; This loop iterates over the variables
        print("Adding "+varNames(varIdx)+"...")
    

        if varNames(varIdx) .eq. "CON" then
          do con_time=1,36
            varNamesO=(/"CON"/)
           CON= fin[con_time-1]->$varNamesO(varIdx)$
                   CON@long_name= "CON_"+con_time+" Total particle concentration"
                   CON@standard_name = "CON_"+con_time+" Total particle concentration"  ;
                    CON@units = "mcg/m3" 
printVarSummary(CON)
name=(/"CON_"+con_time/)
print(name)
;$name=CON
name2=(/"Time"+con_time/)
        filevardef(fout,name,typeof(CON), (/name2,"Depth2","Latitude","Longitude"/) ) ; time dimension
        filevarattdef(fout,name,CON); copy T attributes
        fout->$name$ = (/CON/);add in file fout
       ;fout->name=CON
;NAME=fout->name

;printVarSummary(NAME)
           
 delete(varNamesO)
        delete(CON)
          end do
      
        end if

if varNames(varIdx) .eq. "consentracion" then
       
  do con_time=1,36
        print(con_time)
         if metros .eq. 0 then
            if con_time .eq. 30 then
;delete(nueva)
            nueva=  new((/dim_time3,dim_lat,dim_lon,dim_depth/), "float", 0)
            printVarSummary(nueva) 
            print("entre aqui if metros 3 timepo 30")
            print(con_time)
         
        else
;delete(nueva)
            nueva=  new((/dim_time2,dim_lat,dim_lon,dim_depth/), "float", 0)
            print("entre aqui else metros 3 no es 30")
print(con_time)
        end if
      else
        nueva=  new((/dim_time2,dim_lat,dim_lon,dim_depth/), "float", 0)
print(con_time)
      end if
        do contador=0,8;dimsizes(dim_depth)-1
 
           if  contador .eq. 0 then
               varNamesO=(/"C_GRND"/)

               origVar = fin[con_time-1]->$varNamesO(varIdx)$
printVarSummary(origVar)
               if metros .eq. 0 then
                  if con_time .eq. 30 then
                     newVar = new((/dim_time3,dim_lat,dim_lon/), "float", 0)
                  else
                     newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
                  end if

               else
                  newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
               end if
               newVar(:,:,:) = (/origVar/) 
               nueva(:,:,:,0)=  (/newVar/)
               nueva@units = "g/m3" 
               delete(newVar)
               delete(origVar)
               delete(varNamesO)	
               ;print("Done! 0")
           end if

           if  contador .eq. 1 then
               varNamesO=(/"C_FL050"/)

               origVar = fin[con_time-1]->$varNamesO(varIdx)$
               if metros .eq. 0 then
                  if con_time .eq. 30 then
                     newVar = new((/dim_time3,dim_lat,dim_lon/), "float", 0)
                  else
                     newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
                  end if

               else
                  newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
               end if
               newVar(:,:,:) = (/origVar/)
               nueva(:,:,:,1)=  (/newVar/)  
               nueva@units = "g/m3" 
               delete(newVar)
               delete(origVar)
               delete(varNamesO)
               ;print("Done! 1")
           end if

           if  contador .eq. 2 then
               varNamesO=(/"C_FL100"/)

               origVar = fin[con_time-1]->$varNamesO(varIdx)$
               if metros .eq. 0 then
                  if con_time .eq. 30 then
                     newVar = new((/dim_time3,dim_lat,dim_lon/), "float", 0)
                  else
                     newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
                  end if

               else
                  newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
               end if
               newVar(:,:,:) = (/origVar/)
               nueva(:,:,:,2)=  (/newVar/)
               nueva@units = "g/m3" 
               delete(newVar)
               delete(varNamesO)
               delete(origVar)
               ;print("Done! 2")
           end if
           if  contador .eq. 3 then
               varNamesO=(/"C_FL150"/)

               origVar = fin[con_time-1]->$varNamesO(varIdx)$
               if metros .eq. 0 then
                  if con_time .eq. 30 then
                     newVar = new((/dim_time3,dim_lat,dim_lon/), "float", 0)
                  else
                     newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
                  end if

               else
                  newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
               end if
               newVar(:,:,:) = (/origVar/)
               nueva(:,:,:,3)=  (/newVar/)    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(varNamesO)
               delete(origVar)
               ;print("Done! 3")
           end if

           if  contador .eq. 4 then
               varNamesO=(/"C_FL200"/)

               origVar = fin[con_time-1]->$varNamesO(varIdx)$
               if metros .eq. 0 then
                  if con_time .eq. 30 then
                     newVar = new((/dim_time3,dim_lat,dim_lon/), "float", 0)
                  else
                     newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
                  end if

               else
                  newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
               end if
               newVar(:,:,:) = (/origVar/)
	       nueva(:,:,:,4)=  (/newVar/)    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(varNamesO)
               delete(origVar)
               ;print("Done! 4")
           end if
           if  contador .eq. 5 then
               varNamesO=(/"C_FL250"/)

               origVar = fin[con_time-1]->$varNamesO(varIdx)$
               if metros .eq. 0 then
                  if con_time .eq. 30 then
                     newVar = new((/dim_time3,dim_lat,dim_lon/), "float", 0)
                  else
                     newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
                  end if

               else
                  newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
               end if
               newVar(:,:,:) = (/origVar/)
	       nueva(:,:,:,5)=  (/newVar/)    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(varNamesO)
               delete(origVar)
               ;print("Done! 5")
           end if
           if  contador .eq. 6 then
               varNamesO=(/"C_FL300"/)

               origVar = fin[con_time-1]->$varNamesO(varIdx)$
               if metros .eq. 0 then
                  if con_time .eq. 30 then
                     newVar = new((/dim_time3,dim_lat,dim_lon/), "float", 0)
                  else
                     newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
                  end if

               else
                  newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
               end if
               newVar(:,:,:) = (/origVar/)
               nueva(:,:,:,6)=  (/newVar/)    
               nueva@units = "g/m3" 
              delete(varNamesO)               
              delete(newVar)
              delete(origVar)
               ;print("Done! 6")
           end if
           if  contador .eq. 7 then
               varNamesO=(/"C_FL350"/)

               origVar = fin[con_time-1]->$varNamesO(varIdx)$
               if metros .eq. 0 then
                  if con_time .eq. 30 then
                     newVar = new((/dim_time3,dim_lat,dim_lon/), "float", 0)
                  else
                     newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
                  end if

               else
                  newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
               end if
               newVar(:,:,:) = (/origVar/)
	       nueva(:,:,:,7)=  (/newVar/)    
               nueva@units = "mcg/m3" 
               delete(newVar)
               delete(origVar)
               delete(varNamesO)
              ;print("Done! 7")
           end if
           if  contador .eq. 8 then
               varNamesO=(/"C_FL400"/)

               origVar = fin[con_time-1]->$varNamesO(varIdx)$
               if metros .eq. 0 then
                  if con_time .eq. 30 then
                     newVar = new((/dim_time3,dim_lat,dim_lon/), "float", 0)
                  else
                     newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
                  end if

               else
                  newVar = new((/dim_time2,dim_lat,dim_lon/), "float", 0)
               end if
               newVar(:,:,:) = (/origVar/)
	       nueva(:,:,:,8)=  (/newVar/)    
               nueva@units = "g/m3" 
               delete(newVar)
               delete(varNamesO)
               delete(origVar)
               ;print("Done! 8")	
           end if
end do

name=(/"consentracion_"+con_time/)
printVarSummary(nueva)
name2=(/"Time"+con_time/)
        nueva!0 = name2;atributes
        nueva!1 = "Latitude";atributes
        nueva!2 = "Longitude";atributes
        nueva!3 = "Depth";atributes
        filevardef(fout,name,typeof(nueva), (/name2,"Latitude","Longitude","Depth"/) ) ; time dimension
        filevarattdef(fout,name,nueva); copy T attributes
        fout->$name$ = (/nueva/);add in file fout
       ;       fout->name= (/nueva/)
delete(nueva)
end do

end if

    end do
end

 
