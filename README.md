# **Project: CENAPRED**

## NCL

### Description of netCDF from WRF, HYCOM and WW3

       WRF
         ->The files are separated by folders in anio(2017), mes(07_julio) and we have them in 2 domains 
           for file(wrfout_d01_2017-07_17.nc,wrfout_d02_2017-07_17.nc ) 

          ->Domains 1 coordinates: time(121),latitude(208),longitude(325),depth(49),u_latitud(208),
            u_longitude(326),u_depth(50),v_latitud(209),v_longitude(225)
          
          ->Domains 2 coordinates: time(121),latitude(159),longitude(279),depth(49),u_latitud(159),
            u_longitude(280),u_depth(50),v_latitud(160),v_longitude(279)  
         
         HYCOM
         ->The files are separated by folders in 20170522 (anio(2017)+mes(05)+dia(22)) and 
            we have them in 2 folders 2d and 3z
          
          ->2d coordinates: time(1), latitude(385), longitude(541)
          
          ->3z coordinates: time(1), latitude(385), longitude(541),depth(30)
          
         
        WW3 
         ->The files are separated by folders in anio(2017), mes(07_julio) , we have them in 3 domains 
           (golfo de mexico(gom), atlantico() y pacifico()) and by domain you have a file of 24 hours you 
           have 5 days
         
          ->gom coordinates: time(24), latitude(93), longitude(73)  
         
          ->atlantico coordinates: time(24), latitude(), longitude()
         
          ->pacifico coordinates: time(24), latitude(), longitude()
         


### Run model WRF

./Run_WRF_to_OWGIS (file compile in bash)

 -> file WRF_for_OWGIS_LOCAL.ncl (script pricipal)
 
    -> file configuration.txt (script configuration requires to read file README(Variables that require others))
     
      ->files the procedures


### Run model hycom

 ./Run_HYCOM_to_OWGIS (file compile in bash)
  
  -> file HYCOM_for_OWGIS_LOCAL.ncl (script pricipal)
  
     -> file configuration.txt (script configuration requires to read file README(Variables that require others))
     
        ->files the procedures
	
	
### It will be done a version in ncl for the variables:


Air temperature at 2 mts (T2)

Precipitation (PREC2)

Wind at multiple levels

Relative humidity

Sensible heat flux

Latent heat flux

Shortwave radiation

Longwave radiation

Total radiation

Boundary layer height

Cloud coverage

Evaporation

Identify variables in the original WRF:

**-variable: Air Temperature al 2 mts**

float T2(Time, south_north, west_east) ;
		T2:FieldType = 104 ;
		T2:MemoryOrder = "XY " ;
		T2:description = "TEMP at 2 M" ;
		T2:units = "K" ;
		T2:stagger = "" ;
		T2:coordinates = "XLONG XLAT XTIME" ;


**-variable: Precipitation** 

float RAINC(Time, south_north, west_east) ;
		RAINC:FieldType = 104 ;
		RAINC:MemoryOrder = "XY " ;
		RAINC:description = "ACCUMULATED TOTAL CUMULUS PRECIPITATION" ;
		RAINC:units = "mm" ;
		RAINC:stagger = "" ;
		RAINC:coordinates = "XLONG XLAT XTIME" ;

**-variable: Wind at multiple levels**

float U10(Time, south_north, west_east) ;
		U10:FieldType = 104 ;
		U10:MemoryOrder = "XY " ;
		U10:description = "U at 10 M" ;
		U10:units = "m s-1" ;
		U10:stagger = "" ;
		U10:coordinates = "XLONG XLAT XTIME" ;

float V10(Time, south_north, west_east) ;
		V10:FieldType = 104 ;
		V10:MemoryOrder = "XY " ;
		V10:description = "V at 10 M" ;
		V10:units = "m s-1" ;
		V10:stagger = "" ;
		V10:coordinates = "XLONG XLAT XTIME" ;

float U(Time, bottom_top, south_north, west_east_stag) ;
		U:FieldType = 104 ;
		U:MemoryOrder = "XYZ" ;
		U:description = "x-wind component" ;
		U:units = "m s-1" ;
		U:stagger = "X" ;
		U:coordinates = "XLONG_U XLAT_U XTIME" ;

