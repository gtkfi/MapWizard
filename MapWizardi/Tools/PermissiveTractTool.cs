using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Windows;
using NLog;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace MapWizard.Tools
{

    /// <summary>
    /// Permissive Tract input parameters.
    /// </summary>
    public class PermissiveTractInputParams : ToolParameters
    {
        /// <summary>
        /// Python path.
        /// </summary>
        public string PythonPath
        {
            get { return GetValue<string>("PythonPath"); }
            set { Add<string>("PythonPath", value); }
        }
        /// <summary>
        /// Script path.
        /// </summary>
        public string ScriptPath
        {
            get { return GetValue<string>("ScriptPath"); }
            set { Add<string>("ScriptPath", value); }
        }
        /// <summary>
        /// Environment path.
        /// </summary>
        public string EnvPath
        {
            get { return GetValue<string>("EnvPath"); }
            set { Add<string>("EnvPath", value); }
        }
        /// <summary>
        /// Evidence layer rasters to be combined in one or more rounds using fuzzy logic operators. 
        /// </summary>
        public List<string> InRasterList
        {
            get { return GetValue<List<string>>("InRasterList"); }
            set { Add<List<string>>("InRasterList", value); }
        }
        /// <summary>
        /// Out raster.
        /// </summary>
        public string OutRaster
        {
            get { return GetValue<string>("OutRaster"); }
            set { Add<string>("OutRaster", value); }
        }

        /// <summary>
        /// Method fuzzy/wofe
        /// </summary>
        public string MethodId
        {
            get { return GetValue<string>("MethodId"); }
            set { Add<string>("MethodId", value); }
        }

        /// <summary>
        /// Evidence raster layers
        /// </summary>
        public List<string> EvidenceRasterList
        {
            get { return GetValue<List<string>>("EvidenceRasterList"); }
            set { Add<List<string>>("EvidenceRasterList", value); }
        }

        /// <summary>
        /// Unit Area
        /// </summary>
        public string UnitArea
        {
            get { return GetValue<string>("UnitArea"); }
            set { Add<string>("UnitArea", value); }
        }

        /// <summary>
        /// Mask raster
        /// </summary>
        public string MaskRaster
        {
            get { return GetValue<string>("MaskRaster"); }
            set { Add<string>("MaskRaster", value); }
        }

        /// <summary>
        /// ArcGis Work space
        /// </summary>
        public string WorkSpace
        {
            get { return GetValue<string>("WorkSpace"); }
            set { Add<string>("WorkSpace", value); }
        }

        /// <summary>
        /// Fuzzy overlay type
        /// </summary>
        public string FuzzyOverlayType
        {
            get { return GetValue<string>("FuzzyOverlayType"); }
            set { Add<string>("FuzzyOverlayType", value); }
        }

        /// <summary>
        /// WofE weights type: Descending, Ascending, Categorial, Unique
        /// </summary>
        public string WofEWeightsType
        {
            get { return GetValue<string>("WofEWeightsType"); }
            set { Add<string>("WofEWeightsType", value); }
        }

        /// <summary>
        /// Fuzzy calculate output filename
        /// </summary>
        public string FuzzyOutputFileName
        {
            get { return GetValue<string>("FuzzyOutputFileName"); }
            set { Add<string>("FuzzyOutputFileName", value); }
        }

        /// <summary>
        /// Value of the gamma operator, if Gamma is selected as the operator. 
        /// </summary>
        public string FuzzyGammaValue
        {
            get { return GetValue<string>("FuzzyGammaValue"); }
            set { Add<string>("FuzzyGammaValue", value); }
        }

        /// <summary>
        /// Indicates the last round of combining evidence layer rasters. This produces the final prospectivity raster.
        /// </summary>
        public string LastFuzzyRound
        {
            get { return GetValue<string>("LastFuzzyRound"); }
            set { Add<string>("LastFuzzyRound", value); }
        }

        /// <summary>
        /// Prospectivity raster filename
        /// </summary>
        public string ProspectivityRasterFile
        {
            get { return GetValue<string>("ProspectivityRasterFile"); }
            set { Add<string>("ProspectivityRasterFile", value); }
        }

        /// <summary>
        /// Prospective raster boundary values, separated with comma
        /// </summary>
        public string BoundaryValues
        {
            get { return GetValue<string>("BoundaryValues"); }
            set { Add<string>("BoundaryValues", value); }
        }

        /// <summary>
        /// EvidenceLayer file used in Delineation process
        /// </summary>
        public string EvidenceLayerFile
        {
            get { return GetValue<string>("EvidenceLayerFile"); }
            set { Add<string>("EvidenceLayerFile", value); }
        }

        /// <summary>
        /// DelID will be used as an identifier in file and folder names 
        /// </summary>
        public string DelID
        {
            get { return GetValue<string>("DelID"); }
            set { Add<string>("DelID", value); }
        }

        /// <summary>
        /// MinArea will be used to minimize polygon areas
        /// </summary>
        public string MinArea
        {
            get { return GetValue<string>("MinArea"); }
            set { Add<string>("MinArea", value); }
        }

        /// <summary>
        /// TractPolygonFile to be minimized
        /// </summary>
        public string TractPolygonFile
        {
            get { return GetValue<string>("TractPolygonFile"); }
            set { Add<string>("TractPolygonFile", value); }
        }

        /// <summary>
        /// Delineation raster file to be classified
        /// </summary>
        public string DelineationRaster
        {
            get { return GetValue<string>("DelineationRaster"); }
            set { Add<string>("DelineationRaster", value); }
        }

        /// <summary>
        /// Number of prospectivity classes for classification process
        /// </summary>
        public string NumberOfProspectivityClasses
        {
            get { return GetValue<string>("NumberOfProspectivityClasses"); }
            set { Add<string>("NumberOfProspectivityClasses", value); }
        }

        /// <summary>
        /// Raster min/max values for classification process
        /// </summary>
        public string MinMaxValues
        {
            get { return GetValue<string>("MinMaxValues"); }
            set { Add<string>("MinMaxValues", value); }
        }

        /// <summary>
        /// Treshold values for classification process
        /// </summary>
        public string TresholdValues
        {
            get { return GetValue<string>("TresholdValues"); }
            set { Add<string>("TresholdValues", value); }
        }

        /// <summary>
        /// Classification Id for classification process
        /// </summary>
        public string ClassificationId
        {
            get { return GetValue<string>("ClassificationId"); }
            set { Add<string>("ClassificationId", value); }
        }

        /// <summary>
        /// Training point for Wofe process
        /// </summary>
        public string TrainingPoints
        {
            get { return GetValue<string>("TrainingPoints"); }
            set { Add<string>("TrainingPoints", value); }
        }

        /// <summary>
        /// ArcSdm python file for Wofe process
        /// </summary>
        public string ArcSdm
        {
            get { return GetValue<string>("ArcSdm"); }
            set { Add<string>("ArcSdm", value); }
        }

        /// <summary>
        /// Confidence level for Wofe process
        /// </summary>
        public string ConfidenceLevel
        {
            get { return GetValue<string>("ConfidenceLevel"); }
            set { Add<string>("ConfidenceLevel", value); }
        }

        /// <summary>
        /// Raster split value for fuzzy process
        /// </summary>
        public string FuzzySplitValue
        {
            get { return GetValue<string>("FuzzySplitValue"); }
            set { Add<string>("FuzzySplitValue", value); }
        }


    }

    /// <summary>
    /// Results from executing Permissive Tract tools.
    /// </summary>
    public class PermissiveTractResult : ToolResult
    {
        /// <summary>
        /// Results.
        /// </summary>
        public string PermissiveTractResults
        {
            get { return GetValue<string>("PermissiveTractResults"); }
            internal set { Add<string>("PermissiveTractResults", value); }
        }
        /// <summary>
        /// 
        /// </summary>
        public string CalculateWeightsResult
        {
            get { return GetValue<string>("CalculateWeightsResult"); }
            internal set { Add<string>("CalculateWeightsResult", value); }
        }
        /// <summary>
        /// 
        /// </summary>
        public string CalculateResponsesResult
        {
            get { return GetValue<string>("CalculateResponsesResult"); }
            internal set { Add<string>("CalculateResponsesResult", value); }
        }

        /// <summary>
        /// 
        /// </summary>
        public string MinMaxValues
        {
            get { return GetValue<string>("MinMaxValues"); }
            internal set { Add<string>("MinMaxValues", value); }
        }

        /// <summary>
        /// 
        /// </summary>
        public string TresholdValues
        {
            get { return GetValue<string>("TresholdValues"); }
            internal set { Add<string>("TresholdValues", value); }
        }

    }

    /// <summary>
    /// Runs Permissive Tract tools.
    /// </summary>
    public class PermissiveTractTool : ITool
    {
        string projectFolder;
        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();

        /// <summary>
        /// Permissive Tract tool execution
        /// </summary>
        /// <param name="inputParams">Input parameters as ToolParameters</param>
        /// <returns>ToolResult as PermissiveTractResult</returns>
        public ToolResult Execute(ToolParameters inputParams)
        {
            projectFolder = Path.Combine(inputParams.Env.RootPath, "TractDelineation");
            if (!Directory.Exists(projectFolder))
            {
                Directory.CreateDirectory(projectFolder);
            }

            var input = inputParams as PermissiveTractInputParams;
            input.Save(projectFolder + @"\permissive_tract_input_params.json");
            PermissiveTractResult result = new PermissiveTractResult();

            if (input.MethodId == "fuzzy" || input.MethodId == "fuzzyClassification")
            {
                result = FuzzyOverlay(input, result);
            }
            else if (input.MethodId == "delineation")
            {
                result = Delineation(input, result);
            }
            else if (input.MethodId == "delineation_polygon")
            {
                result = DelineationPolygon(input, result);
            }
            else if (input.MethodId == "wofe" || input.MethodId == "wofeClassification")
            {
                result = WofE(input, result);
            }
            else if (input.MethodId == "generatetracts")
            {
                result = GenerateTracts(input, result);
            }
            else if (input.MethodId == "calculatetreshold")
            {
                result = CalculateTreshold(input, result);
            }
            else if (input.MethodId == "classification")
            {
                result = Classificate(input, result);
            }
            return result;
        }

        /// <summary>
        /// Runs Generate tracts process with given parameters. Minimizes polygons from input raster and produces summary statistics
        /// </summary>
        /// <param name="input">Input parameters.</param>
        /// <returns>Result of executing GenerateTracts.</returns>
        private PermissiveTractResult GenerateTracts(PermissiveTractInputParams input, PermissiveTractResult result)
        {
            if (input.ProspectivityRasterFile == "" || input.BoundaryValues == "")
            {
                throw new ArgumentException("Input parameters not set correctly", "ProspectivityRasterFile/BoundaryValues");
            }
            else
            {
                string rScriptExecutablePath = input.Env.RPath;
                string procResult = string.Empty;

                var info = new ProcessStartInfo();
                info.FileName = rScriptExecutablePath;
                var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                info.WorkingDirectory = path + "scripts/";
                var rCodeFilePath = path + "scripts/rasterproc_generatetracts_wrapper.r";

                string outputFolder = projectFolder + @"\Delineation\temp\" + input.DelID;
                if (!Directory.Exists(outputFolder))
                {
                    Directory.CreateDirectory(outputFolder);
                }

                string inputPolygon = input.TractPolygonFile;
                string minArea = input.MinArea;
                double area = Convert.ToDouble(minArea);
                area = area * 1000000; //km2 -> m2
                minArea = Convert.ToString(area);
                string cleanPolyShp = outputFolder + "\\DelineationPolygons_" + input.DelID + "_" + input.MinArea + "km2.shp";
                string cleanPolyShpF = "DelineationPolygons_" + input.DelID + "_" + input.MinArea + "km2";
                string outCleanStatTxt = outputFolder + "\\DelineationSummary" + input.DelID + ".txt";
                string outCleanDistPdf = outputFolder + "\\TractAreaCdf" + input.DelID + ".pdf";

                info.Arguments = "\"" + rCodeFilePath + "\" \"" + inputPolygon + "\" \"" + minArea + "\" \"" + cleanPolyShp + "\" \"" + cleanPolyShpF
                    + "\" \"" + outCleanStatTxt + "\" \"" + outCleanDistPdf;
                info.RedirectStandardInput = false;
                info.RedirectStandardOutput = true;
                info.RedirectStandardError = true;
                info.UseShellExecute = false;
                info.CreateNoWindow = true;

                using (var proc = new Process())
                {
                    proc.StartInfo = info;
                    proc.Start();
                    StreamReader errorReader = proc.StandardError;
                    StreamReader myStreamReader = proc.StandardOutput;
                    string errors = errorReader.ReadToEnd();
                    logger.Trace(errors);
                    string stream = myStreamReader.ReadToEnd();
                    procResult = proc.StandardOutput.ReadToEnd();
                    proc.Close();

                }
                //}

            }

            return result;
        }


        /// <summary>
        /// Runs Delineation process with given parameters.
        /// </summary>
        /// <param name="input">Input parameters.</param>
        /// <returns>Result of executing CalculateTreshold.</returns>
        private PermissiveTractResult CalculateTreshold(PermissiveTractInputParams input, PermissiveTractResult result)
        {
            if (input.DelineationRaster == "" || input.NumberOfProspectivityClasses == "")
            {
                throw new ArgumentException("Input parameters not set correctly", "DelineationRaster/NumberOfProspectivityClasses");
            }
            else
            {
                //mask raster with polygon before calculate treshold
                maskRasterWPolygon(input, result);

                string rScriptExecutablePath = input.Env.RPath;
                string procResult = string.Empty;


                var info = new ProcessStartInfo();
                info.FileName = rScriptExecutablePath;
                var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                info.WorkingDirectory = path + "scripts/";
                var rCodeFilePath = path + "scripts/rasterproc_stats_wrapper.r";
                string outCsv = projectFolder + "\\stats.csv";

                string outputFolder = projectFolder + "\\Temp\\";
                if (!Directory.Exists(outputFolder))
                {
                    Directory.CreateDirectory(outputFolder);
                }

                //string delineationRaster = projectFolder + "\\Classification\\Temp\\" + "maskedRaster" + input.DelID + ".img";
                string delineationRaster = projectFolder + "\\Classification\\Temp\\" + "maskedRaster.img";
                if (!File.Exists(delineationRaster))
                {
                    delineationRaster = input.DelineationRaster;
                }



                info.Arguments = "\"" + rCodeFilePath + "\" \"" + delineationRaster + "\" \"" + outCsv;
                info.RedirectStandardInput = false;
                info.RedirectStandardOutput = true;
                info.RedirectStandardError = true;
                info.UseShellExecute = false;
                info.CreateNoWindow = true;

                using (var proc = new Process())
                {
                    proc.StartInfo = info;
                    proc.Start();
                    StreamReader errorReader = proc.StandardError;
                    StreamReader myStreamReader = proc.StandardOutput;
                    string errors = errorReader.ReadToEnd();
                    string stream = myStreamReader.ReadToEnd();
                    procResult = proc.StandardOutput.ReadToEnd();
                    proc.Close();

                    string csvContent = File.ReadAllText(outCsv);
                    double[] doubles = Array.ConvertAll(csvContent.Split(','), Double.Parse);
                    double min = doubles[0];
                    double max = doubles[1];
                    double gap = (max - min) / Convert.ToDouble(input.NumberOfProspectivityClasses);
                    result.TresholdValues = "";
                    double current = min;

                    for (int i = 0; i < Convert.ToInt16(input.NumberOfProspectivityClasses) - 1; i++) // max value not added any more
                    {
                        if (result.TresholdValues != "")
                        {
                            result.TresholdValues += ",";
                        }
                        current += gap;
                        result.TresholdValues += current.ToString();
                    }
                    result.MinMaxValues = min.ToString() + " / " + max.ToString();
                }
            }
            return result;
        }

        private PermissiveTractResult maskRasterWPolygon(PermissiveTractInputParams input, PermissiveTractResult result)
        {
            string rScriptExecutablePath = input.Env.RPath;
            string procResult = string.Empty;

            var info = new ProcessStartInfo();
            info.FileName = rScriptExecutablePath;
            var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
            info.WorkingDirectory = path + "scripts/";
            var rCodeFilePath = path + "scripts/mask_polygon_wrapper.R";

            string outputFolder = projectFolder + "\\Classification\\Temp\\";
            if (!Directory.Exists(outputFolder))
            {
                Directory.CreateDirectory(outputFolder);
            }


            string inputRaster = input.DelineationRaster;
            string inputMask = input.MaskRaster;
            //string outputRaster = outputFolder + "maskedRaster" + input.DelID + ".img";
            //string outputPdf = outputFolder + "maskedRaster" + input.DelID + ".pdf";

            string outputRaster = outputFolder + "maskedRaster.img";
            string outputPdf = outputFolder + "maskedRaster.pdf";

            if (File.Exists(outputRaster))
            {
                File.Delete(outputRaster);
            }

            if (File.Exists(outputPdf))
            {
                File.Delete(outputPdf);
            }


            if (inputRaster != "" && inputMask != "")
            {
                info.Arguments = "\"" + rCodeFilePath + "\" " + inputRaster + " " + inputMask + " " + outputRaster + " " + outputPdf;
                info.RedirectStandardInput = false;
                info.RedirectStandardOutput = true;
                info.RedirectStandardError = true;
                info.UseShellExecute = false;
                info.CreateNoWindow = true;

                using (var proc = new Process())
                {
                    proc.StartInfo = info;
                    proc.Start();
                    StreamReader errorReader = proc.StandardError;
                    StreamReader myStreamReader = proc.StandardOutput;
                    //string errors = errorReader.ReadToEnd();
                    string stream = myStreamReader.ReadToEnd();
                    procResult = proc.StandardOutput.ReadToEnd();
                    proc.Close();
                }
            }
            return result;
        }




        /// <summary>
        /// Runs Classification process with given parameters.
        /// </summary>
        /// <param name="input">Input parameters.</param>
        /// <returns>Result of executing Classificate.</returns>
        private PermissiveTractResult Classificate(PermissiveTractInputParams input, PermissiveTractResult result)
        {
            if (input.DelineationRaster == "" || input.TresholdValues == "")
            {
                throw new ArgumentException("Input parameters not set correctly", "DelineationRaster/TresholdValues");
            }
            else
            {

                string rScriptExecutablePath = input.Env.RPath;
                string procResult = string.Empty;

                var info = new ProcessStartInfo();
                info.FileName = rScriptExecutablePath;
                var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                info.WorkingDirectory = path + "scripts/";
                var rCodeFilePath = path + "scripts/rasterproc_classify_wrapper.r";

                string outputFolder = projectFolder + "\\Classification\\Temp\\";
                if (!Directory.Exists(outputFolder))
                {
                    Directory.CreateDirectory(outputFolder);
                }

                string outCsv = projectFolder + "\\stats.csv";
                string csvContent = File.ReadAllText(outCsv);
                double[] doubles = Array.ConvertAll(csvContent.Split(','), Double.Parse);
                double min = doubles[0];
                double max = doubles[1];
                string tresholds = input.TresholdValues;
                string outputRaster = outputFolder + "ClassificationRaster_" + input.ClassificationId + ".img";
                string outputPdf = outputFolder + "ClassificationRaster_" + input.ClassificationId + ".pdf";

                //string delineationRaster = projectFolder + "\\Classification\\Temp\\" + "maskedRaster" + input.DelID + ".img";
                string delineationRaster = projectFolder + "\\Classification\\Temp\\" + "maskedRaster.img";
                if (!File.Exists(delineationRaster))
                {
                    delineationRaster = input.DelineationRaster;
                }

                info.Arguments = "\"" + rCodeFilePath + "\" " + delineationRaster + " " + tresholds + " " + outputRaster + " " + outputPdf;
                info.RedirectStandardInput = false;
                info.RedirectStandardOutput = true;
                info.RedirectStandardError = true;
                info.UseShellExecute = false;
                info.CreateNoWindow = true;

                using (var proc = new Process())
                {
                    proc.StartInfo = info;
                    proc.Start();
                    StreamReader errorReader = proc.StandardError;
                    StreamReader myStreamReader = proc.StandardOutput;
                    string stream = myStreamReader.ReadToEnd();
                    procResult = proc.StandardOutput.ReadToEnd();
                    proc.Close();
                }
            }
            return result;
        }


        /// <summary>
        /// Runs Delineation process with given parameters.
        /// </summary>
        /// <param name="input">Input parameters.</param>
        /// <returns>Result of executing Delineation.</returns>
        private PermissiveTractResult Delineation(PermissiveTractInputParams input, PermissiveTractResult result)
        {
            if (input.ProspectivityRasterFile == "" || input.BoundaryValues == "")
            {
                throw new ArgumentException("Input parameters not set correctly", "ProspectivityRasterFile/BoundaryValues");
            }
            else
            {
                string rScriptExecutablePath = input.Env.RPath;
                string procResult = string.Empty;

                var info = new ProcessStartInfo();
                info.FileName = rScriptExecutablePath;
                var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                info.WorkingDirectory = path + "scripts/";
                var rCodeFilePath = path + "scripts/rasterproc_wrapper.r";

                string outputFolder = projectFolder + @"\Delineation\temp\";
                if (!Directory.Exists(outputFolder))
                {
                    Directory.CreateDirectory(outputFolder);
                }

                string[] boundaryList = input.BoundaryValues.Split(',');
                foreach (string boundary in boundaryList)
                {

                    string discrOutput = outputFolder + "DelineationRaster_" + boundary.ToString();
                    string polyOutput = outputFolder + "DelineationPolygons_" + boundary.ToString();
                    string polyOutputF = "DelineationPolygons_" + boundary.ToString();
                    string boundariesOnEvidence = outputFolder + "BoundariesOnEvidence_" + boundary.ToString() + ".pdf";

                    info.Arguments = "\"" + rCodeFilePath + "\" \"" + input.ProspectivityRasterFile + "\" \"" + discrOutput + "\" \"" + polyOutput + "\" \"" + polyOutputF
                        + "\" \"" + boundary + "\" \"" + input.EvidenceLayerFile + "\" \"" + boundariesOnEvidence;
                    info.RedirectStandardInput = false;
                    info.RedirectStandardOutput = true;
                    info.RedirectStandardError = true;
                    info.UseShellExecute = false;
                    info.CreateNoWindow = true;

                    using (var proc = new Process())
                    {
                        proc.StartInfo = info;
                        proc.Start();
                        StreamReader errorReader = proc.StandardError;
                        StreamReader myStreamReader = proc.StandardOutput;
                        string stream = myStreamReader.ReadToEnd();
                        procResult = proc.StandardOutput.ReadToEnd();
                        proc.Close();

                    }
                }
            }

            return result;
        }


        /// <summary>
        /// Runs Delineation process with given parameters.
        /// </summary>
        /// <param name="input">Input parameters.</param>
        /// <returns>Result of executing Delineation.</returns>
        private PermissiveTractResult DelineationPolygon(PermissiveTractInputParams input, PermissiveTractResult result)
        {
            if (input.ProspectivityRasterFile == "" || input.BoundaryValues == "")
            {
                throw new ArgumentException("Input parameters not set correctly", "ProspectivityRasterFile/BoundaryValues");
            }
            else
            {
                string rScriptExecutablePath = input.Env.RPath;
                string procResult = string.Empty;

                var info = new ProcessStartInfo();
                info.FileName = rScriptExecutablePath;
                var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                info.WorkingDirectory = path + "scripts/";
                var rCodeFilePath = path + "scripts/rasterproc_wrapper_polygon.r";

                string outputFolder = projectFolder + @"\Delineation\temp\";
                if (!Directory.Exists(outputFolder))
                {
                    Directory.CreateDirectory(outputFolder);
                }

                string[] boundaryList = input.BoundaryValues.Split(',');
                foreach (string boundary in boundaryList)
                {

                    string discrOutput = outputFolder + "DelineationRaster_" + boundary.ToString();
                    string polyOutput = outputFolder + "DelineationPolygons_" + boundary.ToString();
                    string polyOutputF = "DelineationPolygons_" + boundary.ToString();
                    string boundariesOnEvidence = outputFolder + "BoundariesOnEvidence_" + boundary.ToString() + ".pdf";
                    string rasterFile = outputFolder + "DelineationRaster_" + boundary.ToString() + ".img";

                    info.Arguments = "\"" + rCodeFilePath + "\" \"" + rasterFile + "\" \"" + discrOutput + "\" \"" + polyOutput + "\" \"" + polyOutputF
                        + "\" \"" + boundary + "\" \"" + input.EvidenceLayerFile + "\" \"" + boundariesOnEvidence;
                    info.RedirectStandardInput = false;
                    info.RedirectStandardOutput = true;
                    info.RedirectStandardError = true;
                    info.UseShellExecute = false;
                    info.CreateNoWindow = true;

                    using (var proc = new Process())
                    {
                        proc.StartInfo = info;
                        proc.Start();
                        StreamReader errorReader = proc.StandardError;
                        StreamReader myStreamReader = proc.StandardOutput;
                        string stream = myStreamReader.ReadToEnd();
                        procResult = proc.StandardOutput.ReadToEnd();
                        proc.Close();

                    }
                }
            }

            return result;
        }

        private string getWeight(string inputWeight)
        {
            string output = "";
            switch (inputWeight)
            {
                case "A":
                case "a":
                    output = "Ascending";
                    break;

                case "D":
                case "d":
                    output = "Descending";
                    break;
                case "C":
                case "c":
                    output = "Categorial";
                    break;
                case "U":
                case "u":
                    output = "Unique";
                    break;

                default:
                    output = inputWeight;
                    break;
            }
            return output;

        }


        /// <summary>
        /// Runs WofE with given parameters.
        /// </summary>
        /// <param name="input">Input parameters.</param>
        /// <returns>Result of executing WofE.</returns>
        private PermissiveTractResult WofE(PermissiveTractInputParams input, PermissiveTractResult result)
        {
           
            var outputfolder = projectFolder + @"\Delineation\WofE\EvidenceData\";

           if (input.MethodId == "wofeClassification")
            {
                outputfolder = projectFolder + @"\Classification\WofE\EvidenceData\";
            }
           
            var outputTMPfolder = Path.Combine(outputfolder, "tmp_output");
            
            if (!Directory.Exists(outputTMPfolder))
            {
                Directory.CreateDirectory(outputTMPfolder);
            }

            if (!Directory.Exists(outputfolder))
            {
                Directory.CreateDirectory(outputfolder);
            }

            if (input.EvidenceRasterList.Count < 1 || input.EvidenceRasterList == null)
            {
                throw new ArgumentException("Input rasters not set.", "Input rasters");
            }
            else
            {
                ProcessStartInfo myProcessStartInfo = new ProcessStartInfo();
                Process myProcess = new Process();
                myProcess.StartInfo = myProcessStartInfo;
                string evidence_raster_layers = "";
                List<string> evidence_weight_tables = new List<string>();
                string[] Weights = input.WofEWeightsType.Split(',');
                int raster = 0;
                string calculateWeightResult = "";
                string calWeightMessage = "";

                foreach (string er in input.EvidenceRasterList)
                {
                    //Create WofeParameter.json
                    try
                    {
                        JObject wofeParameters = new JObject(
                        new JProperty("evidenceLayer", er),
                        new JProperty("codeName", ""),
                        new JProperty("trainingSites", input.TrainingPoints),
                        new JProperty("maskLayer", input.MaskRaster),
                        new JProperty("wType", getWeight(Weights[raster].Trim())),
                        //new JProperty("wtstable", "testweights"),
                        new JProperty("confidentContrast", Double.Parse(input.ConfidenceLevel)),
                        new JProperty("unitArea", Double.Parse(input.UnitArea)),
                        //new JProperty("MissingDataValue", "-99"),
                        //new JProperty("workspace", outputTMPfolder)
                        new JProperty("workspace", outputTMPfolder)
                        );

                        File.WriteAllText(outputfolder + @"WofeParameterWeights.json", wofeParameters.ToString());
                    }
                    catch (Exception)
                    {
                        throw;
                    }

                    //run calculateWeights
                    string pathToExe = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                    string Wofe2Exe = pathToExe + "scripts/WOFE_start/WOFE_start.exe"; 
                    myProcessStartInfo = new ProcessStartInfo(Wofe2Exe);
                    myProcessStartInfo.UseShellExecute = true;
                    myProcessStartInfo.Arguments = outputfolder + @"WofeParameterWeights.json calcweights";// "C:\\Aineistoja\\MAP\\Fuzzy\\FuzzyParameter.json";
                    myProcessStartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    myProcess = new Process();
                    myProcess.StartInfo = myProcessStartInfo;
                    myProcess.Start();
                    myProcess.WaitForExit();
                    string retValue = myProcess.ExitCode.ToString();
                    myProcess.Close();

                    Console.WriteLine("Value received from script: " + retValue);

                    //for calculate response
                    evidence_raster_layers += evidence_raster_layers != "" ? ";" : "";
                    evidence_raster_layers += er;
                    //evidence_weight_tables += evidence_weight_tables != "" ? ";" : "";
                    string jsonFile = Path.Combine(outputTMPfolder, Path.GetFileNameWithoutExtension(er) + ".json");
                    evidence_weight_tables.Add(jsonFile);
                    raster++;

                    if (retValue != "0")
                    {
                        result.CalculateWeightsResult = "ERROR";
                        return result;
                    }
                }
                
               

                //create WofeParameterResponse.json
                try
                {
                    JObject wofeParameters = new JObject(
                    new JProperty("evidenceLayers", input.EvidenceRasterList),
                    new JProperty("maskLayer", input.MaskRaster),
                    new JProperty("wtsTables", evidence_weight_tables),
                    new JProperty("trainingSites", input.TrainingPoints),
                    new JProperty("unitarea", Double.Parse(input.UnitArea)),
                    new JProperty("postProbRaster", Path.Combine(outputfolder, "PostProb.tif")),
                    new JProperty("stdDevRaster", Path.Combine(outputfolder, "StdDev.tif")),
                    new JProperty("confRaster", Path.Combine(outputfolder, "confidence.tif")),
                    new JProperty("ndvRaster", Path.Combine(outputfolder, "ndv.tif")),
                    new JProperty("workspace", outputTMPfolder)
                    );

                    File.WriteAllText(outputfolder + @"WofeParameterResponse.json", wofeParameters.ToString());
                }
                catch (Exception)
                {
                    throw;
                }
                //create run wofeResponse
                var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                string Wofe1Exe = path + "scripts/WOFE_start/WOFE_start.exe";
                myProcessStartInfo = new ProcessStartInfo(Wofe1Exe);
                myProcessStartInfo.UseShellExecute = true;
                myProcessStartInfo.Arguments = outputfolder + @"WofeParameterResponse.json calcresponse";// "C:\\Aineistoja\\MAP\\Fuzzy\\FuzzyParameter.json";
                myProcessStartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                myProcess = new Process();
                myProcess.StartInfo = myProcessStartInfo;
                myProcess.Start();
                myProcess.WaitForExit();
                string returnValue = myProcess.ExitCode.ToString();
                myProcess.Close();

                Console.WriteLine("Value received from script: " + returnValue);
                if (returnValue != "0")
                {
                    result.CalculateWeightsResult = "ERROR";
                    return result;
                }

            }
            return result;
        }

       

        /// <summary>
        /// Runs FuzzyOverlay with given parameters.
        /// </summary>
        /// <param name="input">Input parameters.</param>
        /// <returns>Result of executing Fuzzy Overlay.</returns>
        private PermissiveTractResult FuzzyOverlay(PermissiveTractInputParams input, PermissiveTractResult result)
        {

            var outputfolder = projectFolder + @"\Delineation\Fuzzy\EvidenceData\";
            if (input.MethodId == "fuzzyClassification")
            {
                outputfolder = projectFolder + @"\Classification\Fuzzy\EvidenceData\";
            }

            if (!Directory.Exists(outputfolder))
            {
                Directory.CreateDirectory(outputfolder);
            }

            List<string> inRasters = new List<string> { };

            if (input.InRasterList.Count < 1 || input.InRasterList == null)
            {
                throw new ArgumentException("Input rasters not set.", "Input rasters");
            }
            else
            {
                foreach (string s in input.InRasterList)
                {
                    inRasters.Add(s.Replace("\\", "/"));
                }
            }

            if (input.OutRaster == String.Empty || input.OutRaster == null || input.OutRaster == "Select outraster path and filename")
            {
                throw new ArgumentException("Output raster not set.", "Output raster");
            }
            else
            {
                input.OutRaster = input.OutRaster.Replace("\\", "/");
            }

            if (input.EnvPath == String.Empty || input.EnvPath == null)
            {
                //throw new ArgumentException("Environment path not set.", "Environment path");
            }
            else
            {
                input.EnvPath = input.EnvPath.Replace("\\", "/");
            }

         
            //Create fuzzyParameter.json
            try
            {
                JObject fuzzyParameters = new JObject(
                new JProperty("workspace", outputfolder),
                new JProperty("customfilename", input.FuzzyOutputFileName),
                new JProperty("splitnumber", input.FuzzySplitValue),
                new JProperty("method", input.FuzzyOverlayType),
                new JProperty("gamma", input.FuzzyGammaValue),
                new JProperty("rasters", inRasters)
                );

                File.WriteAllText(outputfolder + @"FuzzyParameter.json", fuzzyParameters.ToString());

            }
            catch (Exception)
            {
                throw;
            }



            var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
            string fuzzyExe = path + "scripts/fuzzy_start/fuzzy_start.exe";
            ProcessStartInfo myProcessStartInfo = new ProcessStartInfo(fuzzyExe);
            myProcessStartInfo.UseShellExecute = true;
            //myProcessStartInfo.RedirectStandardError = true;
            //myProcessStartInfo.RedirectStandardOutput = true;
            myProcessStartInfo.Arguments = outputfolder + @"FuzzyParameter.json";// "C:\\Aineistoja\\MAP\\Fuzzy\\FuzzyParameter.json";
            myProcessStartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            Process myProcess = new Process();
            myProcess.StartInfo = myProcessStartInfo;

            myProcess.Start();
            myProcess.WaitForExit();
            string returnValue = myProcess.ExitCode.ToString();
            myProcess.Close();

            Console.WriteLine("Value received from script: " + returnValue);
            result.PermissiveTractResults = returnValue;
            return result;

        }



    }
}
