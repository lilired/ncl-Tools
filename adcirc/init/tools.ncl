; Function to create 1D arrays
function createArray(size)
begin
    myarray = new(size,float)
    do n=0,size-1
        myarray(n) = n
    end do 
    return myarray
end

; Function to split year,month,day from a string with a date
function getDate(strDate)
begin
    date = str_split(strDate(0),"-")
    return (/date(0), date(1), date(2)/)
end


