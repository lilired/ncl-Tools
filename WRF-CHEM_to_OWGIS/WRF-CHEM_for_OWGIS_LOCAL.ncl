;----------- Reading ncl File configuration--------
print("Loading configuration file .....")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/configuration.txt")
print("Done!")

;----------- Reading ncl Files --------
print("Loading files.....")
loadscript ("/ServerScripts/TOOLS/tools.ncl")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/init/createTime.ncl")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/init/createLon.ncl")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/init/createLat.ncl")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/init/createDepth.ncl")
print("Done!")

print("Loading file for variables in 3 coordinates(Time,Latitude,Longitude) .....")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/var_3_coordinates/add3DVars.ncl")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/var_3_coordinates/add3DComposedVars.ncl")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/Interpolated_Var/addInterpolatedWinds.ncl")
print("Done!")

print("Loading file for variables in 4 coordinates(Time,Depth,Latitude,Longitude) .....")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/var_4_coordinates/add4DVars.ncl")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/var_4_coordinates/add4DComposedVars.ncl")
print("Done!")

print("Loading file for variables in 1 coordinate(Time")
loadscript ("/ServerScripts/WRF-CHEM_to_OWGIS/var_1_coordinates/addVar.ncl")
print("Done!")
validar=0
;dia=6
;mes=11

;------- Setting the proper input and output filenames ------
print("Configuring file names...")
begTime = get_cpu_time()
; Reads input data (date and input and output folders)
thisDay = (/anio,mes,dia/);(/2016,10,24/)
inputFolder=in
outputFolder=out

inputFolder_sesgo=in_sesgo
; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
dim_time = 73 ; define the  variable dim_time 

domain=1 ;Here we have only one domain
inputFile= inputFolder+"wrfout_d0"+domain+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+"_00:00:00"
outputFile= outputFolder+"Dom"+domain+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc"

inputFile_sesgo= inputFolder_sesgo+"sesgo_"+sprintf("%02g",mes)+".nc"

print("Reading this file:"+ inputFile)
print("Writing to this file:"+ outputFile)

fin = addfile(inputFile,"r"); open the file wrf
fin_sesgo = addfile(inputFile_sesgo,"r"); open the file wrf
system("rm -f " +outputFile)    ; remove if exists
fout = addfile(outputFile,"c"); open the file NetCDF 

; ------- Setting global attributes for netCDF file -----
fout@Conventions = "CF-1.6"
fout@Description= "Made at the Center of Atmospheric Sciences, UNAM. Contact: Olmo Zavala"

; Explicitly declare file definition mode. Improve efficiency.
setfileoption(fout,"DefineMode",True)

;------------ Creating Time dimension --------------------------------------
print("Adding Time dimension....")
Time = addTime(fout, dim_time, thisDay);function
print("Done!")

;------------ Creating Latitude dimension --------------------------------------
print("Adding latitude...")
dim_lat = addLat(fin,fout);function
print("Done!")

;------------ Creating Longitude dimension --------------------------------------
print("Adding longitude...")
dim_lon = addLon(fin,fout);function
print("Done!")

;------------ Creating Depth dimension --------------------------------------
print("Adding depth ...")
dim_depth = addDepth(fin,fout);function
print("Done!")

times=fin->XTIME
print(times)


; ---------- For Variables with 3 coordinates ----------
do conVar3 = 0,dimsizes(var3)-1
    ;valid if there are variables in 3 dimensions
    if(var3(conVar3) .eq. "none") then 
        print("No 3D coordinates variables")
    else 
        ; ---------- Adding 3 coordinates variables from file
        varNames=var3(conVar3);valid variables in file configuration.txt (/"U10","V10","PBLH","SWDOWN","GLW","RAINC","T2","SST"/)
        add3DVars(varNames, fin,fout,dim_time, dim_lat, dim_lon);procedure
        delete(varNames)
    end if
validar=1
end do

; ---------- For Variables with 3 coordinates composed----------
do conVar3C = 0,dimsizes(var3C)-1
    ;valid if there are variables in 3 dimensions composed
    if(var3C(conVar3C) .eq. "none") then
        print("No variables 3 coordinates composed")
    else
        ; ------- Adding 3D composed variable 
        varNames = var3C(conVar3C);;valid variables in file configuration.txt (/ "WS10", "PREC2", "T2C", "SSTC", "PREC2B" /)
        add3DComposedVars(varNames,fin,fout,dim_time, dim_lat, dim_lon)
        if(var3C(conVar3C) .eq. "WS10")
         ; ------- Adding interpolated Winds  -------------------
            addInter(fin,fout,dim_time, dim_lat, dim_lon)
        end if
        delete(varNames)
    end if
validar=1
end do

do conVar4 = 0,dimsizes(var4)-1
    if(var4(conVar4) .eq. "none")
        print("No variable 4 coordinates")
    else
    ; ---------- Adding 4D variables from file -------------------
        varNames=var4(conVar4); (/"P","QVAPOR","QCLOUD"/)
        add4DVars(varNames,fin,fout,dim_time,dim_depth,dim_lat, dim_lon)
        print("Done!")
        delete(varNames)
validar=1
    end if
end do
  
do conVar4C = 0,dimsizes(var4C)-1
    if(var4C(conVar4C) .eq. "none")
        print("No variable 4 coordinates composed")
    else   
        ; ------- Adding 4D composed variables  -------------------
        varNames =var4C(conVar4C); (/"RH","PA","WS"/)
        add4DComposedVars(varNames, fin,fout,dim_time, dim_depth, dim_lat, dim_lon)
        print("Done!") 
        delete(varNames)
validar=1
    end if
end do       

delete(dim_lon)
delete(dim_lat)
delete(Time)


if validar .eq. 1 then
  system ("mv  /ServerData/OWGIS/WRF-CHEM/Dom1*_"+thisDay(0)+"-"+sprintf("%02g",thisDay(1))+"-"+sprintf("%02g",thisDay(2))+".nc  /ServerData/OWGIS/WRF-CHEM/nuevo/")
  print("Done mv!")
  system ("rm -f /ServerData/OWGIS/WRF-CHEM/*.nc")
  print("Done rm!")
  system ("mv  /ServerData/OWGIS/WRF-CHEM/nuevo/*.nc  /ServerData/OWGIS/WRF-CHEM/")
  print("Done mv!")
 end if
