#!/bin/bash

echo "Downloading new forecast..."
`/usr/bin/python /ServerScripts/Global_HYCOM_to_OWGIS/hycomDownload.py`

DATE=`date --date="1 day ago" +%Y%m%d`
COMMAND="ls -d -1 /ServerData/OWGIS/GLOBAL_HYCOM/* | grep -v '$DATE' | xargs rm -f"
echo "Removing files with: $COMMAND"
eval $COMMAND
