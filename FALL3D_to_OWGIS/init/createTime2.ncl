
procedure addTimes2(fout,fin, dim_time3, thisDay1) begin
    ; TODO REMOVE HARD CODED TIME LENGHT
    dim_time=240
Time=fin[30]->time
 ;  Time = createArray(dim_time3) ;Total Time steps
    Time@standard_name = "time";atributes
    Time@long_name = "time";atributes
    Time@units ="hours since "+thisDay1(0)+"-"+thisDay1(1)+"-"+thisDay1(2)
    Time@calendar = "gregorian";atributes
    Time@axis = "T";atributes


    ntim  = dimsizes(Time)                 ; get dimension sizes  
    dimNames = (/"Times"/)  
    filedimdef(fout, (/"Times"/), dim_time3 , (/ False /))
    filevardef(fout, "Times" ,typeof(Time),"Time") ; Time dimension
    filevarattdef(fout,"Times",Time)                  ; copy Longitude attributes
    fout->Times  = (/Time/)     
   ; return Times
end

