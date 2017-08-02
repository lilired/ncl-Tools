;----------- Reading ncl Files --------
print("Loading file the configuration init.....")
loadscript ("./configuration.txt")
print("Done!")

print("Loading files.....")
loadscript ("./init/tools.ncl")
loadscript ("./init/createTime.ncl")
loadscript ("./init/createLon.ncl")
loadscript ("./init/createLat.ncl")

loadscript ("./var_3_coordinates/add3DVars.ncl")
loadscript ("./var_3_coordinates/add3DComposedVars.ncl")


print("Done!")

;------- Setting the proper input and output filenames ------
print("Configuring file names...")
begTime = get_cpu_time()

dia=14
mes=7
thisDay = (/anio,mes,dia/);(/2016,10,24/)
months=(/"01_enero","02_febrero","03_marzo","04_abril","05_mayo","06_junio","07_julio","08_agosto","09_septiembre","10_octubre","11_noviembre","12_diciembre"/)

; Reads all the files

dataFolder=in
outputFolder=out

inputFolder=dataFolder+toint(thisDay(0))+"/"+months(toint(thisDay(1))-1)+"/"
; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
print(inputFolder)

dim_time = 24

; Iterate over the 3 domains
do dominio=1,1;,2,3

if dominio .eq. 1 then
 dom="gom"
end if
if dominio .eq. 2 then
 dom="pac"
end if
if dominio .eq. 3 then
 dom="atl"
end if

    ; --- TODO (COMMENT THIS LINE ON PRODUCTION) Add the following line, to read from an specific date file
    inputFile= inputFolder+"ww3out.grd_"+dom+"."+anio+sprintf("%02g",mes)+sprintf("%02g",dia)+".nc"
    outputFile= outputFolder+dom+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc"

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
             varNames=var3(conVar3);
             add3DVars(varNames, fin,fout,dim_time, dim_lat, dim_lon)
             delete(varNames)
           end if
    end do

     ; ---------- For Variables the 3 coordinates  composed----------
     do conVar3C = 0,dimsizes(var3C)-1
          if(var3C(conVar3C) .eq. "none") then
             print("No variables 3 coordinates composed")
          else
             ; ------- Adding 3D composed variable 
             varNames = var3C(conVar3C);
             add3DComposedVars(varNames, fin,fout,dim_time, dim_lat, dim_lon)
             delete(varNames)
          end if
     end do    
    
    delete(dim_lon)
    delete(dim_lat)
    delete(Time)
end do
