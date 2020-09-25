using System;
using System.IO;
using System.Linq;
using Microsoft.Win32;
using System.Diagnostics;
using System.Text;
using NLog;

namespace MapWizard.Tools
{
    /// <summary>
    /// Gradetonnage input parameters.
    /// </summary>
    public class GradeTonnageInputParams : ToolParameters
    {
        /// <summary>
        /// Path of CSV input file.
        /// </summary>
        public string CSVPath
        {
            get { return GetValue<string>("CSVPath"); }
            set { Add<string>("CSVPath", value); }
        }
        /// <summary>
        /// Seed value to be used in random number generation (Default value 1). 
        /// </summary>
        public string Seed
        {
            get { return GetValue<string>("Seed"); }
            set { Add<string>("Seed", value); }
        }
        /// <summary>
        /// Type of the probability density function (pdf) to be estimated for the grade and/or tonnage data. The alternatives are normal(default) and kde. 
        /// </summary>
        public string PDFType
        {
            get { return GetValue<string>("PDFType"); }
            set { Add<string>("PDFType", value); }
        }
        /// <summary>
        ///  Specifies whether the estimated pdf is truncated at the lowest and highest data values in the grade-tonnage or metal tonnage data file. Default value: FALSE
        /// </summary>
        public string IsTruncated
        {
            get { return GetValue<string>("IsTruncated"); }
            set { Add<string>("IsTruncated", value); }
        }
        /// <summary>
        /// Number of minimum deposits.
        /// </summary>
        public string MinDepositCount
        {
            get { return GetValue<string>("MinDepositCount"); }
            set { Add<string>("MinDepositCount", value); }
        }
        /// <summary>
        /// Number of random samples generated when estimating summary statistics for the pdfs. This should be a large number to ensure precise summary statistics(Default value 1,000,000). 
        /// </summary>
        public string RandomSampleCount
        {
            get { return GetValue<string>("RandomSampleCount"); }
            set { Add<string>("RandomSampleCount", value); }
        }
        /// <summary>
        /// Project output folder.
        /// </summary>
        public string Folder
        {
            get { return GetValue<string>("Folder"); }
            set { Add<string>("Folder", value); }
        }
        /// <summary>
        /// Model type: Grade, tonnage or grade-tonnage.
        /// </summary>
        public string ModelType
        {
            get { return GetValue<string>("ModelType"); }
            set { Add<string>("ModelType", value); }
        }
        /// <summary>
        /// Whether to run grade calculation.
        /// </summary>
        public string RunGrade
        {
            get { return GetValue<string>("RunGrade"); }
            set { Add<string>("RunGrade", value); }
        }
        /// <summary>
        /// Whether to run tonnage calculation.
        /// </summary>
        public string RunTonnage
        {
            get { return GetValue<string>("RunTonnage"); }
            set { Add<string>("RunTonnage", value); }
        }
        /// <summary>
        /// Extension folder name.
        /// </summary>
        public string ExtensionFolder
        {
            get { return GetValue<string>("ExtensionFolder"); }
            set { Add<string>("ExtensionFolder", value); }
        }
    }

    /// <summary>
    /// Gradetonnage results.
    /// </summary>
    public class GradeTonnageResult : ToolResult
    {
        /// <summary>
        /// Displays histograms and cumulative distribution functions that are calculated from the probability density function representing the grades. 
        /// </summary>
        public string GradePlot
        {
            get { return GetValue<string>("GradePlot"); }
            internal set { Add<string>("GradePlot", value); }
        }
        /// <summary>
        /// An R object file containing the estimated metal grade pdfs (grade.rds).
        /// </summary>
        public string GradePdf
        {
            get { return GetValue<string>("GradePdf"); }
            internal set { Add<string>("GradePdf", value); }
        }
        /// <summary>
        /// Displays summary statistics for the grades and a comparison of the pdfs representing the grades and the actual grades in the model dataset.
        /// </summary>
        public string GradeSummary
        {
            get { return GetValue<string>("GradeSummary"); }
            internal set { Add<string>("GradeSummary", value); }
        }
        /// <summary>
        /// Displays the probability density function that represents the ore tonnage in an undiscovered deposit and the corresponding cumulative distribution function. 
        /// </summary>
        public string TonnagePlot
        {
            get { return GetValue<string>("TonnagePlot"); }
            internal set { Add<string>("TonnagePlot", value); }
        }
        /// <summary>
        /// An R object file containing the estimated ore tonnage or metal tonnage pdf (tonnage.rds).
        /// </summary>
        public string TonnagePdf
        {
            get { return GetValue<string>("TonnagePdf"); }
            internal set { Add<string>("TonnagePdf", value); }
        }
        /// <summary>
        /// Displays summary statistics for the tonnage and a comparison of the pdf representing the tonnage and the actual tonnages in the model dataset. 
        /// </summary>
        public string TonnageSummary
        {
            get { return GetValue<string>("TonnageSummary"); }
            internal set { Add<string>("TonnageSummary", value); }
        }
        /// <summary>
        /// Tool output.
        /// </summary>
        public string Output
        {
            get { return GetValue<string>("Output"); }
            internal set { Add<string>("Output", value); }
        }

