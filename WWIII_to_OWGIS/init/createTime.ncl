;start fuction addTime
function addTime(fout, dim_time, thisDay) begin
    ; TODO REMOVE HARD CODED TIME LENGHT
    
    Time = createArray(dim_time) ;Total Time steps
    Time@standard_name = "time";atributes
    Time@long_name = "time";atributes
    Time@units = "hours since "+thisDay(0)+"-"+thisDay(1)+"-"+thisDay(2)+" 00:00:00";atributes
    Time@calendar = "gregorian";atributes
    Time@axis = "T";atributes

    ntim  = dimsizes(Time)                 ; get dimension sizes  
    dimNames = (/"Time"/)  
    filedimdef(fout, (/"Time"/), -1 , (/ True /))
    filevardef(fout, "Time" ,typeof(Time),"Time") ; Time dimension
    filevarattdef(fout,"Time",Time)                  ; copy Longitude attributes
    fout->Time   = (/Time/) ;add in file fout    
    return Time
end
;end fuction addTime
