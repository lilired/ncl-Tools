import subprocess
import glob
import os
from datetime import datetime
from datetime import timedelta

__author__="Olmo S. Zavala Romero"

if __name__ == "__main__":
    now = datetime.today()

    # Previous day
    add = timedelta(days=1)
    # Download the one from the previous day
    newd = now - add
    newd_yest= newd - add

    fileExp = "hycom_glb_912_%s%s%s*.nc"%(newd.year,str(newd.month).zfill(2),str(newd.day).zfill(2))
    fileExpYesterday = "hycom_glb_912_%s%s%s*.nc"%(newd_yest.year,str(newd_yest.month).zfill(2),str(newd_yest.day).zfill(2))
    outputFolder = "/ServerData/OWGIS/GLOBAL_HYCOM/"


    tocall = "wget ftp://ftp.hycom.org/datasets/GLBu0.08/expt_91.2/data/forecasts/%s -P %s"%(fileExp,outputFolder)

    print("Removing yesterday files")
    for f in glob.glob(outputFolder+fileExpYesterday):
        print("Removing: ",f)
        os.remove(f)

    print("Wget to process",tocall)
    subprocess.Popen([tocall],shell=True)
