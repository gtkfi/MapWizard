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

# Set environment settings
#env.workspace = "C:/Users/mtoppine/Documents/MAP/Fuzzy/input"
env.workspace = str(sys.argv[1])

# Set local variables
#inRasterList = ["APV_DstWrms_mask_MemSh.img", "albiteOcc_mask_MemSh.img", "AEM_Im_winsor_mask_MemSh.img"]
#inRasterList = ["APV_DstWrms_mask_MemSh.img", "albiteOcc_mask_MemSh.img", "AEM_Im_winsor_mask_MemSh.img"]
inRasterList = str(sys.argv[2]).split(",")

# Check out the ArcGIS Spatial Analyst extension license
arcpy.CheckOutExtension("Spatial")

# Execute FuzzyMembership
outFzyOverlay = FuzzyOverlay(inRasterList, "GAMMA", 0.9)

# Save the output
outFzyOverlay.save(str(sys.argv[3]))

raw_input()