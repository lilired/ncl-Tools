; Retrieves the year, month, and day-1 from the a date strng of the form "09/22/2016 (00:00)"
function getDate(strDate)
begin
    date = str_split(strDate(0),"-")
    return (/date(0), date(1), date(2)/)
end

begTime = get_cpu_time()
;TodayDate = systemfunc("date -I --date='1 days ago'")
TodayDate = systemfunc("date -I --date='0 days ago'")
thisDay = getDate(TodayDate)

;; Reads all the files
files = "/ServerData/Pronosticos/Salidas/GFS/"+toint(thisDay(0))+"_"+sprintf("%02g",toint(thisDay(1)))+"_"+sprintf("%02g",toint(thisDay(2)))+"_00/gfs.t00z.pgrb2*"
print("Files to be used: "+files)

print("Reading files............")
filesIn = systemfunc("ls "+files)
ncdf_out_fname_temp= "/ServerData/OWGIS/GFS/GFSTodayNew.nc" 
ncdf_out_fname_current = "/ServerData/OWGIS/GFS/GFSToday.nc" 
totFiles = dimsizes(filesIn)

grib_in = addfile(filesIn(0)+".grib2","r") ; Start only with the first file
exit()
ncdf_out = addfile(ncdf_out_fname_temp,"c")   
print(ncdf_out)

; *********** Dimension variables (these variables do not depend on the time axis, so we added outside the main loop) ************
; Specify desired GRIB variables, the ones we do not need to change
print("Adding lat and lon............")
grib_names = (/  "lat_0"   , "lon_0" /) 
ncl_names  = (/ "Latitude", "Longitude"/)
; Loop over selected variables and rename on output
do i=0, dimsizes(ncl_names)-1
    ncdf_out->$ncl_names(i)$ = grib_in->$grib_names(i)$ 
end do

;*********** These are the axis variables, we need to add a couple of attributes for ncWMS
delete(grib_names)
delete(ncl_names)
print("Adding coordinates............")
grib_names = (/"lv_ISBL0", "lv_HTGL2", "lv_ISBL8", "lv_HTGL7" /)
; Loop over selected variables and rename on output
do i=0, dimsizes(grib_names)-1
    ax = grib_in->$grib_names(i)$
    ax@positive = "up"
    ax@axis = "Z"
    ncdf_out->$grib_names(i)$ = ax 
    delete(ax)
end do

; *********** Create the time dimension ********
; Obtain the date from one variable and its attribute 'initial_time'
print("Adding time coordinate............")
time = ispan(0,(totFiles-1)*6,6) ;time steps every 6 hours
time@standard_name = "time"
time@long_name = "time"
time@units = "hours since "+thisDay(0)+"-"+thisDay(1)+"-"+thisDay(2)+" 00:00:00"
print("Time: hours since "+thisDay(0)+"-"+thisDay(1)+"-"+thisDay(2)+" 00:00:00")
time@calendar = "gregorian"
filedimdef(ncdf_out,"time",-1,True) ;Adds the time dimension
filevardef(ncdf_out, "time" ,typeof(time),"time") ; Time dimension
filevarattdef(ncdf_out,"time",time)                  ; copy Longitude attributes
ncdf_out->time = (/time/)

delete(grib_names)
grib_names = (/ "TMP_P0_L1_GLL0", "TMP_P0_L100_GLL0", "TMP_P0_L103_GLL0", \ ; Temperature
                "RH_P0_L100_GLL0", "RH_P0_L103_GLL0", \ ; Humidity
                "PWAT_P0_L200_GLL0", \ ; Precipitable water
                "VGRD_P0_L100_GLL0", "VGRD_P0_L103_GLL0", \ ; V wind
                "UGRD_P0_L100_GLL0", "UGRD_P0_L103_GLL0", \ ; U wind
                "ABSV_P0_L100_GLL0", \ ; Vorticity
                "PRES_P0_L1_GLL0", "PRMSL_P0_L101_GLL0",  \ ; Pressure
                "HGT_P0_L100_GLL0", \ ; Geopotencial height
                "HPBL_P0_L1_GLL0", \ ; Planetary height
                "SUNSD_P0_L1_GLL0", \ ; Sunshine duration
                "CAPE_P0_L1_GLL0", \ ; Potencial energy
                "LFTX_P0_L1_GLL0", \ ; Surface lifted index
                "TOZNE_P0_L200_GLL0", \ ; Total Ozone
                "ICEC_P0_L1_GLL0" \ ; Total ice cover
                 /) 
                ;"TCDC_P0_L244_GLL0", \ ; Total cloud cover

ncl_names=   (/ "temp_surf", "temp_isobar", "temp_abvgrd", \ ; Temperature
                "humidity_isobar", "humidity_twom", \ ; Humidity
                "prec_water", \  ; Precipitable water
                "u_isobar", "u_abvgrd", \ ; U wind
                "v_isobar", "v_abvgrd", \ ;V wind
                "abs_vort", \ ; Vorticity
                "pres_grd", "pres_msl",  \ ; Pressure
                "geo_height_isobar",  \ ; Geopotencial height
                "plan_height", \ ; Planetary height
                "sun_dur",  \ ; Sunshine duration
                "conv_en", \ ; Potencial energy
                "surf_idx", \ ; Surface lifted index
                "tot_ozone", \ ; Total Ozone
                "tot_ice_cov" \ ; Total ice cover
                 /) 
                ;"tot_cloud", \ ; Total cloud cover

