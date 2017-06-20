;----------- Reading ncl Files --------
print("Loading files.....")

load "tools.ncl"
loadscript ("/home/lili/Escritorio/repos/ncl-Tools/WRF/init/createTime.ncl")
loadscript ("/home/lili/Escritorio/repos/ncl-Tools/WRF/init/createLon.ncl")
loadscript ("/home/lili/Escritorio/repos/ncl-Tools/WRF/init/createLat.ncl")
loadscript ("/home/lili/Escritorio/repos/ncl-Tools/WRF/init/createDepth.ncl")
loadscript ("/home/lili/Escritorio/repos/ncl-Tools/WRF/prec/addPRECH.ncl")
loadscript ("/home/lili/Escritorio/repos/ncl-Tools/WRF/prec/addPreca3.ncl")
loadscript ("/home/lili/Escritorio/repos/ncl-Tools/WRF/prec/addPreca6.ncl")


load "add3DVars.ncl"
load "add3DVars4.ncl"
load "add3DComposedVars.ncl"
load "addInterpolatedWinds.ncl"
load "add4DVars.ncl"
load "add4DComposedVars.ncl"
load "addVar.ncl"
print("Done!")

;------- Setting the proper input and output filenames ------
print("Configuring file names...")
begTime = get_cpu_time()
TodayDate = systemfunc("date -I --date='1 days ago'")

thisDay = getDate(TodayDate)
months=(/"01_enero","02_febrero","03_marzo","04_abril","05_mayo","06_junio","07_julio","08_agosto","09_septiembre","10_octubre","11_noviembre","12_diciembre"/)

; Reads all the files

;inputFolder="/ServerData/WRF/"+toint(thisDay(0))+"/"+months(toint(thisDay(1))-1)+"/"
;outputFolder="/ServerData/WRF_OWGIS/"



Ruta_wrf= rfile ;

ruta_com=Ruta_wrf


inputFolder=ruta_com+toint(thisDay(0))+"/"+months(toint(thisDay(1))-1)+"/"
outputFolder=ruta_com


; TODO comment this lines in server 
;inputFolder="/media/storageBK/storageBK/"
;outputFolder="/media/storageBK/storageBK/"

;inputFolder="/home/lili/Escritorio/repos/ncl/"
;outputFolder="/home/lili/Escritorio/repos/ncl/"

inputFolder=ruta_com
outputFolder=ruta_com


; ------- Setting time dimension (THIS IS HARDCODED, FIND A WAY TO FIX IT!) ---------
dim_time = 121

; Iterate over the 2 domains
do dominio=2,2

	; --- TODO (COMMENT THIS LINE ON PRODUCTION) Add the following line, to read from an specific date file
	;thisDay = (ani,mes,dia);(/2016,10,24/)
        ;print(thisDay)
anio=2017
mes=06
dia=19
inputFile= inputFolder+"wrfout_d0"+dominio+"_"+anio+"-"+sprintf("%02g",mes)+"-"+sprintf("%02g",dia)+"_00.nc"
print(inputFile)	
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

	;------------ Creating Depth dimension --------------------------------------
	print("Adding depth ...")
	dim_depth = addDepth(fin,fout)
	print("Done!")

        ; ---------- Adding 3D variables from file
	;varNames= (/ "T2","RAINC","U10","V10","SST"/)
        varNames=(/"U10","V10","PBLH","SWDOWN","GLW"/)
        add3DVars(varNames, fin,fout,dim_time, dim_lat, dim_lon)

        ; ---------- Adding 4D variables from file wind

	;varNames=(/"U","V"/)
        ;add3DVars4(varNames, fin,fout,dim_time,dim_depth,dim_lat, dim_lon)

        ; ------- Adding time composed variables 																																																																																																																									
	delete(varNames)
	varNames = (/"HFX_FORCE","LH_FORCE"/)
	addVar(varNames, fin,fout,dim_time)

        ; ------- Adding 3D composed variable 
																																																																																																										
	;delete(varNames)
	;varNames = (/ "WS10", "PREC2", "T2C", "SSTC", "PREC2B" /)
	;add3DComposedVars(varNames, fin,fout,dim_time, dim_lat, dim_lon)

	; ------- Adding interpolated Winds  -------------------
	;addInter(fin,fout,dim_time, dim_lat, dim_lon)

	; ---------------- Define time for Precipitation every hour ---------------
	;print("Adding PRECH y TimePRECH...")
	;prech = addPRECH(fin,fout,Time, dim_time, dim_lat, dim_lon)
	;print("Done!")

	; ----------------- Add the PRECA3 variable ------
	;print("Adding PRECA3....")
	;preca3 = addPrecAcu3(prech,fout, dim_lat, dim_lon)
	;print("Done!")

	; ----------------- Add the PRECA6 variable ------
	;print("Adding PRECA6....")
	;preca6 = addPrecAcu6(prech,fout, dim_lat, dim_lon)
	;print("Done!")

	; ---------- Adding 4D variables from file -------------------
	delete(varNames)
	varNames= (/"P","QVAPOR","QCLOUD","U"/)
	add4DVars(varNames,fin,fout,dim_time,dim_depth,dim_lat,dim_lon)

	; ------- Adding 4D composed variables  -------------------
	delete(varNames)
	varNames = (/"RH"/)
	add4DComposedVars(varNames, fin,fout,dim_time, dim_depth, dim_lat, dim_lon)

	delete(varNames)
	;delete(prech)
	;delete(preca3)
	;delete(preca6)
	delete(dim_lon)
	delete(dim_lat)
	delete(Time)
end do
quit(34)+rfile_prec+"addPreca6.ncl"+inttochar(34)	
;print(addPreca6)

