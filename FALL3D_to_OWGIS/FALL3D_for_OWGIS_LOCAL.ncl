;----------- Reading ncl Files --------
print("Loading file the configuration init.....")
loadscript ("/ServerScripts/FALL3D_to_OWGIS/configuration.txt")
print("Done!")

print("Loading files.....")
loadscript ("/ServerScripts/TOOLS/tools.ncl")
loadscript ("/ServerScripts/FALL3D_to_OWGIS/init/createTime.ncl")
loadscript ("/ServerScripts/FALL3D_to_OWGIS/init/createTime2.ncl")
loadscript ("/ServerScripts/FALL3D_to_OWGIS/init/createTime0.ncl")
loadscript ("/ServerScripts/FALL3D_to_OWGIS/init/createLon.ncl")
loadscript ("/ServerScripts/FALL3D_to_OWGIS/init/createLat.ncl")
loadscript ("/ServerScripts/FALL3D_to_OWGIS/init/createDepth.ncl")
loadscript ("/ServerScripts/FALL3D_to_OWGIS/init/createDepth2.ncl")

loadscript ("/ServerScripts/FALL3D_to_OWGIS/var_3_coordinates/add3Vars.ncl")
;loadscript ("/ServerScripts/FALL3D_to_OWGIS/var_3_coordinates/add3DComposedVars.ncl")
loadscript ("/ServerScripts/FALL3D_to_OWGIS/var_4_coordinates/add4DVars.ncl")

print("Done!")

;------- Setting the proper input and output filenames ------
print("Configuring file names...")
begTime = get_cpu_time()
;dia=31
;mes=1
;anio=2017
   dia_inicial=dia

   mes_inicial=mes

     thisDay1 = (/anio,mes_inicial,dia_inicial/);(/2016,10,24/)

; Reads all the files

dataFolder=in
outputFolder=out

inputFolder=dataFolder+anio+sprintf("%02g",mes)+sprintf("%02g",dia)+"/";+toint(thisDay(0))+"/"+months(toint(thisDay(1))-1)+"/"
; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
print(inputFolder)


;hour=1
; Iterate over the 3 domains


    ; --- TODO (COMMENT THIS LINE ON PRODUCTION) Add the following line, to read from an specific date file
 ;   inputFile= inputFolder;+"p_"+sprintf("%02g",hour)+"h_"+sprintf("%02g",metro)+"M.res.nc"
   

   ;  inputFolder=dataFolder+"salidas_wwiii_"+anio+"-"+sprintf("%02g",mes_inicial)+"-"+sprintf("%02g",dia_inicial)+"_00/"

     ; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
     print(inputFolder)


;hour=1
; Iterate over the 3 domains
do metros=0,2

if metros .eq. 0 then
    metro=3
dim_time=352
  end if
if metros .eq. 1 then
    metro=5	
dim_time=360	
  end if
if metros .eq. 2 then
    metro=10
dim_time=360
  end if



    ; --- TODO (COMMENT THIS LINE ON PRODUCTION) Add the following line, to read from an specific date file
 ;   inputFile= inputFolder;+"p_"+sprintf("%02g",hour)+"h_"+sprintf("%02g",metro)+"M.res.nc"
   

   ;  inputFolder=dataFolder+"salidas_wwiii_"+anio+"-"+sprintf("%02g",mes_inicial)+"-"+sprintf("%02g",dia_inicial)+"_00/"

     ; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
     print(inputFolder)
;p_01h_03M.res.nc
     files = systemfunc(" ls "+inputFolder+"p_*h_"+sprintf("%02g",metro)+"M.res.nc")  
     fin = addfiles(files,"r")

