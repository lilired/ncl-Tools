;----------- Reading ncl File configuration--------
print("Loading file configuration.....")
loadscript ("/ServerScripts/WWIII_to_OWGIS/configuration.txt")
print("Done!")

;----------- Reading ncl Files --------
print("Loading file the configuration init.....")
print("Loading files.....")
loadscript ("/ServerScripts/TOOLS/tools.ncl")
loadscript ("/ServerScripts/WWIII_to_OWGIS/init/createTime.ncl")
loadscript ("/ServerScripts/WWIII_to_OWGIS/init/createLon.ncl")
loadscript ("/ServerScripts/WWIII_to_OWGIS/init/createLat.ncl")
print("Done!")

print("Loading file the procedure for variables in 3 coordinates(Time,Latitude,Longitude) .....")
print("Loading files.....")
loadscript ("/ServerScripts/WWIII_to_OWGIS/var_3_coordinates/add3DVars.ncl")
loadscript ("/ServerScripts/WWIII_to_OWGIS/var_3_coordinates/add3DComposedVars.ncl")
print("Done!")

;------- Setting the proper input and output filenames ------
print("Configuring file names...")
begTime = get_cpu_time()

;start of domanis cycle 
;;;;;;; Iterate over the 3 domains
do dominio=1,3
  ;valid if there are domanin 1  is gom
   if dominio .eq. 1 then
      dom="gom"
   end if
   ;valid if there are domanin 2  is pom
   if dominio .eq. 2 then
      dom="pom"
   end if
   ;valid if there are domanin 3  is wo   
   if dominio .eq. 3 then
      dom="wo"
   end if
   dia_inicial=dia

   mes_inicial=mes

thisDay1 = (/anio,mes_inicial,dia_inicial/);(/2016,10,24/)

     thisDay = (/anio,mes,dia/);(/2016,10,24/)
     months=(/"01_enero","02_febrero","03_marzo","04_abril","05_mayo","06_junio","07_julio","08_agosto","09_septiembre","10_octubre","11_noviembre","12_diciembre"/)

     ; Reads all the files
     dataFolder=in
     outputFolder=out
print(mes_inicial)
print(dia_inicial)
     inputFolder=dataFolder+"salidas_wwiii_"+anio+"-"+sprintf("%02g",mes_inicial)+"-"+sprintf("%02g",dia_inicial)+"_00/"

     ; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
     print(inputFolder)
     files = systemfunc(" ls "+inputFolder+"/*"+dom + "*.nc")  
     fin = addfiles(files,"r")

     ;dim_time = 97;121
 
     T=fin->XLAT(:,0,0)
     dimT=dimsizes(T)
     ;print(dimT)  

     if dimT .eq. 97 then
        ; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
        dim_time = 97 ; define the  variable dim_time 
     else
        ; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
        dim_time = 121 ; define the  variable dim_time 
     end if


     ; --- TODO (COMMENT THIS LINE ON PRODUCTION) Add the following line, to read from an specific date file

     outputFile= outputFolder+"/"+dom+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc"
     print("Writing to this file:"+ outputFile)

     system("rm -f " +outputFile)    ; remove if exists
     fout = addfile(outputFile,"c"); Abre el archivo NetCDF 

     ; ------- Setting global attributes for netCDF file -----
     fout@Conventions = "CF-1.6"
     fout@Description= "Made at UNAM, at Center of Atmospheric Sciences. Conctact: Olmo Zavala"

     ; Explicitly declare file definition mode. Improve efficiency.
     setfileoption(fout,"DefineMode",True)

     ;------------ Creating Time dimension --------------------------------------
     print("Adding Time dimension....")
     Time = addTime(fout, dim_time, thisDay1);procedure
     print("Done!")

     ;------------ Creating Latitude dimension --------------------------------------
     print("Adding latitude...")
     dim_lat = addLat(fin,fout);procedure
     print("Done!")

     ;------------ Creating Longitude dimension --------------------------------------
     print("Adding longitude...")
     dim_lon = addLon(fin,fout)
     print("Done!")
 
     ;start of variables in 3 dimesions cycle 
     ;;;;;;; ---------- For Variables the 3 coordinates ----------
     ;;;;;;;; Iterate over of variables in 3 dimensions
     do conVar3 = 0,dimsizes(var3)-1
           ;valid if there are variables in 3 dimensions
           if(var3(conVar3) .eq. "none") then
             print("No variables 3 coordinates")
           else 
             ; ---------- Adding 3 coordinates variables from file
             varNames=var3(conVar3);;valid variables in file configuration.txt hs, t01
             add3DVars(varNames, fin,fout,dim_time, dim_lat, dim_lon);procedure
             delete(varNames)
           end if
     end do
     ;end of variables in 3 dimesions cycle 
        
     ;start of variables in 3 dimesions composed cycle 
     ;;;;;;; ---------- For Variables the 3 coordinates composed ----------
     ;;;;;;;; Iterate over of variables in 3 dimensions composed
     do conVar3C = 0,dimsizes(var3C)-1
          ;valid if there are variables in 3 dimensions composed
          if(var3C(conVar3C) .eq. "none") then
             print("No variables 3 coordinates composed")
          else
             ; ------- Adding 3D composed variable 
             varNames = var3C(conVar3C);;;valid variables in file configuration.txt u,v
             add3DComposedVars(varNames, fin,fout,dim_time, dim_lat,dim_lon);procedure
             delete(varNames)
          end if
     end do
     ;end of variables in 3 dimesions composed cycle 

     delete(dim_lon)
     delete(dim_lat)
     delete(Time)
