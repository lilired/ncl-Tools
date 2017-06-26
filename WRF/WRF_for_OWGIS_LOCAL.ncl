;----------- Reading ncl Files --------
print("Loading file the configuration init.....")
loadscript ("./configuration.txt")
;print(var3)
print("Done!")

print("Loading files.....")
loadscript ("./init/tools.ncl")
loadscript ("./init/createTime.ncl")
loadscript ("./init/createLon.ncl")
loadscript ("./init/createLat.ncl")
loadscript ("./init/createDepth.ncl")
loadscript ("./prec/addPRECH.ncl")
loadscript ("./prec/addPreca3.ncl")
loadscript ("./prec/addPreca6.ncl")
loadscript ("./init/createLonU.ncl")
loadscript ("./init/createLatU.ncl")
loadscript ("./init/createDepthU.ncl")
loadscript ("./init/createLonV.ncl")
loadscript ("./init/createLatV.ncl")
loadscript ("./var_3_coordinates/add3DVars.ncl")
loadscript ("./var_3_coordinates/add3DComposedVars.ncl")
loadscript ("./Interpolated_Var/addInterpolatedWinds.ncl")
loadscript ("./var_4_coordinates/add4DVarsU.ncl")
loadscript ("./var_4_coordinates/add4DVarsV.ncl")
loadscript ("./var_4_coordinates/add4DVars.ncl")
loadscript ("./var_4_coordinates/add4DComposedVars.ncl")
loadscript ("./var_1_coordinates/addVar.ncl")

print("Done!")

;------- Setting the proper input and output filenames ------
print("Configuring file names...")
begTime = get_cpu_time()
dia=21
thisDay = (/anio,mes,dia/);(/2016,10,24/)
months=(/"01_enero","02_febrero","03_marzo","04_abril","05_mayo","06_junio","07_julio","08_agosto","09_septiembre","10_octubre","11_noviembre","12_diciembre"/)

; Reads all the files

dataFolder=in
outputFolder=out

inputFolder=dataFolder+toint(thisDay(0))+"/"+months(toint(thisDay(1))-1)+"/"
; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
print(inputFolder)

dim_time = 121

; Iterate over the 2 domains
do dominio=1,2

    ; --- TODO (COMMENT THIS LINE ON PRODUCTION) Add the following line, to read from an specific date file
    inputFile= inputFolder+"wrfout_d0"+dominio+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+"_00.nc"
    outputFile= outputFolder+"Dom"+dominio+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+".nc"

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

    ;------------ Creating Depth dimension --------------------------------------
    print("Adding depth ...")
    dim_depth = addDepth(fin,fout)
    print("Done!")

    ; ---------- For Variables the 3 coordinates ----------
        if(var3 .eq. "none") then
          print("No variables 3 coordinates")
        else 
          ; ---------- Adding 3 coordinates variables from file
          varNames=var3;(/"U10","V10","PBLH","SWDOWN","GLW","RAINC","T2","SST"/)
          add3DVars(varNames, fin,fout,dim_time, dim_lat, dim_lon)
        end if

    ; ---------- For Variables the 1 coordinates ----------
        if(var1 .eq. "none") then
          print("No variables 1 coordinates")
        else 
          ; ------- Adding time composed variables
          delete(varNames)
          varNames =var1; (/"HFX_FORCE","LH_FORCE"/)
          addVar(varNames, fin,fout,dim_time)
          delete(varNames)
        end if


    ; ---------- For Variables the 3 coordinates  composed----------
        if(var3C .eq. "none") then
          print("No variables 3 coordinates composed")
        else
          ; ------- Adding 3D composed variable 
         delete(varNames)
         varNames = var3C;(/ "WS10", "PREC2", "T2C", "SSTC", "PREC2B" /)
         add3DComposedVars(varNames, fin,fout,dim_time, dim_lat, dim_lon)
         
         if(var3C .eq. "WS10")
            ; ------- Adding interpolated Winds  -------------------
            addInter(fin,fout,dim_time, dim_lat, dim_lon)
            delete(varNames)
         end if
       end if

    ; ---------- For Variables the Precipitation----------
        if(varP .eq. "none") then
          print("No variable Precipitation")

        else

          if(var3C .eq. "PREC2B") then
             ; ---------------- Define time for Precipitation every hour ---------------
             print("Adding PRECH y TimePRECH...")
             prech = addPRECH(fin,fout,Time, dim_time, dim_lat, dim_lon)
             print("Done!")

             if (varP .eq. "preca3") then
                ; ----------------- Add the PRECA3 variable ------
                print("Adding PRECA3....")
                preca3 = addPrecAcu3(prech,fout, dim_lat, dim_lon)
                print("Done!")
             end if

             if (varP .eq. "preca6") then
                ; ----------------- Add the PRECA6 variable ------
                print("Adding PRECA6....")
                preca6 = addPrecAcu6(prech,fout, dim_lat, dim_lon)
                print("Done!")
             end if

             delete(prech)
             delete(preca3)
             delete(preca6)
            delete(varNames)
          end if   
        end if    

        if(var4 .eq. "none")
          print("No variable U and V")
        else
          if((var4E .eq. "U") .and. (var4 .eq. "V"))
            ;------------ Creating Latitude dimension U--------------------------------------
            print("Adding latitude U...")
            dim_latU = addLatU(fin,fout)
            print("Done!")

            ;------------ Creating Longitude dimension U--------------------------------------
            print("Adding longitude U...")
            dim_lonU = addLonU(fin,fout)
            print("Done!")

            ;------------ Creating Depth dimension U--------------------------------------
            print("Adding depth U...")
            dim_depthU = addDepthU(fin,fout)
            print("Done!")

            ;------------ Creating Latitude dimension V--------------------------------------
            print("Adding latitude V...")
            dim_latV = addLatV(fin,fout)
            print("Done!")

            ;------------ Creating Longitude dimension V--------------------------------------
            print("Adding longitude V...")
            dim_lonV = addLonV(fin,fout)
            print("Done!")

            ; ---------- Adding 4D variable U from file -------------------
            delete(varNames)
            varNames= (/"U"/)
            add4DVarsU(varNames,fin,fout,dim_time,dim_depth,dim_latU, dim_lonU)
            print("Done!")

            ; ---------- Adding 4D variable V from file -------------------
            delete(varNames)
            varNames= (/"V"/)
            add4DVarsV(varNames,fin,fout,dim_time,dim_depth,dim_latV, dim_lonV)
            print("Done!")

            delete(dim_lonU)
            delete(dim_latU)
            delete(dim_lonV)
            delete(dim_latV) 
            delete(varNames)
          end if
        end if

        if(var4 .eq. "none")
          print("No variable 4 coordinates")
        else
         ; ---------- Adding 4D variables from file -------------------
         delete(varNames)
         varNames=var4; (/"P","QVAPOR","QCLOUD"/)
         add4DVars(varNames,fin,fout,dim_time,dim_depth,dim_lat, dim_lon)
         print("Done!")
         delete(varNames)
        end if
      

        if(var4 .eq. "none")
          print("No variable 4 coordinates composed")
        else   
          ; ------- Adding 4D composed variables  -------------------
          delete(varNames)
          varNames =var4C; (/"RH","PA","WS"/)
          add4DComposedVars(varNames, fin,fout,dim_time, dim_depth, dim_lat, dim_lon)
          print("Done!") 
          delete(varNames)
        end if
          
    
    delete(dim_lon)
    delete(dim_lat)
    delete(Time)
    print("Done!") 
end do
