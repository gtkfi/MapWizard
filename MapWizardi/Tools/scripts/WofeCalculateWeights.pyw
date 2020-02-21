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

#Evidence raster layer
erl = sys.argv[2]
#output
out = sys.argv[3]
#training points
tp = sys.argv[6]
#Weights type
w_type = str(sys.argv[8])

# Set environment settings
#env.workspace = str(sys.argv[1])
#env.overwriteOutput = True
arcSdmPath = sys.argv[7]
ConfLevel = sys.argv[9]
UnitArea = sys.argv[10]
arcpy.ImportToolbox(arcSdmPath)
#arcpy.ImportToolbox(r"C:\\ArcSDM\\Toolbox\\ArcSDM.pyt")

#arcpy.env.workspace = "C:\\data\\testi.gdb"
#arcpy.env.scratchWorkspace = "C:\\data\\testi.gdb"

out_folder_path = str(sys.argv[1]) 
out_name = "WofE.gdb"
#out_wrkspace = out_folder_path
out_wrkspace = out_folder_path+out_name 
# Execute CreateFileGDB
if arcpy.Exists(out_wrkspace):
    print ("ArcGis workspace exits, ",out_wrkspace)
else:
    arcpy.CreateFileGDB_management(out_folder_path, out_name)

arcpy.env.workspace = out_wrkspace
arcpy.env.scratchWorkspace = out_wrkspace


#arcpy.env.workspace = str(sys.argv[1])
#arcpy.env.scratchWorkspace = str(sys.argv[1])

arcpy.env.spatialGrid1 = 0
arcpy.env.spatialGrid2 = 0
arcpy.env.spatialGrid3 = 0

arcpy.env.extent = "MAXOF"
#arcpy.env.outputZFlag = "Same As Input"
#arcpy.env.outputMFlag = "Same As Input"
#arcpy.env.tileSize = "128 128"
#arcpy.env.snapRaster = "C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Environment\\studyarea200_EUREF.img"
#arcpy.env.cellSize = sys.argv[4]
rasterpath = erl
raster= arcpy.Raster(rasterpath)
description = arcpy.Describe(raster)  
cellsize1 = description.children[0].meanCellHeight 
arcpy.env.cellSize = cellsize1

#arcpy.env.mask = sys.argv[5] #"C:\\Users\\hissakai\\Documents\\ArcGIS\\Projects\\MyProject2\\MyProject2.gdb\\RasterT_img1"
#maski = arcpy.conversion.FeatureClassToFeatureClass(sys.argv[5], out_wrkspace, "mask")
arcpy.env.mask = out_wrkspace +'\\mask'


#arcpy.ArcSDM.CalculateWeightsTool(evidence_raster_layer="C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Input\\Reclass_albitite.img", Evidence_Raster_Code_Field="", Training_points="C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Input\\FinGold.shp", Type="Descending", output_weights_table="C:\\data\\testi.gdb\\Reclass_albitite_U", Confidence_Level_of_Studentized_Contrast="2", Unit_Area__sq_km_="1", Missing_Data_Value="-99", success="true")
#arcpy.ArcSDM.CalculateWeightsTool(evidence_raster_layer=erl, Evidence_Raster_Code_Field="", Training_points=tp, Type="Descending", output_weights_table=str(sys.argv[1])+"\\"+out, Confidence_Level_of_Studentized_Contrast="2", Unit_Area__sq_km_="1", Missing_Data_Value="-99", success="true")
arcpy.ArcSDM.CalculateWeightsTool(evidence_raster_layer=erl, Evidence_Raster_Code_Field="", Training_points=tp, Type=w_type, output_weights_table=out_wrkspace+"\\"+out, Confidence_Level_of_Studentized_Contrast=ConfLevel, Unit_Area__sq_km_=UnitArea, Missing_Data_Value="-99", success="true")
#arcpy.ArcSDM.CalculateWeightsTool(evidence_raster_layer=erl, Evidence_Raster_Code_Field="", Training_points="C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Input\\FinGold.shp", Type="Descending", output_weights_table=out, Confidence_Level_of_Studentized_Contrast="2", Unit_A
#rea__sq_km_="1", Missing_Data_Value="-99", success="true")
#arcpy.ArcSDM.CalculateResponse(Input_evidence_raster_layers="C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Input\\Reclass_APV_Dst.img", input_weights_tables="C:\\data\\testi.gdb\\Reclass_albitite_U", training_sites="C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Input\\FinGold.shp", Ignore_missing_data="", Missing_Data_Value="-99", Unit_Area_sq_km="1", Output_Post_Probability_raster="C:\\data\\testi.gdb\\W_pprb", Output_Standard_Deviation_raster="C:\\data\\testi.gdb\\W_std", output_md_variance_raster="C:\\data\\testi.gdb\\W_MDvar", output_total_std_dev_raster="C:\\data\\testi.gdb\\W_Tstd", Output_Confidence_raster="C:\\data\\testi.gdb\\W_conf")
