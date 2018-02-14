
procedure addTimes(fout,fin,dim_time2,dim_time3,thisDay1,metros) begin
    ; TODO REMOVE HARD CODED TIME LENGHT
 do con_time=1,36
    print(con_time)
      if con_time .eq. 30 then
print(metros)
 if metros .eq. 0 then
         Time=fin[30]->time
 ;       Time = createArray(dim_time3) ;Total Time steps
         Time@standard_name = "time30";atributes
         Time@long_name = "time30";atributes
         Time@units ="hours since "+thisDay1(0)+"-"+thisDay1(1)+"-"+thisDay1(2)
         Time@calendar = "gregorian";atributes
         Time@axis = "T";atributes
          ntim  = dimsizes(Time)                 ; get dimension sizes  
          dimNames = (/"Time"/)  
          filedimdef(fout, (/"Time30"/), dim_time3 , (/ False /))
          filevardef(fout, "Time30" ,typeof(Time),"Time") ; Time dimension
          filevarattdef(fout,"Time30",Time)                  ; copy Longitude attributes
          fout->Time30  = (/Time/)  

           print("timepo "+con_time)

      else
           Times=fin[con_time-1]->time
           Times@standard_name = "time"+con_time;atributes
           Times@long_name = "time"+con_time;atributes
           Times@units ="hours since "+thisDay1(0)+"-"+thisDay1(1)+"-"+thisDay1(2)+" "+sprintf("%02g",con_time)+":00:00";
           Times@calendar = "gregorian";atributes
           name=(/"Time"+con_time/)
           filedimdef(fout,name,(dim_time2),(/False/))
           filevardef(fout,name, typeof(Times),name); Time dimension
           filevarattdef(fout,name,Times)                  ; copy Longitude attributes
           fout->$name$  = (/Times/)   
           print("timepo "+con_time)
      end if
   else
      Times=fin[con_time-1]->time
      Times@standard_name = "time"+con_time;atributes
      Times@long_name = "time"+con_time;atributes
      Times@units ="hours since "+thisDay1(0)+"-"+thisDay1(1)+"-"+thisDay1(2)+" "+sprintf("%02g",con_time)+":00:00";
      Times@calendar = "gregorian";atributes
      name=(/"Time"+con_time/)
      filedimdef(fout,name,(dim_time2),(/False/))
      filevardef(fout,name, typeof(Times),name); Time dimension
      filevarattdef(fout,name,Times)                  ; copy Longitude attributes
      fout->$name$  = (/Times/)   
      print("timepo "+con_time)
   end if
 end do
end


    