if dominio .eq. 1
   validar_gom=1
end if
if dominio .eq. 2
   validar_pom=1
end if
if dominio .eq. 3
   validar_wo=1
end if
end do
;end of domanis cycle


if validar_gom .eq. 1 then
  system ("mv  /ServerData/OWGIS/WWIII/gom_"+thisDay(0)+"-"+sprintf("%02g",thisDay(1))+"-"+sprintf("%02g",thisDay(2))+".nc  /ServerData/OWGIS/WWIII/nuevo/")
  print("Done mv!")
system ("rm -f /ServerData/OWGIS/WWIII/gom*.nc")
  print("Done rm!")
system ("mv  /ServerData/OWGIS/WWIII/nuevo/gom*.nc  /ServerData/OWGIS/WWIII/")
  print("Done mv!")
 else
  print("no hay salidas de hoy para gom")
end if

if validar_gom .eq. 1 then
  system ("mv  /ServerData/OWGIS/WWIII/gom_"+thisDay(0)+"-"+sprintf("%02g",thisDay(1))+"-"+sprintf("%02g",thisDay(2))+".nc  /ServerData/OWGIS/WWIII/nuevo/")
  print("Done mv!")
system ("rm -f /ServerData/OWGIS/WWIII/gom*.nc")
  print("Done rm!")
system ("mv  /ServerData/OWGIS/WWIII/nuevo/gom*.nc  /ServerData/OWGIS/WWIII/")
  print("Done mv!")
 else
  print("no hay salidas de hoy para gom")
end if


if validar_pom .eq. 1 then
  system ("mv  /ServerData/OWGIS/WWIII/pom_"+thisDay(0)+"-"+sprintf("%02g",thisDay(1))+"-"+sprintf("%02g",thisDay(2))+".nc  /ServerData/OWGIS/WWIII/nuevo/")
  print("Done mv!")
system ("rm -f /ServerData/OWGIS/WWIII/pom*.nc")
  print("Done rm!")
system ("mv  /ServerData/OWGIS/WWIII/nuevo/pom*.nc  /ServerData/OWGIS/WWIII/")
  print("Done mv!")
 else
  print("no hay salidas de hoy para pom")
end if


if validar_wo .eq. 1 then
  system ("mv  /ServerData/OWGIS/WWIII/wo_"+thisDay(0)+"-"+sprintf("%02g",thisDay(1))+"-"+sprintf("%02g",thisDay(2))+".nc  /ServerData/OWGIS/WWIII/nuevo/")
  print("Done mv!")
system ("rm -f /ServerData/OWGIS/WWIII/wo*.nc")
  print("Done rm!")
system ("mv  /ServerData/OWGIS/WWIII/nuevo/wo*.nc  /ServerData/OWGIS/WWIII/")
  print("Done mv!")
 else
  print("no hay salidas de hoy para wo")
end if

