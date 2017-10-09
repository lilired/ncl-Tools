;----------- Reading ncl Files --------
print("Loading file the configuration init.....")
loadscript ("./configuration.txt")
print("Done!")

print("Loading files.....")
loadscript ("../TOOLS/tools.ncl")
loadscript ("./init/createTime.ncl")
loadscript ("./init/createLon.ncl")
loadscript ("./init/createLat.ncl")
loadscript ("./init/createDepth.ncl")

loadscript ("./var_3_coordinates/add3DVars.ncl")
;loadscript ("./var_3_coordinates/add3DComposedVars.ncl")
loadscript ("./var_4_coordinates/add4DVars.ncl")

print("Done!")

;------- Setting the proper input and output filenames ------
print("Configuring file names...")
begTime = get_cpu_time()


; Reads all the files

dataFolder=in
outputFolder=out
dia=30
mes=6
inputFolder=dataFolder+anio+sprintf("%02g",mes)+sprintf("%02g",dia)+"/";+toint(thisDay(0))+"/"+months(toint(thisDay(1))-1)+"/"
; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
print(inputFolder)


hour=1
; Iterate over the 3 domains
do metros=0,2

if metros .eq. 0 then
    metro=3
  end if
if metros .eq. 1 then
    metro=5		
  end if
if metros .eq. 2 then
    metro=10
  end if


dim_time=10
    ; --- TODO (COMMENT THIS LINE ON PRODUCTION) Add the following line, to read from an specific date file
    inputFile= inputFolder+"p_"+sprintf("%02g",hour)+"h_"+sprintf("%02g",metro)+"M.res.nc"
    outputFile= outputFolder+"p"+sprintf("%02g",hour)+"h_"+sprintf("%02g",metro)+".nc"

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

    ;------------ Creating Time dimension --------------------------------------
    print("Adding Time dimension....")
    Time = addTime(fout, dim_time)
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
             varNames=var3(conVar3);
             add3DVars(varNames,fin,fout,dim_time,dim_lat,dim_lon)
             delete(varNames)
           end if
    end do
    ;------------ Creating Latitude dimension --------------------------------------
    print("Adding Depth...")
    dim_depth = addDepth(fin,fout)
    print("Done!")


    ; ---------- For Variables the 4 coordinates ----------
    do conVar4 = 0,dimsizes(var4)-1
           if(var4(conVar4) .eq. "none") then
             print("No variables 4 coordinates")
           else 
             ; ---------- Adding 3 coordinates variables from file
             varNames=var4(conVar4);
           add4DVars(varNames,fin,fout,dim_time,dim_lat,dim_lon,dim_depth)
             delete(varNames)
           end if
    end do
     delete(dim_lon)
    delete(dim_lat)
    delete(Time)
end do
