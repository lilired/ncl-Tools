# **Project: CENAPRED**

## ALERT

### Description of the 3 processes for generation of alerts.

         


### Percentile_Generation



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
 /ServerData/OWGIS/WRF/Percentil_Dom+ dominio(1 ó 2)+ _"año actual"-"mes actual"+"dia actual"+.nc
  
### STEP 3



