;start fuction addTime
function addTime(fout, dim_time, thisDay) begin
    ; TODO REMOVE HARD CODED TIME LENGHT
    Time = createArray(dim_time) ;Total Time steps
    Time@standard_name = "Time";atributes
    Time@long_name = "Time";atributes
if thisDay(2) .eq. 1 then
if thisDay(1) .eq. 1 then
 Time@units = "hours since "+(thisDay(0)-1)+"-12-31 00:00:00";atributes
end if
if thisDay(1) .eq. 2 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-31 00:00:00";atributes
end if
if thisDay(1) .eq. 3 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-28 00:00:00";atributes
end if
if thisDay(1) .eq. 4 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-31 00:00:00";atributes
end if
if thisDay(1) .eq. 5 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-30 00:00:00";atributes
end if
if thisDay(1) .eq. 6 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-31 00:00:00";atributes
end if
if thisDay(1) .eq. 7 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-30 00:00:00";atributes
end if
if thisDay(1) .eq. 8 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-31 00:00:00";atributes
end if
if thisDay(1) .eq. 9 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-31 00:00:00";atributes
end if
if thisDay(1) .eq. 10 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-30 00:00:00";atributes
end if
if thisDay(1) .eq. 11 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-31 00:00:00";atributes
end if
if thisDay(1) .eq. 12 then
 Time@units = "hours since "+thisDay(0)+"-"+(thisDay(1)-1)+"-30 00:00:00";atributes
end if
else
    Time@units = "hours since "+thisDay(0)+"-"+thisDay(1)+"-"+(toint(thisDay(2))-1)+" 00:00:00";atributes
end if 
   Time@calendar = "gregorian";atributes
    Time@axis = "T";atributes

    ntim  = dimsizes(Time)                 ; get dimension sizes  
    dimNames = (/"Time"/)  
    filedimdef(fout, (/"Time"/), -1 , (/ True /))
    filevardef(fout, "Time" ,typeof(Time),"Time") ; Time dimension
    filevarattdef(fout,"Time",Time)                  ; copy Longitude attributes
    fout->Time   = (/Time/)     ;add in file fout
    return Time
end
;end fuction addTime
