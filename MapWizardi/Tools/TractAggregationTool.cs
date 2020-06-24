using System;
using System.IO;
using System.Diagnostics;
using NLog;

namespace MapWizard.Tools
{
    /// <summary>
    /// Tract Aggregation input parameters.
    /// </summary>
    public class TractAggregationInputParams : ToolParameters
    {
        /// <summary>
        /// Location of the file containing the correlation matrix for the permissive tracts.
        /// </summary>
        public string CorrelationMatrix
        {
            get { return GetValue<string>("CorrelationMatrix"); }
            set { Add<string>("CorrelationMatrix", value); }
        }
        /// <summary>
        /// Location of the csv file containing a list of number of deposits estimates 
        /// and corresponding probabilities for several permissive tracts, 
        /// or locations of several files, each containing the information for one permissive tract.
        /// If several files are given, the tool will combine these into one file.  
        /// </summary>
        public string ProbDistFile
        {
            get { return GetValue<string>("ProbDistFile"); }
            set { Add<string>("ProbDistFile", value); }
        }
        /// <summary>
        /// Path of working directory to use.
        /// </summary>
        public string WorkingDir
        {
            get { return GetValue<string>("WorkingDir"); }
            set { Add<string>("WorkingDir", value); }
        }
        /// <summary>
        /// Name for test.
        /// </summary>
        public string TestName
        {
            get { return GetValue<string>("TestName"); }
            set { Add<string>("TestName", value); }
        }
        /// <summary>
        /// Create input file? String representation for boolean.
        /// </summary>
        public string CreateInputFile
        {
            get { return GetValue<string>("CreateInputFile"); }
            set { Add<string>("CreateInputFile", value); }
        }
        /// <summary>
        /// Create input file? String representation for boolean.
        /// </summary>
        public string TractCombinationName
        {
            get { return GetValue<string>("TractCombinationName"); }
            set { Add<string>("TractCombinationName", value); }
        }
    }
    /// <summary>
    /// Tract aggregation results
    /// </summary>
    public class TractAggregationResult : ToolResult
    {
        /// <summary>
        /// A text file containing a summary of the aggregation run.
        /// </summary>
        public string TractAggregationSummary
        {
            get { return GetValue<string>("TractAggregationSummary"); }
            internal set { Add<string>("TractAggregationSummary", value); }
        }
    }
    /// <summary>
    /// Tract aggregation tool execution.
    /// </summary>
    public class TractAggregationTool : ITool
    {
        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();

