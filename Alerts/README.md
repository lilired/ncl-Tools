# **Project: CENAPRED**

## ALERT

### Description of the 3 processes for generation of alerts.

         


### Percentile_Generation
	Los percentiles para la temperatura a 2m(T2), la precipitación (PREC2) y las componentes del viento a una altura de 10m (U10, V10),
	considerando sus valores históricos del reanálisis en el período 1980-2016, se realizó de la siguiente manera:

		1. Se crean arreglos que contienen los rangos de los valores para cada variable.
		   T2        : se crea un arreglo con valores desde -20 a 50 con un incremento de 1 grado °C.
		   PREC2     : se crea un arreglo con valores desde 0 a 400 con un incremento de 1 mm.
		   U10 - V10 : se crea un arreglo con valores desde 0 a 100 con un incremento de 1 m/s

		2. Después de definir los arreglos de los rangos se genera un histograma para cada variable,
		   el cual representa la distribución de frecuencias de los valores correspondientes al todo
		   el período del reanálisis (1980-2016). Ese calculo se hace en forma paralela en un cluster.

		3. Por último calculamos los percentiles 0.1, 1, 5, 10, 25, 50, 75, 90, 95, 99, 99.9 a partir 
		   de los histogramas generados anteriormente.
    

### resolution_percentiles_to_WRF
****The data of the outputs ir used: 

     in_otro=\"/ServerData/OWGIS/percentiles\"

     in=\"/ServerData/Pronosticos/Salidas/WRF/\"

     out=\"/ServerData/OWGIS/WRF/\"

     Starting from the percentiles file ( "/ServerData/OWGIS/percentiles/Percentiles_99.9.nc"), 
     you have to adapt it to the resolution you have for domain 1 and domain 2 of the WRF, 
     to adapt them we also need the domain 1 file(/ServerData/OWGIS/WRF/Dom1_"año actual"-"mes actual"-"dia actual".nc")
 and domain 2 file(/ServerData/Pronosticos/Salidas/WRF/\)

The file is generated	
 /ServerData/OWGIS/WRF/Percentil_Dom+ domains(1 ó 2)+ _"año actual"-"mes actual"+"dia actual"+.nc
  
### generation_maps_alert



