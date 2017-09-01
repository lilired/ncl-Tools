;----------- Reading ncl Files --------

print("Loading files.....")
loadscript ("Lib/tools.ncl")
loadscript ("Lib/createTime.ncl")

print("Done!")

;------- Setting the proper input and output filenames ------
print("Configuring file names...")
begTime = get_cpu_time()

; Reads all the files

;-------  Only for testing without the bash file -------
;in="/ServerData/Pronosticos/Salidas/ADCIRC/"
;out="/ServerData/OWGIS/ADCIRC/"
;dia = "31"
;mes = "08"
;anio = "2017"
;-------  Only for testing without the bash file -------

dataFolder=in
outputFolder=out
day = "31"
month = "08"
year = "2017"

inputFolder=dataFolder+year+"_"+month+"_"+day+"_00/salidas/"

print("Input folder: "+inputFolder)

fileNames = (/"gom-fort.63.nc","pom-fort.63.nc"/)
outputFiles = (/"gom-owgis.nc","pom-owgis.nc"/)

TodayDate = systemfunc("date -I")
thisDay = getDate(TodayDate)

do idxFile = 0,1
    inputFile = inputFolder+fileNames(idxFile)
    outputFile = outputFolder+outputFiles(idxFile)
    print("*******************************************************")
    print("Input file: "+inputFile)
	print("Output file:"+outputFile)
    	
	fin := addfile(inputFile,"r"); Abre el archivo NetCDF 
	system("rm -f " +outputFile)    ; remove if exists
	fout := addfile(outputFile,"c"); Abre el archivo NetCDF 

	; ------- Setting global attributes for netCDF file -----
	fout@Conventions = "CF-1.6 Unstructured"
	fout@Description= "Made at UNAM, at Center of Atmospheric Sciences. Conctact: Olmo Zavala"

	; Explicitly declare file definition mode. Improve efficiency.
	setfileoption(fout,"DefineMode",True)

	; Adding dimensions (this must be in order with the original file)
	dimnames = (/"node",  "nele", "nvertex", "nope", "max_nvdll", "nbou", "max_nvell", "mesh"/)
	currDimSizes = getfiledimsizes(fin) ; Gets the dimensions from original file

	; HARDCODED the number of dimensions obtained from original file
	dimsize = currDimSizes(2:9)
	dimunlimited = (/False, False,  False, False, False, False, False, False/)

	filedimdef(fout, dimnames, dimsize, dimunlimited) ;Defines the dimensions of the file

	; Adding the time variable
	print("Adding time variable....")
	origVar := fin->time
	filedimdef(fout, (/"Time"/), -1, (/True/)) ;Create Dimension
    filevardef(fout, "Time" ,typeof(origVar),"Time") ; Create Variable
    origVar@standard_name = "Time"
    origVar@long_name = "Time"
    origVar@units = str_sub_str(origVar@units, "!NCDA", "")
    origVar@calendar = "gregorian"
    filevarattdef(fout,"Time",origVar) ; Create attributes
    fout->Time   = (/origVar/)  ; Add values

	; Copying requiered variables (that we do not neet to modify)
	print("Copying required variables....")
	varNames := (/"x", "y", "element", "adcirc_mesh", "neta", "nvdll", "max_nvdll", "ibtypee", "nbdv", "nvel", \
					"nvell", "max_nvell", "ibtype", "nbvv", "depth"/)

	copyVarExactly(varNames, fin,fout)

	; Adding the important variable (zeta)
	print("Adding zeta....")
	temp := fin->zeta
	filevardef(fout, "zeta" ,typeof(temp), (/"Time","node"/)) ; zeta dimension
	filevarattdef(fout,"zeta",temp)                 
	fout->zeta   = (/temp /)

	print("Done for this file!....")

end do 
print("Completely done!")

quit

