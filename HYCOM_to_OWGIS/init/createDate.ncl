function addDate(fin,fout) begin
    ; Adding depth variable
     Date = fin->Date



    filedimdef(fout, (/"Date"/), dim_date , (/ False /))
    filevardef(fout, "Date" ,typeof(date),"Date") ; depth dimension
    filevarattdef(fout,"Date",date)                  ; copy latitude attributes
    fout->Depth  = (/date/)
    return dim_date
end
