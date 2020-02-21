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
env.workspace = str(sys.argv[1])
env.overwriteOutput = True

# Set local variables
inRasterList = str(sys.argv[2]).split(",")

#Output file name
outputFile = str(sys.argv[5])

# Check out the ArcGIS Spatial Analyst extension license
arcpy.CheckOutExtension("Spatial")

# Execute FuzzyMembership
type = str(sys.argv[4])
if type == 'GAMMA':
    gammaValue = sys.argv[6]
    outFzyOverlay = FuzzyOverlay(inRasterList, type, gammaValue)
else:
    outFzyOverlay = FuzzyOverlay(inRasterList, type)
#outFzyOverlay = FuzzyOverlay(inRasterList, "GAMMA", 0.9)

# Save the output
outFzyOverlay.save(str(sys.argv[3]) +outputFile+".img")
print ("This is the end of the script: ", sys.argv[0])
#raw_input()
#Reclassify
#Reclassify.main(env.workspace, outFzyOverlay, "Value", RemapRange([[0, 0.2, 1], [0.2, 0.6, 2],[0.6, 0.95, 3]]), "C:\Temp\MapWizard\PermissiveTract\Output\Reclassify")