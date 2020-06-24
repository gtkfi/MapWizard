# Name: FuzzyOverlay_Ex_02.py
# Description: Combine fuzzy membership rasters data together based on 
#    selected overlay type ("GAMMA" in this case). 
# Requirements: Spatial Analyst Extension
# Author: ESRI

# Import system modules
import os
import sys
import arcpy
from arcpy import env
from arcpy.sa import *

print ("This is the name of the script: ", sys.argv[0])

out_folder_path = str(sys.argv[1]) 
out_name = "WofE.gdb"
#out_wrkspace = out_folder_path
out_wrkspace = out_folder_path+out_name 
# Execute CreateFileGDB
if arcpy.Exists(out_wrkspace):
    print ("ArcGis workspace exits, delete it...",out_wrkspace)
    arcpy.Delete_management(out_wrkspace)
#else:
arcpy.CreateFileGDB_management(out_folder_path, out_name)
#arcpy.env.mask = sys.argv[5] #"C:\\Users\\hissakai\\Documents\\ArcGIS\\Projects\\MyProject2\\MyProject2.gdb\\RasterT_img1"
arcpy.conversion.FeatureClassToFeatureClass(sys.argv[2], out_wrkspace, "mask")