        public string Warnings
        {
            get { return GetValue<string>("Warnings"); }
            internal set { Add<string>("Warnings", value); }
        }
    }


    /// <summary>
    /// GradeTonnage Tool
    /// </summary>
    public class GradeTonnageTool : ITool
    {
        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();
        string gradeProject;
        string tonnageProject;

        /// <summary>
        /// GradeTonnage Tool execution
        /// </summary>
        /// <param name="inputParams">Input parameters as ToolParameters</param>
        /// <returns>ToolResult as GradeTonnageResult</returns>
        public ToolResult Execute(ToolParameters inputParams)
        {
            //Initialize variables
            var input = inputParams as GradeTonnageInputParams;
            gradeProject = Path.Combine(inputParams.Env.RootPath, "GTModel", input.ExtensionFolder);
            if (!Directory.Exists(gradeProject))
            {
                Directory.CreateDirectory(gradeProject);
            }
            GradeTonnageResult result = new GradeTonnageResult();
            var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
            var rGradePath = path + "scripts/GradeWrapper.R";
            var rTonnagePath = path + "scripts/TonnageWrapper.R";
            var workingDir = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
            workingDir = workingDir + "scripts";
            workingDir.Replace(@"\n", @"");
            string rScriptExecutablePath = inputParams.Env.RPath;
            string procResult = string.Empty;

            var gtProject = Path.Combine(inputParams.Env.RootPath, "GTModel", input.ExtensionFolder);
            var gtDirInfo = new DirectoryInfo(gtProject);
            try
            {
                if (!Directory.Exists(gtProject))
                {
                    Directory.CreateDirectory(gtProject);
                }
                else
                {
                    foreach (FileInfo f in gtDirInfo.GetFiles())
                    {
                        f.Delete();
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex);
                throw new Exception("Could not initialize project folder: ", ex);
            }
            input.Save(Path.Combine(gradeProject, "GradeTonnage_input_params.json"));
            if (input.RunGrade == "True")  //Run grade
            {
                try
                {
                    string inputFileDest = Path.Combine(gradeProject, "GT_InputFile.csv");
                    File.Copy(input.CSVPath, Path.Combine(gradeProject, "GT_InputFile.csv"), true);
                    gradeProject = Path.Combine(inputParams.Env.RootPath, "GTModel", input.ExtensionFolder);
                    var info = new ProcessStartInfo();
                    info.FileName = rScriptExecutablePath;
                    string rProjectPath = gradeProject.Replace("\\", "/");
                    info.Arguments = "\"" + rGradePath + "\" \"" + input.CSVPath + "\" " + input.Seed + " " + input.PDFType + " " + input.IsTruncated + " " + input.MinDepositCount + " " + input.RandomSampleCount + " \"" + gradeProject + "\" \"" + workingDir + "\"";

                    info.RedirectStandardInput = false;
                    info.RedirectStandardOutput = true;
                    info.RedirectStandardError = true;
                    info.UseShellExecute = false;
                    info.CreateNoWindow = true;
                    info.WorkingDirectory = path + "scripts/";
                    using (var proc = new Process())
                    {
                        proc.StartInfo = info;
                        proc.Start();
                        string procErrors = "";
                        proc.ErrorDataReceived += new DataReceivedEventHandler((sender, e) =>  //Use DataReceivedEventHandler to read error data, simply using proc.StandardError would sometimes freeze, due to buffer filling up
                        {
                            if (!String.IsNullOrEmpty(e.Data))
                            {
                                procErrors += (e.Data);
                            }
                        });
                        proc.BeginErrorReadLine();
                        procResult = proc.StandardOutput.ReadToEnd();
                        proc.Close();
                        result.Warnings = "";
                        if (procErrors.Length > 1&& procErrors.ToLower().Contains("error")) //Don't throw exception over warnings or empty error message.
                        {
                            logger.Error(procErrors);
                            throw new Exception(" R script failed, check output for details.");
                        }                     
                        else if (procErrors.Length>1 && procErrors.ToLower().Contains("the input grade-tonnage data file contains less than 20 deposits"))
                            result.Warnings="The input grade - tonnage data file contains less than 20 deposits.This might reduce the representativeness of the generated pdfs.";
                        result.GradeSummary = File.ReadAllText(Path.Combine(gradeProject, "grade_summary.txt"));
                        result.GradePlot = Path.Combine(gradeProject, "grade_plot.jpeg");
                        logger.Trace("Grade tonnage return value: " + procResult);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("Failed to excecute Grade tool: " + ex);
                }
            }
            if (input.RunTonnage == "True")  //Run tonnage
            {
                try
                {
                    var info = new ProcessStartInfo();
                    info.FileName = rScriptExecutablePath;
                    tonnageProject = Path.Combine(inputParams.Env.RootPath, "GTModel", input.ExtensionFolder);
                    if (!Directory.Exists(tonnageProject))
                    {
                        Directory.CreateDirectory(tonnageProject);
                    }
                    string inputFileDest = Path.Combine(tonnageProject, "GT_InputFile.csv");
                    File.Copy(input.CSVPath, Path.Combine(tonnageProject, "GT_InputFile.csv"), true);
                    string rProjectPath = tonnageProject.Replace("\\", "/");
                    info.Arguments = "\"" + rTonnagePath + "\" \"" + input.CSVPath + "\" " + input.Seed + " " + input.PDFType + " " + input.IsTruncated + " " + input.MinDepositCount + " " + input.RandomSampleCount + " \"" + tonnageProject + "\" \"" + workingDir + "\"";

                    info.RedirectStandardInput = false;
                    info.RedirectStandardOutput = true;
                    info.RedirectStandardError = true;
                    info.UseShellExecute = false;
                    info.CreateNoWindow = true;
                    info.WorkingDirectory = path + "scripts/";

                    using (var proc = new Process())
                    {
                        proc.StartInfo = info;
                        proc.Start();

                        string procErrors = "";
                        proc.ErrorDataReceived += new DataReceivedEventHandler((sender, e) =>  //Use DataReceivedEventHandler to read error data, simply using proc.StandardError would sometimes freeze, due to buffer filling up
                        {                                                                      //Also, this approach makes it easier to implement a possible log window in the future
                            if (!String.IsNullOrEmpty(e.Data))
                            {
                                procErrors += (e.Data);
                            }
                        });
                        proc.BeginErrorReadLine();
                        procResult = proc.StandardOutput.ReadToEnd();
                        proc.Close();
                        result.Warnings = "";
                        if (procErrors.Length > 1 && procErrors.ToLower().Contains("error"))
                        {
                            logger.Error(procErrors);
                            throw new Exception("R script failed. Check log file for details.");
                        }
                        else if (procErrors.Length > 1 && procErrors.ToLower().Contains("the input grade-tonnage data file contains less than 20 deposits"))
                            result.Warnings = "The input grade - tonnage data file contains less than 20 deposits.This might reduce the representativeness of the generated pdfs.";
                        logger.Trace("Grade Tonnage return value: " + procResult);
                        result.TonnageSummary = File.ReadAllText(Path.Combine(tonnageProject, "tonnage_summary.txt"));
                        result.TonnagePlot = Path.Combine(tonnageProject, "tonnage_plot.jpeg");
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("Failed to execute Tonnage tool:" + ex);
                }
                //Write metaDataFile
                try
                {
                    var metaFile = new StringBuilder();
                    metaFile.AppendLine(input.ModelType);
                    var gtProjectRoot = Path.Combine(inputParams.Env.RootPath, "GTModel", input.ExtensionFolder);
                    var metaPath = Path.Combine(gtProjectRoot, "MetaData.csv");
                    File.WriteAllText(metaPath, input.ToString());
                }
                catch (Exception ex)
                {
                    throw new Exception("Writing MetaData.csv failed: " + ex);
                }
                finally
                {
                }
            }
            return result;
        }
    }
}