outputFile= outputFolder+"p_"+sprintf("%02g",metro)+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc"

    print("Writing to this file:"+ outputFile)

  ;  fin = addfile(inputFile,"r"); Abre el archivo wrf
    system("rm -f " +outputFile)    ; remove if exists
    fout = addfile(outputFile,"c"); Abre el archivo NetCDF 

    ; ------- Setting global attributes for netCDF file -----
    fout@Conventions = "CF-1.6"
    fout@Description= "Made at UNAM, at Center of Atmospheric Sciences. Conctact: Olmo Zavala"

    ; Explicitly declare file definition mode. Improve efficiency.
    setfileoption(fout,"DefineMode",True)

    dim_time2=10
    dim_time3=2

    ;------------ Creating Time dimension --------------------------------------
    print("Adding Time dimension....")
    Time = addTime(fout,dim_time2,thisDay1)
    print("Done!")

    ;------------ Creating Time dimension --------------------------------------
    print("Adding Time dimension....")
     addTimes2(fout,fin,dim_time3,thisDay1)
    print("Done!")
    ;************************************************************************************

    ;------------ Creating Time dimension --------------------------------------
    print("Adding Time dimension....")
    addTimes(fout,fin,dim_time2,dim_time3,thisDay1,metros)
    print("Done!0")
  
    ;************************************************************************************
   
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
             add3Vars(varNames,fin,fout,dim_time,dim_time2,dim_lat,dim_lon)
             delete(varNames)
           end if
    end do
    ;------------ Creating Latitude dimension --------------------------------------
    print("Adding Depth...")
    dim_depth = addDepth(fin,fout)
    print("Done!")
    ;------------ Creating Latitude dimension --------------------------------------
    print("Adding Depth2...")
    dim_depth2 = addDepth2(fin,fout)
    print("Done!")
dim_depth2=0

    ; ---------- For Variables the 4 coordinates ----------
    do conVar4 = 0,dimsizes(var4)-1
           if(var4(conVar4) .eq. "none") then
             print("No variables 4 coordinates")
           else 
             ; ---------- Adding 3 coordinates variables from file
             varNames=var4(conVar4);
           add4DVars(varNames,fin,fout,dim_time,dim_time2,dim_time3,dim_depth2,dim_lat,dim_lon,dim_depth,metros)
             delete(varNames)
           end if
    end do
;consentracion=fout->consentracion
;print(consentracion)
     delete(dim_lon)
    delete(dim_lat)
    delete(Time)
     delete(files)
    delete(fin)
if metros .eq. 0
   validar_metro3=1
end if
if metros .eq. 1
   validar_metro5=1
end if
if metros .eq. 2
   validar_metro10=1
end if
end do
if validar_metro3 .eq. 1 then
  system ("mv  /ServerData/OWGIS/FALL3D/p_03_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc  /ServerData/OWGIS/FALL3D/nuevo/")
  print("Done mv!")
system ("rm -f /ServerData/OWGIS/FALL3D/p_03*.nc")
  print("Done rm!")
system ("mv  /ServerData/OWGIS/FALL3D/nuevo/p_03*.nc  /ServerData/OWGIS/FALL3D/")
  print("Done mv!")
 else
  print("no hay salidas de hoy para 3 metros")
end if

if validar_metro5 .eq. 1 then
  system ("mv  /ServerData/OWGIS/FALL3D/p_05_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc  /ServerData/OWGIS/FALL3D/nuevo/")
  print("Done mv!")
system ("rm -f /ServerData/OWGIS/FALL3D/p_05*.nc")
  print("Done rm!")
system ("mv  /ServerData/OWGIS/FALL3D/nuevo/p_05*.nc  /ServerData/OWGIS/FALL3D/")
  print("Done mv!")
 else
  print("no hay salidas de hoy para 5 metros")
end if

if validar_metro3 .eq. 1 then
  system ("mv  /ServerData/OWGIS/FALL3D/p_10_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc  /ServerData/OWGIS/FALL3D/nuevo/")
  print("Done mv!")
system ("rm -f /ServerData/OWGIS/FALL3D/p_10*.nc")
  print("Done rm!")
system ("mv  /ServerData/OWGIS/FALL3D/nuevo/p_10*.nc  /ServerData/OWGIS/FALL3D/")
  print("Done mv!")
 else
  print("no hay salidas de hoy para 10 metros")
end if
