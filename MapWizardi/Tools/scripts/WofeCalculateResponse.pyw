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

#print ("This is the name of the script: ", sys.argv[0])
#print ("Evidence rasters: ", sys.argv[1])

ws = str(sys.argv[1])+"WofE.gdb" #workspace
erl = sys.argv[2]                #evidence raster layers
wt = sys.argv[3]                 #input weight tables
#training points
tp = sys.argv[6]                #training sites
# Set environment settings
arcpy.env.workspace = ws
arcpy.env.scratchWorkspace = ws
#env.overwriteOutput = True
arcSdmPath = sys.argv[8]
arcpy.ImportToolbox(arcSdmPath)

UnitArea = sys.argv[9]
#arcpy.ImportToolbox(r"C:\\ArcSDM\\Toolbox\\ArcSDM.pyt")

#arcpy.env.workspace = "C:\\data\\testi.gdb"
#arcpy.env.scratchWorkspace = "C:\\data\\testi.gdb"

arcpy.env.spatialGrid1 = 0
arcpy.env.spatialGrid2 = 0
arcpy.env.spatialGrid3 = 0

arcpy.env.extent = "MAXOF"
#arcpy.env.outputZFlag = "Same As Input"
#arcpy.env.outputMFlag = "Same As Input"
#arcpy.env.tileSize = "128 128"
#arcpy.env.snapRaster = "C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Environment\\studyarea200_EUREF.img"
#arcpy.env.cellSize = sys.argv[4]
rasterpath = erl.split(';')[0]
raster= arcpy.Raster(rasterpath)
description = arcpy.Describe(raster)  
cellsize1 = description.children[0].meanCellHeight 
arcpy.env.cellSize = cellsize1

arcpy.env.mask = ws +'\\mask'
outputFolder = sys.argv[7] 

#"C:\\Users\\hissakai\\Documents\\ArcGIS\\Projects\\MyProject2\\MyProject2.gdb\\RasterT_img1"

#arcpy.ArcSDM.CalculateWeightsTool(evidence_raster_layer="C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Input\\Reclass_albitite.img", Evidence_Raster_Code_Field="", Training_points="C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Input\\FinGold.shp", Type="Descending", output_weights_table="C:\\data\\testi.gdb\\Reclass_albitite_U", Confidence_Level_of_Studentized_Contrast="2", Unit_Area__sq_km_="1", Missing_Data_Value="-99", success="true")
#arcpy.ArcSDM.CalculateResponse(Input_evidence_raster_layers="C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Input\\Reclass_APV_Dst.img", input_weights_tables="C:\\data\\testi.gdb\\Reclass_albitite_U", training_sites="C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Input\\FinGold.shp", Ignore_missing_data="", Missing_Data_Value="-99", Unit_Area_sq_km="1", Output_Post_Probability_raster="C:\\data\\testi.gdb\\W_pprb", Output_Standard_Deviation_raster="C:\\data\\testi.gdb\\W_std", output_md_variance_raster="C:\\data\\testi.gdb\\W_MDvar", output_total_std_dev_raster="C:\\data\\testi.gdb\\W_Tstd", Output_Confidence_raster="C:\\data\\testi.gdb\\W_conf")
#arcpy.ArcSDM.CalculateResponse(Input_evidence_raster_layers=erl, input_weights_tables=wt, training_sites=tp, Ignore_missing_data="", Missing_Data_Value="-99", Unit_Area_sq_km="1", Output_Post_Probability_raster=ws+"\\"+wt+"_W_pprb", Output_Standard_Deviation_raster=ws+"\\"+wt+"_W_std", output_md_variance_raster=ws+"\\"+wt+"_W_MDvar", output_total_std_dev_raster=ws+"\\"+wt+"_W_Tstd", Output_Confidence_raster=ws+"\\"+wt+"_W_conf")
#arcpy.ArcSDM.CalculateResponse(Input_evidence_raster_layers=erl, input_weights_tables=wt, training_sites=tp, Ignore_missing_data="", Missing_Data_Value="-99", Unit_Area_sq_km="1", Output_Post_Probability_raster=outputFolder+"prospraster.img", Output_Standard_Deviation_raster=outputFolder+"standard_deviation_raster.img", output_md_variance_raster=outputFolder+"md_variance_raster.img", output_total_std_dev_raster=outputFolder+"total_std_dev_raster.img", Output_Confidence_raster=outputFolder+"confidence_raster.img")
#arcpy.ArcSDM.CalculateResponse(Input_evidence_raster_layers=erl, input_weights_tables=wt, training_sites=tp, Ignore_missing_data="", Missing_Data_Value="-99", Unit_Area_sq_km="1", Output_Post_Probability_raster=outputFolder+"W_pprb.img", Output_Standard_Deviation_raster=outputFolder+"W_std.img", output_md_variance_raster=outputFolder+"W_MDvar.img", output_total_std_dev_raster=outputFolder+"W_Tstd.img", Output_Confidence_raster=outputFolder+"W_conf.img")
arcpy.ArcSDM.CalculateResponse(Input_evidence_raster_layers=erl, input_weights_tables=wt, training_sites=tp, Ignore_missing_data="", Missing_Data_Value="-99", Unit_Area_sq_km=UnitArea, Output_Post_Probability_raster=outputFolder+"W_pprb.img", Output_Standard_Deviation_raster=outputFolder+"W_std.img",Output_Confidence_raster=outputFolder+"W_conf.img")
#arcpy.ArcSDM.CalculateResponse(Input_evidence_raster_layers=erl, input_weights_tables=wt, training_sites=tp, Ignore_missing_data="", Missing_Data_Value="-99", Unit_Area_sq_km="1", Output_Post_Probability_raster=outputFolder+"prospraster.img", Output_Standard_Deviation_raster=outputFolder+"standard_deviation_raster.img")

#arcpy.ArcSDM.CalculateResponse(Input_evidence_raster_layers=erl, input_weights_tables=wt, training_sites="C:\\TFS2\\Muut\\MapWizardi\\ToolsTests\\testdata\\MAP\\WofE\\Input\\FinGold.shp", Ignore_missing_data="", Missing_Data_Value="-99", Unit_Area_sq_km="1", Output_Post_Probability_raster=ws+"\\W_pprb", Output_Standard_Deviation_raster=ws+"\\W_std", output_md_variance_raster=ws+"\\MDvar", output_total_std_dev_raster=ws+"\\W_Tstd", Output_Confidence_raster=ws+"\\W_conf")
#print ("End of the CalculateResponse: ", sys.argv[0])