ncl_longnames = (/ "Temp Surface", "Temperature Isobaric", "Temperature_Above Ground", \ ; Temperature
               "Humidity Isobaric", "Humidity at 2 mts",  \ ; Humidity
               "Prec_water", \ ; Precipitable water
               "wind_iso", "wind_abvgrd", \ ; U wind
               "wind_iso", "wind_abvgrd", \ ; V wind
               "Absolute Vorticity", \; Vorticity
               "Ground Pressure", "MSL Pressure", \ ; Pressure 
               "Geopotencial Height", \ ; Geopotencial Height
               "Planetary Height", \ ; Planetary height
               "Sunshine duration", \ ; Sunshine duration
               "Convective Potencial Energy", \ ; Potencial energy
               "Surface lifted index", \ ; Surface lifted index
               "Total ozone", \ ; Total Ozone
               "Total Ice Cover" \ ; Total ice cover
                /) 
               ;"Total Cloud Cover", \ ; Total cloud cover

; FOR SOME UNKNOWN REASON TO ME, THESE HAVE TO BE FLIPPED, IT DOESN'T
; MAKE ANY SENSE TO ME. I TRIED REPLACING JUST THE standard_name AND IT DIDN'T WORK
u_var = (/ False, False, False, \ ; Temperature
            False, False,  \ ; Humidity
            False, \ ; Precipitable water
            True, True, \; U wind
            False, False, \ ; V wind
            False, \ ; Vorticity
            False, False, \ ; Pressure 
            False, \ ; Geopotencial Height
            False,  \ ; Planetary height
            False, \ ; Sunshine duration
            False, \ ; Potencial energy
            False, \ ; Surface lifted index
            False, \ ; Total Ozone
            False \ ; Total ice cover
             /) 
            ;False, \ ; Total cloud cover

v_var = (/ False, False, False, \ ; Temperature
            False, False, \; Humidity
            False, \; Precipitable water
            False, False, \ ; U -wind
            True, True, \ ; V - wind
            False, \ ; Vorticity
            False, False, \ ; Pressure
            False, \ ; Geopotencial Height
            False, \ ; Sunshine duration
            False, \ ; Planetary height
            False, \ ; Potencial energy
            False, \ ; Surface lifted index
            False,\ ; Total Ozone
            False \ ; Total ice cover
             /)
            ;False,\ ; Total cloud cover

lat = grib_in->lat_0
lon = grib_in->lon_0

; Iterate over all the files and add each variable
do varIdx =0,dimsizes(grib_names)-1,1 ; This loop iterates over the variables

    grib_in = addfile(filesIn(0)+".grib2","r") ; Start only with the first file
    print("Adding variable: "+grib_names(varIdx))
    gVar = grib_in->$grib_names(varIdx)$
    allDim = dimsizes(gVar)
    totDim = dimsizes(allDim)
    ;print("Total number of dimensions:"+totDim)

    if(totDim .eq. 3) then
        ; In this case we create a 4D matrix
        print("Dimensions are: "+ totFiles+","+ allDim(0)+","+ allDim(1)+","+ allDim(2))
        myVar = new((/totFiles, allDim(0), allDim(1), allDim(2)/), "float", 0)
    else
        if(totDim .eq. 2) then
            ; In this case we create a 3D matrix
            print("Dimensions are: "+ totFiles+","+ allDim(0)+","+ allDim(1))
            myVar = new((/totFiles, allDim(0), allDim(1)/), "float", 0)
        end if
    end if

    ; Now we need to fill each dimension with the original data
    do fileNumber=0,totFiles-1,1
        grib_in = addfile(filesIn(fileNumber),"r") ; Start only with the first file

        ; Verify that the variable is in the file
        if (ismissing(grib_in) .eq. False ) then

            if(totDim .eq. 3) then
                myVar(fileNumber,:,:,:) = (/grib_in->$grib_names(varIdx)$/)
                ;myVar(fileNumber,:,:,:) = (/ createData(allDim(1),allDim(2),lat,lon,0,0),createData(allDim(1),allDim(2),lat,lon,1,0),createData(allDim(1),allDim(2),lat,lon,2,0)  /)
            else
                if(totDim .eq. 2) then
                    myVar(fileNumber,:,:) = (/grib_in->$grib_names(varIdx)$/)
                end if
            end if
        end if
    end do

    if(totDim .eq. 3) then
        filevardef(ncdf_out, ncl_names(varIdx) ,typeof(myVar), (/"time", gVar!0, gVar!1, gVar!2 /) ) ; time dimension
    else
        if(totDim .eq. 2) then
            ; In this case we create a 3D matrix
            filevardef(ncdf_out, ncl_names(varIdx) ,typeof(myVar), (/"time", gVar!0, gVar!1  /) ) ; time dimension
        end if
    end if

    copy_VarAtts(gVar,myVar) ; Copy origial attributes

    ; If the variable is part of a vector field, set the proper names
    if(u_var(varIdx)) then
        myVar@standard_name = "northward_"+ncl_longnames(varIdx)
    end if
    if(v_var(varIdx)) then
        myVar@standard_name = "eastward_"+ncl_longnames(varIdx)
    end if 
    myVar@long_name = ncl_longnames(varIdx)
    filevarattdef(ncdf_out,ncl_names(varIdx),myVar); copy T attributes
    ncdf_out->$ncl_names(varIdx)$ = (/myVar/)
    delete(myVar)
    delete(gVar)
    delete(allDim)
    delete(totDim)
end do

print("Deleting yesterday file")
system("rm -f " + ncdf_out_fname_current) ; remove any pre-existing output file 
system("mv "+ ncdf_out_fname_temp+" "+ncdf_out_fname_current) ; remove any pre-existing output file 
print("Total time to execute: "+ (get_cpu_time - begTime) +" sec")
