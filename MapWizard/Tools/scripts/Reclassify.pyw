# Name: reclassify_example02.py
# Description: Reclassifies the values in a raster.
# Requirements: Spatial Analyst Extension

# Import system modules
import arcpy
from arcpy import env
from arcpy.sa import *

def main (wspace, inraster, reclassField, remap, savelocation):
  # Set environment settings
  env.workspace = str(wspace)
  # Execute Reclassify
  outReclassify = Reclassify(inraster, reclassField, remap, "NODATA")

  # Save the output 
  outReclassify.save(str(savelocation + "\outreclass02"))