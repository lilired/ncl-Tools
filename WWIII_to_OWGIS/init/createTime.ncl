;start fuction addTime
function addTime(fout, dim_time, thisDay1) begin
    ; TODO REMOVE HARD CODED TIME LENGHT
    
    Time = createArray(dim_time) ;Total Time steps
    Time@standard_name = "time";atributes
    Time@long_name = "time";atributes
    Time@units ="hours since "+thisDay1(0)+"-"+thisDay1(1)+"-"+thisDay1(2);+ " days until "+thisDay1(0)+"-"+thisDay1(1)+"-"+(thisDay1(2)+4);+" 00:00:00";atributes
    Time@calendar = "gregorian";atributes
    Time@axis = "T";atributes
 Time@long_name = "julian day (UT)" ;
 Time@standard_name = "time" ;
; Time@units = "hours since 1990-01-01 00:00:00" ;
 Time@conventions = "relative julian days with decimal part (as parts of the day )" ;
 Time@axis = "T" ;



    ntim  = dimsizes(Time)                 ; get dimension sizes  
    dimNames = (/"Time"/)  
    filedimdef(fout, (/"Time"/), -1 , (/ True /))
    filevardef(fout, "Time" ,typeof(Time),"Time") ; Time dimension
    filevarattdef(fout,"Time",Time)                  ; copy Longitude attributes
    fout->Time   = (/Time/) ;add in file fout    
    return Time
end
;end fuction addTime
