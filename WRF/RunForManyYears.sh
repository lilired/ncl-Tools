#!/bin/bash

# Input and output folders
in=\"/DATA/WRF/\"
out=\"/DATA/OUT/WRF/\"

# Set initial day
currD=2016-04-20
# Set final day
#finalD=2017-06-20
finalD=2017-06-22

while [ "$currD" != $finalD ]; do
    anio=$(date -d "$currD" +%Y)
    mes=$(date -d "$currD" +%m)
    dia=$(date -d "$currD" +%d)
    echo "============ WORKING WITH DAY: ======= " $anio $mes $dia

    # Go to the next day
    currD=$(date -I -d "$currD + 1 day")
    ncl dia=$dia mes=$mes anio=$anio "in=${in}" "out=${out}" WRF_for_OWGIS_LOCAL.ncl
done

