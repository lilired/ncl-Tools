#############################################
# Centro de Ciencias de la Atmosfera, UNAM
# AUTOR  : Raúl Medina Peña
# E-MAIL : raulmp@ciencias.unam.mx 
#############################################

El orden en que se ejecutaran los scripts es el siguiente:

1. run_hitograma_ncl_paralelo.sh : 
	Ejecuta el script histo_paralelo.ncl de forma paralela por medio de un ciclo "for".

	** histo_paralelo.ncl

		*** Ruta de archivos de entrada: "SERVIDOR_ROOT/KRAKEN/DATOS3/"
		
		*** Se crean las matrices donde se almacenaran los resultados. 
			Por ejemplo, T2_RES = new ((/Latitude, Longitude, Rango_Valores/), float)
		
		*** Se define el valor minimo y valor maximo para cada variable(T2, PREC2, VIENTO)
		
		*** Las entradas se van recorriendo por carpetas que contienen la información de cada año.
		
			****Se construye la ruta de la carpeta correspondiente al PROCESO en curso.
			    Se obtienen las variables del archivo de entrada.
			    Se itera sobre cada pixel del dominio, para calcular el valor del indice que le corresponde
			    a cada variable en su arreglo de rangos respectivo y se incrementa en una en esa poicion.
			    Por ejemplo, T2_RES(i, j, indice_Areglo_Rangos_T2) += 1
		
		*** Por útlimo se guarda la información en un archivo netCDF con la función 
			guardarHisto(T2_RES, PREC_RES, VIENTO_RES, myDay), donde myDay es el núemero de día del año 
			que se proceso.
		
		*** Ruta de salida: "/ROOT/out/out-Histogramas-Total/"	
------------------------------------------------------------------------------------------------

2. run_merge_histogramas.sh:
	Ejecuta el script merge_histo.ncl en un solo core.

	** merge_paralelo.ncl
		*** Ruta de archivos de entrada: "/ROOT/out/out-Histogramas-Total/tmp/"
	
		*** Se carga cada archivo del directorio y se obtienen las variables para despues sumarlas 
			y asi obtener el numero total de frecuencias de cada variable durante el periodo completo (1986-2016)
	
		*** Por útlimo se guarda la información en un archivo netCDF: "Histograma_Merge.nc"
	
		*** Ruta de salida : "/ROOT/out/out-Histogramas-Merge/"

------------------------------------------------------------------------------------------------

3. percentiles.ncl :
	
	Calcula los percentiles a partir de los histogramas de cada variable.
	
	** Ruta de archivos de entrada: "/ROOT/out/out-Histogramas-Merge/"
	
	** Archivo de entrada : "Histograma_Merge.nc"
	
	** Se itera por cda percentil que se quiere calcular (0.1, 1, 5, 10, 25, 50, 75, 90, 95, 99, 99.9)
	
		*** Para cada pixel del dominio del archivo de histogramas se itera sobre su arreglo de frecuencias, 
			para ir sumando sus valores hasta que rebasen el percentil respectivo. Entonces se puede 
			determinar el valor de la variable que esta por debajo de dicho percentil para cada punto 
			del dominio.
	
	** Ruta de archivos de salida: "/ROOT/out/percentiles/"
	
	** Archivo de salida : "Percentiles.nc"



