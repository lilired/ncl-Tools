function addTime(fout, dim_time2, thisDay1) begin
    ; TODO REMOVE HARD CODED TIME LENGHT
    dim_time=240

   Time = createArray(dim_time2) ;Total Time steps
    Time@standard_name = "time";atributes
    Time@long_name = "time";atributes
    Time@units ="hours since "+thisDay1(0)+"-"+thisDay1(1)+"-"+thisDay1(2)
    Time@calendar = "gregorian";atributes
    Time@axis = "T";atributes


    ntim  = dimsizes(Time)                 ; get dimension sizes  
    dimNames = (/"Time"/)  
    filedimdef(fout, (/"Time"/), -1 , (/ True /))
    filevardef(fout, "Time" ,typeof(Time),"Time") ; Time dimension
    filevarattdef(fout,"Time",Time)                  ; copy Longitude attributes
    fout->Time   = (/Time/)     
    return Time
end

