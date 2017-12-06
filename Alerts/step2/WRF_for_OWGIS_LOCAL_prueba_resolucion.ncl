;----------- Reading ncl File configuration--------
print("Loading file configuration.....")
loadscript ("/ServerScripts/WRF_to_OWGIS/configuration_r.txt")
;loadscript ("/ServerScripts/WRF_to_OWGIS/configuration.txt")
print("Done!")

;----------- Reading ncl Files --------
print("Loading file the configuration init.....")
print("Loading files.....")
loadscript ("/ServerScripts/TOOLS/tools.ncl")
loadscript ("/ServerScripts/WRF_to_OWGIS/init/createTime.ncl")
loadscript ("/ServerScripts/WRF_to_OWGIS/init/createLon.ncl")
loadscript ("/ServerScripts/WRF_to_OWGIS/init/createLat.ncl")
;loadscript ("/ServerScripts/WRF_to_OWGIS/init/createDepth.ncl")
print("Done!")

print("Loading file the procedure for precipítation.....")
print("Loading files.....")
loadscript ("/ServerScripts/WRF_to_OWGIS/resolucion/regrid_liliana.ncl")

;dia=10
;------- Setting the proper input and output filenames ------
print("Configuring file names...")
begTime = get_cpu_time()
thisDay = (/anio,mes,dia/);(/2016,10,24/); 
months=(/"01_enero","02_febrero","03_marzo","04_abril","05_mayo","06_junio","07_julio","08_agosto","09_septiembre","10_octubre","11_noviembre","12_diciembre"/)

; Reads all the file path in and out
dataFolder=in
dataFolder1=in_otro
outputFolder=out

; The file path in add folders
inputFolder=dataFolder+toint(thisDay(0))+"/"+months(toint(thisDay(1))-1)+"/"

;start of domanis cycle 
;;;;; Iterate over the 2 domains
do dominio=1,2  ;
    ; --- TODO (COMMENT THIS LINE ON PRODUCTION) Add the following line, to read from an specific date file
    inputFile= inputFolder+"wrfout_d0"+dominio+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+"_00.nc"
    outputFile= outputFolder+"nuevo/Percentil_Dom"+dominio+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc"
    inputFile1= dataFolder1+"Percentiles.nc"

    print("Reading this file:"+ inputFile)
    print("Reading this file1:"+ inputFile1)
    print("Writing to this file:"+ outputFile)

    fin = addfile(inputFile,"r"); open the file wrf
    fin1 = addfile(inputFile1,"r"); open the file wrf
    system("rm -f " +outputFile)    ; remove if exists
    fout = addfile(outputFile,"c"); open the file NetCDF 

      ; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
      dim_time = 1;21 ; define the  variable dim_time 


    ; ------- Setting global attributes for netCDF file -----
    fout@Conventions = "CF-1.6"
    fout@Description= "Made at UNAM, at Center of Atmospheric Sciences. Conctact: Olmo Zavala"

    ; Explicitly declare file definition mode. Improve efficiency.
    setfileoption(fout,"DefineMode",True)

    ;------------ Creating Time dimension --------------------------------------
    print("Adding Time dimension....")
    Time = addTime(fout, dim_time, thisDay) ;function
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
   ; print("Adding depth ...")
    ;dim_depth = addDepth(fin,fout);function
    ;print("Done!")
    Dom=dominio
     ;start of variables in 3 dimesions cycle 
     ;;;;;;; ---------- For Variables the 3 coordinates ----------
     ;;;;;;;; Iterate over of variables in 3 dimensions
     do conVar3 = 0,dimsizes(var3)-1
           ;valid if there are variables in 3 dimensions
           if(var3(conVar3) .eq. "none") then 
             print("No variables 3 coordinates")
           else 
             ; ---------- Adding 3 coordinates variables from file
             varNames=var3(conVar3);valid variables in file configuration.txt (/"U10","V10","PBLH","SWDOWN","GLW","RAINC","T2","SST"/)
                      ;varNames2=var3Por(conVar3)
             ;add3DVars(varNames,fin,fout,dim_time, dim_lat, dim_lon);procedure
              addresolucion(varNames,var3Por,fin,fin1,fout,dim_time, dim_lat, dim_lon,thisDay,Dom)
              delete(varNames)
           end if
    end do
    ;end of variables in 3 dimensions cycle

    

      delete(dim_lon)
      delete(dim_lat)
      delete(Time)
if dominio .eq. 1
   validar_dom1=1
end if
if dominio .eq. 2
   validar_dom2=1
end if

end do
;end of domanis cycle 

if validar_dom1 .eq. 2 then
  system ("mv  /ServerData/OWGIS/WRF/Dom1*_"+thisDay(0)+"-"+sprintf("%02g",thisDay(1))+"-"+sprintf("%02g",thisDay(2))+".nc  /ServerData/OWGIS/WRF/nuevo/")
  print("Done mv!")
system ("rm -f /ServerData/OWGIS/WRF/Dom1*.nc")
  print("Done rm!")
system ("mv  /ServerData/OWGIS/WRF/nuevo/Dom1*.nc  /ServerData/OWGIS/WRF/")
  print("Done mv!")
 else
  print("no hay salidas de hoy para dom1")
end if

if validar_dom2 .eq. 2 then
  system ("mv  /ServerData/OWGIS/WRF/Dom2*_"+thisDay(0)+"-"+sprintf("%02g",thisDay(1))+"-"+sprintf("%02g",thisDay(2))+".nc  /ServerData/OWGIS/WRF/nuevo/")
  print("Done mv!")
system ("rm -f /ServerData/OWGIS/WRF/Dom2*.nc")
  print("Done rm!")
;system ("mv  /ServerData/OWGIS/WRF/nuevo/Dom2*.nc  /ServerData/OWGIS/WRF/")
  print("Done mv!")
 else
  print("no hay salidas de hoy para dom2")
end if
