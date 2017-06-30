function addTime(fout, dim_time, thisDay) begin
    ; TODO REMOVE HARD CODED TIME LENGHT
    Time = (dim_time) ;Total Time steps
    Time@standard_name = "MT"
    Time@long_name = "time"
    Time@units = "days since 1900-12-31 00:00:00" ;
    Time@calendar = "standard" ;
	

    ntim  = dimsizes(Time)                 ; get dimension sizes  
    dimNames = (/"Time"/)  
    filedimdef(fout, (/"Time"/), -1 , (/ True /))
    filevardef(fout, "Time" ,typeof(Time),"Time") ; Time dimension
    filevarattdef(fout,"Time",Time)                  ; copy Longitude attributes
    fout->Time   = (/Time/)     
    return Time
end
