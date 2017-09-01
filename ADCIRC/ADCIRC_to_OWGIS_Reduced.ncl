;----------- Reading ncl Files --------
print("Loading file the configuration init.....")
loadscript ("./configuration.txt")
print("Done!")

print("Loading files.....")
loadscript ("../Lib/tools.ncl")
loadscript ("../Lib/createTime.ncl")

print("Done!")

;------- Setting the proper input and output filenames ------
print("Configuring file names...")
begTime = get_cpu_time()

; Reads all the files

;-------  Only for testing without the bash file -------
in="/ServerData/Pronosticos/Salidas/ADCIRC/"
out="/ServerData/OWGIS/ADCIRC/"
dia = "31"
mes = "08"
anio = "2017"
;-------  Only for testing without the bash file -------

dataFolder=in
outputFolder=out


inputFolder=dataFolder+anio+"_"+mes+"_"+dia+"_00/salidas/"

print("Input folder: "+inputFolder)

fileNames = (/"gom-fort.63.nc","pom-fort.63.nc"/)
outputFiles = (/"gom-owgis.nc","pom-owgis.nc"/)

TodayDate = systemfunc("date -I")
thisDay = getDate(TodayDate)

do idxFile = 0,1
    inputFile = inputFolder+fileNames(idxFile)
    outputFile = outputFolder+outputFiles(idxFile)
    	
	fin := addfile(inputFile,"w"); Abre el archivo NetCDF 
    time = fin->time
    time@long_name = "Time"
    time@units = str_sub_str(time@units, "!NCDA", "")
    time@base_date= str_sub_str(time@base_date, "!NCDATE", "")
    fin->time = time
end do 
print("Completely done!")

quit


