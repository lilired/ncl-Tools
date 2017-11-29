#!/bin/bash

#############################################
# Centro de Ciencias de la Atmosfera
# Raúl Medina Peña
# raulmp@ciencias.unam.mx
# Script que ejecuta en paralelo los codigos 
# ncl que calculan los histogramas (T2,PREC,V)
#############################################

#!/bin/bash
#SBATCH -J Percentiles_NCL_OlmoZavala 
#SBATCH -p id
#SBATCH -N 1 # Numero de Nodos 
#SBATCH --ntasks-per-node 24 # Número de tareas por nodo
#SBATCH -t 0-2:00 # Tiempo (D­HH:MM) 
#SBATCH -o slurm.%x.%j.out # STDOUT Salida estandar (tag name,id)
#SBATCH -e slurm.%x.%j.err # STDERR Error estándar (tag name,id)

##DEBUG##
export NCARG_ROOT=/opt/librerias/pgi/ncl-6.4.0
export PATH=/opt/librerias/pgi/ncl-6.4.0/bin:$PATH

N=23
for i in $(seq 0 $N);do
	time srun -n1 --exclusive ncl md=$i N=$N histo_paralelo.ncl &
done

wait