        /// <summary>
        /// Call R script to run the tool.
        /// </summary>
        /// <param name="inputParams"> Input parameters as ToolParameters</param>
        /// <returns> ToolResult as TractAggregationTool result</returns>
        public ToolResult Execute(ToolParameters inputParams)
        {
            string procResult = string.Empty;
            var input = inputParams as TractAggregationInputParams;
            string rScriptExecutablePath = inputParams.Env.RPath;
            var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
            var info = new ProcessStartInfo();
            info.FileName = rScriptExecutablePath;
            var projectFolder = Path.Combine(inputParams.Env.RootPath, "TractAggregation");
            if (!Directory.Exists(projectFolder))
            {
                Directory.CreateDirectory(projectFolder);
            }
            input.Save(Path.Combine(projectFolder, "tract_aggregation_input_params.json"));
            var tractAggregationProject = Path.Combine(inputParams.Env.RootPath, "TractAggregation", "AggResults");
            string rProjectPath = tractAggregationProject.Replace("\\", "/");
            var rTractAggregationPath = Path.Combine(path, "scripts", "TractAggregation.R");
            TractAggregationResult result = new TractAggregationResult();
            var AggResultsPath = Path.Combine(inputParams.Env.RootPath, "TractAggregation", "AggResults", "AGG" + input.TractCombinationName);
            var TractCorrelationsFile = Path.Combine(AggResultsPath, "TractCorrelations.csv");
            var TractProbDistsFile = Path.Combine(AggResultsPath, "TractProbDists.csv");
            if (!Directory.Exists(AggResultsPath))
            {
                Directory.CreateDirectory(AggResultsPath);
            }
            if (File.Exists(input.CorrelationMatrix))
            {
                if (File.Exists(TractCorrelationsFile))
                    File.Delete(TractCorrelationsFile);
                File.Copy(input.CorrelationMatrix, Path.Combine(AggResultsPath, "TractCorrelations.csv"));
            }
            if (File.Exists(input.ProbDistFile))
            {
                if (File.Exists(TractProbDistsFile))
                    File.Delete(TractProbDistsFile);
                File.Copy(input.ProbDistFile, Path.Combine(AggResultsPath, "TractProbDists.csv"));
            }
            //If probability distribution file is created from separate files, run this script to create the proper input file before the main script.
            if (input.CreateInputFile == "True")
            {
                try
                {
                    var info2 = new ProcessStartInfo();
                    info2.FileName = rScriptExecutablePath;
                    var CombineFilesFolder = Path.Combine(input.Env.RootPath, "AggTempFolder");
                    var rCreateProbDistFilePath = Path.Combine(path, "scripts", "TractAggregationCreateDPFile.R");
                    rCreateProbDistFilePath = rCreateProbDistFilePath = rCreateProbDistFilePath.Replace("\\", "/");
                    info.Arguments = "\"" + rCreateProbDistFilePath + "\" \"" + CombineFilesFolder + "\"";
                    info.RedirectStandardInput = false;
                    info.RedirectStandardOutput = true;
                    info.UseShellExecute = false;
                    info.CreateNoWindow = true;
                    info.RedirectStandardError = true;
                    info.WorkingDirectory = CombineFilesFolder;

                    using (var proc = new Process())
                    {
                        proc.StartInfo = info;
                        proc.Start();
                        //StreamReader errorReader = proc.StandardError; TAGGED: no usage?
                        //StreamReader myStreamReader = proc.StandardOutput; TAGGED: no usage?
                        string procErrors = "";
                        proc.ErrorDataReceived += new DataReceivedEventHandler((sender, e) =>  //Use DataReceivedEventHandler to read error data, simply using proc.StandardError would sometimes freeze, due to buffer filling up
                        {                                                                      //Also, this approach makes it easier to implement a possible log window in the future
                            if (!String.IsNullOrEmpty(e.Data))
                            {
                                procErrors += (e.Data);
                            }
                        });
                        //string stream = myStreamReader.ReadToEnd(); TAGGED: no usage?
                        procResult = proc.StandardOutput.ReadToEnd();
                        proc.Close();
                        if (procErrors.Length > 1 && procErrors.ToLower().Contains("error"))  //Don't throw exception over warnings or empty error message.
                        {
                            logger.Error(procErrors);
                            //throw new Exception("R script execution failed. Check log file for details");  // TAGGED: Check error management and make it better.
                        }
                        logger.Trace("Tract Aggregation return value:" + procResult);
                    }
                }
                catch (Exception e)
                {
                    throw new Exception("Failed to create probability distribution file: " + e);
                }
            }

            //Run tract aggregation script
            info.Arguments = "\"" + rTractAggregationPath + "\"" + " " + "Agg" + " " + "\"" + AggResultsPath + "\" \"" + input.ProbDistFile + "\" \"" + input.CorrelationMatrix + "\"";
            info.RedirectStandardInput = false;
            info.RedirectStandardOutput = true;
            info.RedirectStandardError = true;
            info.UseShellExecute = false;
            info.CreateNoWindow = true;
            info.WorkingDirectory = AggResultsPath;
            try
            {
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
                    if (procErrors.Length > 1)
                    {
                        logger.Error(procErrors);
                    }
                    logger.Trace(procResult);
                    var resultFilePath = Path.Combine(AggResultsPath, "AggEstSummary.csv");
                    var resultString = File.ReadAllText(resultFilePath);
                    result.TractAggregationSummary = resultString.Replace(",", "\t");
                    result.TractAggregationSummary = result.TractAggregationSummary.Replace("\"", "");
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Tract Aggregation run failed: " + ex);
            }
            return result;
        }
    }
}
