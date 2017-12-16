function addTimes(fout, dim_time, dim_time2) begin
    ; TODO REMOVE HARD CODED TIME LENGHT
    
        do con_time=0,23
            varNamesO=(/"Time"/)
            origVar = fin[:]->$varNamesO(varIdx)$
            newVar = new((/dim_time/), "float", 0)
            newVar(:) = (/origVar/)
            nueva=  new((/dim_time2/), "float", 0)
            con_tm=1
           
            do contador=0,9
              otra=contador+con_tm
              print(otra)
              printVarSummary(nueva)
                    nueva(otra) =newVar(otra)
                    ; ---- Copy the original variables 
                    copy_VarAtts(newVar,nueva) ; Copy origial attributes
               nueva@standard_name = "time"
               nueva@long_name = "time"
               nueva@units = "hours since "+thisDay(0)+"-"+thisDay(1)+"-"+(toint(thisDay(2))-1)+" 00:00:00"
               nueva@calendar = "gregorian"

            end do

              con_tm=con_tm+10
              name="Time_"+(con_time+1)

ntim  = dimsizes(nueva)
    dimNames = (/name/)  
    filedimdef(fout, (/name/), -1 , (/ True /))
    filevardef(fout, name ,typeof(nueva),"Time") ; Time dimension
    filevarattdef(fout,name,nueva)                  ; copy Longitude attributes
    fout->name  = (/nueva/)     
    return name
          end do
end 
