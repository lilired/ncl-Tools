;----------- Reading ncl File configuration--------
print("Loading file configuration.....")
loadscript ("./configuration.txt")
print("Done!")

;----------- Reading ncl Files --------
print("Loading file the configuration init.....")
print("Loading files.....")
loadscript ("../TOOLS/tools.ncl")
loadscript ("./init/createTime.ncl")
loadscript ("./init/createLon.ncl")
loadscript ("./init/createLat.ncl")
print("Done!")

print("Loading file the procedure for variables in 3 coordinates(Time,Latitude,Longitude) .....")
print("Loading files.....")
loadscript ("./var_3_coordinates/add3DVars.ncl")
loadscript ("./var_3_coordinates/add3DComposedVars.ncl")
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

  ;starts the 5 days cycle
  do cond=0,4

     thisDay = (/anio,mes,dia/);(/2016,10,24/)
     months=(/"01_enero","02_febrero","03_marzo","04_abril","05_mayo","06_junio","07_julio","08_agosto","09_septiembre","10_octubre","11_noviembre","12_diciembre"/)

     ; Reads all the files
     dataFolder=in
     outputFolder=out

     inputFolder=dataFolder+"salidas_wwiii_"+anio+"-"+sprintf("%02g",mes_inicial)+"-"+sprintf("%02g",dia_inicial)+"_00/"

     ; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
     print(inputFolder)

     dim_time = 24
 
     ; --- TODO (COMMENT THIS LINE ON PRODUCTION) Add the following line, to read from an specific date file
     outputFolder2= outputFolder+dom+"/"+anio+sprintf("%02g",mes_inicial)+sprintf("%02g",dia_inicial)
     inputFile= inputFolder+"ww3out.grd_"+dom+"."+anio+sprintf("%02g",mes)+sprintf("%02g",dia)+".nc"
     outputFile= outputFolder2+"/"+dom+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc"

     print("Reading this file:"+ inputFile)
     print("Writing to this file:"+ outputFile)

     fin = addfile(inputFile,"r"); Abre el archivo wrf
     system("mkdir " +outputFolder2) 
     system("rm -f " +outputFile)    ; remove if exists
     fout = addfile(outputFile,"c"); Abre el archivo NetCDF 

     ; ------- Setting global attributes for netCDF file -----
     fout@Conventions = "CF-1.6"
     fout@Description= "Made at UNAM, at Center of Atmospheric Sciences. Conctact: Olmo Zavala"

     ; Explicitly declare file definition mode. Improve efficiency.
     setfileoption(fout,"DefineMode",True)

     ;------------ Creating Time dimension --------------------------------------
     print("Adding Time dimension....")
     Time = addTime(fout, dim_time, thisDay);procedure
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
 
     ;validated if for day variable equals 31
     if dia .eq. 31 then
        dia=dia-30
        mes=mes+1
     else
        dia=dia+1
     end if
 
    ;validated if for day variable equals 30
     if dia .eq. 30 then
        ;validated if for month variable equals 4
        if mes .eq. 4 ten
           dia=dia-29
           mes=mes+1
        else
           ;validated if for month variable equals 6
           if mes .eq. 6 then
                dia=dia-29
                mes=mes+1
           else 
                ;validated if for month variable equals 9
                if mes .eq. 9 then
                   dia=dia-29
                   mes=mes+1
                else
                   ;validated if for month variable equals 11 
                   if mes .eq. 11 then
                      dia=dia-29
                      mes=mes+1
                   end 
                end 
           end  
        end 
     else
        dia=dia+1
     end if
    
     ;validated if for month variable equals 2
     if mes .eq. 2 then
        ;validated if for day variable equals 28
        if dia .eq. 28 then
           dia=dia-27
           mes=mes+1
        else
        dia=dia+1
        end
     end 

  end do
  ;end the 5 days cycle
  dia=dia_inicial
end do
;end of domanis cycle 
