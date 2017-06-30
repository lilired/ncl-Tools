;----------- Reading ncl Files --------
print("Loading file the configuration init.....")
loadscript ("./configuration.txt")
;print(var3)
print("Done!")

print("Loading files.....")

loadscript ("./init/createTime.ncl")
loadscript ("./init/createLon.ncl")
loadscript ("./init/createLat.ncl")

loadscript ("./var_3_coordinates/add3DVars.ncl")

print("Done!")

;------- Setting the proper input and output filenames ------
;print("Configuring file names...")
;begTime = get_cpu_time()

; Reads all the files

dataFolder=in
outputFolder=out

inputFolder=dataFolder;+toint(thisDay(0))+"/"+months(toint(thisDay(1))-1)+"/"
; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------

    ; --- TODO (COMMENT THIS LINE ON PRODUCTION) Add the following line, to read from an specific date file
    inputFile= inputFolder+"archv.2017_140_03_2d.nc"  ;"wrfout_d0"+dominio+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+"_00.nc"
    outputFile= outputFolder+"archv.2017_140_03_2d_nuevo.nc";"Dom"+dominio+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc"

    print("Reading this file:"+ inputFile)
    print("Writing to this file:"+ outputFile)

    fin = addfile(inputFile,"r"); Abre el archivo wrf
    system("rm -f " +outputFile)    ; remove if exists
    fout = addfile(outputFile,"c"); Abre el archivo NetCDF 

    ; ------- Setting global attributes for netCDF file -----
    fout@Conventions = "CF-1.6"
    fout@Description= "Made at UNAM, at Center of Atmospheric Sciences. Conctact: Olmo Zavala"

    ; Explicitly declare file definition mode. Improve efficiency.
    setfileoption(fout,"DefineMode",True)

    dim_time=1;fin->MT
    thisDay=(/42509.125/)

    ;------------ Creating Time dimension --------------------------------------
    print("Adding Time dimension....")
    Time = addTime(fout, dim_time, thisDay)
    print("Done!")

    ;------------ Creating Latitude dimension --------------------------------------
    print("Adding latitude...")
    dim_lat = addLat(fin,fout)
    print("Done!")

    ;------------ Creating Longitude dimension --------------------------------------
    print("Adding longitude...")
    dim_lon = addLon(fin,fout)
    print("Done!")


    ; ---------- For Variables the 3 coordinates ----------
    do conVar3 = 0,dimsizes(var3)-1
           if(var3(conVar3) .eq. "none") then
             print("No variables 3 coordinates")
           else 
             ; ---------- Adding 3 coordinates variables from file
             varNames=var3(conVar3);(/"U10","V10","PBLH","SWDOWN","GLW","RAINC","T2","SST"/)
             add3DVars(varNames,fin,fout,dim_time,dim_lat,dim_lon)
             delete(varNames)
           end if
     end do	