float V(Time, bottom_top, south_north_stag, west_east) ;
		V:FieldType = 104 ;
		V:MemoryOrder = "XYZ" ;
		V:description = "y-wind component" ;
		V:units = "m s-1" ;
		V:stagger = "Y" ;
		V:coordinates = "XLONG_V XLAT_V XTIME" ;

float W(Time, bottom_top_stag, south_north, west_east) ;
		W:FieldType = 104 ;
		W:MemoryOrder = "XYZ" ;
		W:description = "z-wind component" ;
		W:units = "m s-1" ;
		W:stagger = "Z" ;
		W:coordinates = "XLONG XLAT XTIME" ;


**-variable: relative humidity(rh)**

float QVAPOR(Time, bottom_top, south_north, west_east) ;
		QVAPOR:FieldType = 104 ;
		QVAPOR:MemoryOrder = "XYZ" ;
		QVAPOR:description = "Water vapor mixing ratio" ;
		QVAPOR:units = "kg kg-1" ;
		QVAPOR:stagger = "" ;
		QVAPOR:coordinates = "XLONG XLAT XTIME" ;


**-variable: sensible heat flux** 
	float HFX_FORCE(Time) ;
		HFX_FORCE:FieldType = 104 ;
		HFX_FORCE:MemoryOrder = "0  " ;
		HFX_FORCE:description = "SCM ideal surface sensible heat flux" ;
		HFX_FORCE:units = "W m-2" ;
		HFX_FORCE:stagger = "" ;


**-variable: sensible heat flux** 
	float LH_FORCE(Time) ;
		LH_FORCE:FieldType = 104 ;
		LH_FORCE:MemoryOrder = "0  " ;
		LH_FORCE:description = "SCM ideal surface latent heat flux" ;
		LH_FORCE:units = "W m-2" ;
		LH_FORCE:stagger = "" ;


**-variable: cloud coverage**

float QCLOUD(Time, bottom_top, south_north, west_east) ;
		QCLOUD:FieldType = 104 ;
		QCLOUD:MemoryOrder = "XYZ" ;
		QCLOUD:description = "Cloud water mixing ratio" ;
		QCLOUD:units = "kg kg-1" ;
		QCLOUD:stagger = "" ;
		QCLOUD:coordinates = "XLONG XLAT XTIME" ;


**-variable: boundary layer height**

float PBLH(Time, south_north, west_east) ;
		PBLH:FieldType = 104 ;
		PBLH:MemoryOrder = "XY " ;
		PBLH:description = "PBL HEIGHT" ;
		PBLH:units = "m" ;
		PBLH:stagger = "" ;
		PBLH:coordinates = "XLONG XLAT XTIME" ;


**-variable:Short wave radiation**

float SWDOWN(Time, south_north, west_east) ;
		SWDOWN:FieldType = 104 ;
		SWDOWN:MemoryOrder = "XY " ;
		SWDOWN:description = "DOWNWARD SHORT WAVE FLUX AT GROUND SURFACE" ;
		SWDOWN:units = "W m-2" ;
		SWDOWN:stagger = "" ;
		SWDOWN:coordinates = "XLONG XLAT XTIME" ;

float SWNORM(Time, south_north, west_east) ;
		SWNORM:FieldType = 104 ;
		SWNORM:MemoryOrder = "XY " ;
		SWNORM:description = "NORMAL SHORT WAVE FLUX AT GROUND SURFACE (SLOPE-DEPENDENT)" ;
		SWNORM:units = "W m-2" ;
		SWNORM:stagger = "" ;
		SWNORM:coordinates = "XLONG XLAT XTIME" ;


**-variable:Long wave radiation**

float GLW(Time, south_north, west_east) ;
		GLW:FieldType = 104 ;
		GLW:MemoryOrder = "XY " ;
		GLW:description = "DOWNWARD LONG WAVE FLUX AT GROUND SURFACE" ;
		GLW:units = "W m-2" ;
		GLW:stagger = "" ;
		GLW:coordinates = "XLONG XLAT XTIME" ;

float OLR(Time, south_north, west_east) ;
		OLR:FieldType = 104 ;
		OLR:MemoryOrder = "XY " ;
		OLR:description = "TOA OUTGOING LONG WAVE" ;
		OLR:units = "W m-2" ;
		OLR:stagger = "" ;
		OLR:coordinates = "XLONG XLAT XTIME" ;


**-variable: total radiation**

**-variable: evaporation**

