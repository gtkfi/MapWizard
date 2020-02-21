using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.ServiceModel.Channels;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Win32;
using NLog;

namespace MapWizard.Tools
{
    /// <summary>
    /// Input parameters for Undiscovered Deposits tool.
    /// </summary>
    public class EconomicFilterInputParams : ToolParameters
    {
        /// <summary>
        /// The csv file (Tract05_SIM_EF.csv) produced by the Monte Carlo simulation tool and containing the simulated undiscovered deposits. 
        /// </summary>
        public string MCResults
        {
            get { return GetValue<string>("MCResults"); }
            set { Add<string>("MCResults", value); }
        }
        /// <summary>
        /// The commodity on which the calculations will be based. The drop box shows the commodities present in the simulated deposits file. 
        /// </summary>
        public string Metal
        {
            get { return GetValue<string>("Metal"); }
            set { Add<string>("Metal", value); }
        }
        /// <summary>
        /// Index of selected metal.
        /// </summary>
        public string MetalIndex
        {
            get { return GetValue<string>("MetalIndex"); }
            set { Add<string>("MetalIndex", value); }
        }
        /// <summary>
        /// List of metals to calculate.
        /// </summary>
        public string MetalsToCalculate
        {
            get { return GetValue<string>("MetalsToCalculate"); }
            set { Add<string>("MetalsToCalculate", value); }
        }
        /// <summary>
        /// Type of screening: Metal% or Count%.
        /// </summary>
        public string perType
        {
            get { return GetValue<string>("perType"); }
            set { Add<string>("perType", value); }
        }
        /// <summary>
        /// The cumulative resource in the largest deposits can be calculated based on either the N percent of largest 
        /// deposits ranked by the contained amount of the commodity selected above (count %), 
        /// or the Nth percentile of the cumulative amount of the commodity contained in the largest deposits (metal %). 
        /// </summary>
        public string percentage
        {
            get { return GetValue<string>("percentage"); }
            set { Add<string>("percentage", value); }
        }
        /// <summary>
        /// Raef package folder path.
        /// </summary>
        public string RaefPackageFolder
        {
            get { return GetValue<string>("RaefPackageFolder"); }
            set { Add<string>("RaefPackageFolder", value); }
        }
        /// <summary>
        /// Path of preset file containing inputs for RAEF calculation.
        /// </summary>
        public string RaefPresetFile
        {
            get { return GetValue<string>("RaefPresetFile"); }
            set { Add<string>("RaefPresetFile", value); }
        }
        /// <summary>
        /// Model index: 1=Screener, 2= Raef.
        /// </summary>
        public string ModelIndex
        {
            get { return GetValue<string>("ModelIndex"); }
            set { Add<string>("ModelIndex", value); }
        }

        /// <summary>
        /// Path of economic filter file used for RAEF calculation.
        /// </summary>
        public string RaefEconFilterFile
        {
            get { return GetValue<string>("RaefEconFilterFile"); }
            set { Add<string>("RaefEconFilterFile", value); }
        }

        /// <summary>
        /// Folder extension name for RAEF.
        /// </summary>
        public string RaefExtensionFolder
        {
            get { return GetValue<string>("RaefExtensionFolder"); }
            set { Add<string>("RaefExtensionFolder", value); }
        }
        /// <summary>
        /// Folder extension name for screener.
        /// </summary>
        public string ScreenerExtensionFolder
        {
            get { return GetValue<string>("ScreenerExtensionFolder"); }
            set { Add<string>("ScreenerExtensionFolder", value); }
        }

    }

    /// <summary>
    /// Output parameters for Monte Carlo Simulation -tool.
    /// - SummaryTotalTonnage 
    /// - TotalTonPd 
    /// - MarginalPfd 
    /// - SimulatedDeposits
    /// </summary>
    public class EconomicFilterResult : ToolResult
    {
        /// <summary>
        ///  A screened csv file of the ore and metal contents of each simulated deposit, 
        ///  in which the contents of deposits that are smaller than the selected threshold value have been recoded to zero.
        /// </summary>
        public string EcoTonnage
        {
            get { return GetValue<string>("EcoTonnage"); }
            internal set { Add<string>("EcoTonnage", value); }
        }

        /// <summary>
        /// A csv file containing summary statistics calculated using the screened file of simulated deposits.
        /// </summary>
        public string EcoTonnageStats
        {
            get { return GetValue<string>("EcoTonnageStats"); }
            internal set { Add<string>("EcoTonnageStats", value); }
        }

        /// <summary>
        /// A jpeg file containing a plot of the frequency distribution of the values of the selected commodity in the screened simulated deposits.
        /// </summary>
        public string EcoTonHistogram
        {
            get { return GetValue<string>("EcoTonHistogram"); }
            internal set { Add<string>("EcoTonHistogram", value); }
        }

        /// <summary>
        /// A jpeg file containing a plot of the cumulative fraction of commodity contained against the cumulative fraction of deposit.
        /// </summary>
        public string ResultPlot
        {
            get { return GetValue<string>("ResultPlot"); }
            internal set { Add<string>("ResultPlot", value); }
        }

    }
    /// <summary>
    /// Economic filter tool execution.
    /// </summary>
    public class EconomicFilterTool : ITool
    {


        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();

        /// <summary>
        /// Run tool
        /// </summary>
        /// <param name="inputParams"> Input parameters</param>
        /// <returns>Result as ToolResult</returns>
        public ToolResult Execute(ToolParameters inputParams)
        {

            var input = inputParams as EconomicFilterInputParams;
            EconomicFilterResult result = new EconomicFilterResult();

            //If type is EconFilter/Screener
            if (input.ModelIndex == "1")
            {
                try
                {
                    string projectFolder = Path.Combine(inputParams.Env.RootPath, "EconFilter", "Screener", input.ScreenerExtensionFolder);
                    try
                    {                      
                        if (!Directory.Exists(projectFolder))
                        {
                            Directory.CreateDirectory(projectFolder);
                        }

                        input.Save(Path.Combine(inputParams.Env.RootPath, "EconFilter", "economic_filter_input_params.json"));
                        input.Save(Path.Combine(projectFolder, "economic_filter_input_params.json")); //save also to screener folder for selecting result
                    }
                    catch (Exception ex)
                    {
                        throw new Exception("Failed to initialize project folder: " + ex);
                    }
                    Double percent;
                    string pType;
                    pType = input.perType == "Count %" ? "1" : "2";
                    percent = Convert.ToDouble(input.percentage) / 100;
                    var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                    var rCodeFilePath = "\"" + path + "scripts/econf.r" + "\"";
                    string rScriptExecutablePath = inputParams.Env.RPath;
                    string tmpPlot = Path.Combine(input.Env.RootPath, "EconFilter", "Screener", input.ScreenerExtensionFolder);
                    string procResult = string.Empty;
                    var info = new ProcessStartInfo();
                    info.FileName = rScriptExecutablePath;
                    info.WorkingDirectory = path + "scripts/";
                    info.Arguments = rCodeFilePath + " " + "\"" + input.MCResults + "\"" + " " + pType + " " + input.percentage.ToString() + " " + "\"" + tmpPlot + "\"" + " " + input.MetalIndex + " " + input.MetalsToCalculate;
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
                        if (errors.Length > 1 && errors.ToLower().Contains("error"))  //Don't throw exception over warnings or empty error message.
                        {
                            logger.Error(errors);
                            throw new Exception("R script failed, check log file for details.");
                        }
                        string stream = myStreamReader.ReadToEnd();
                        procResult = proc.StandardOutput.ReadToEnd();
                        proc.Close();
                        result.EcoTonnage = Path.Combine(projectFolder, "eco_tonnages.csv");
                        result.EcoTonnageStats = Path.Combine(projectFolder, "eco_tonnage_stat.csv");
                        result.EcoTonHistogram = Path.Combine(projectFolder, "eco_ton_histogram.jpeg");
                        result.ResultPlot = Path.Combine(projectFolder, "result_plot.jpeg");
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("Economic filter screener tool failed: ");  // TAGGED: Fix exception handling.
                }
                return result;
            }
            else //If type is RAEF
            {
                try
                {
                    string projectFolder = Path.Combine(inputParams.Env.RootPath, "EconFilter", "RAEF", input.RaefExtensionFolder);
                    string packageFolder = Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "scripts", "RAEF", "Package");
                    try
                    {
                      

                        if (!Directory.Exists(projectFolder))
                        {
                            Directory.CreateDirectory(projectFolder);
                        }


                        var projectFolderInfo = new DirectoryInfo(projectFolder);

                        foreach (FileInfo file in projectFolderInfo.GetFiles())
                        {
                            file.Delete();
                        }

                        input.Save(Path.Combine(inputParams.Env.RootPath, "EconFilter", "economic_filter_input_params.json"));
                        input.Save(Path.Combine(projectFolder, "economic_filter_input_params.json")); //Save also to raef folder for selecting results
                    }
                    catch (Exception ex)
                    {
                        throw new Exception("Failed to initialize project folder: " + ex);
                    }

                    var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                    var rCodeFilePath = "\"" + path + "scripts/RAEF_MW.r" + "\"";
                    string rScriptExecutablePath = inputParams.Env.RPath;
                    string procResult = string.Empty;
                    var info = new ProcessStartInfo();
                    info.FileName = rScriptExecutablePath;
                    info.WorkingDirectory = Path.Combine(path, "scripts");
                    info.Arguments = rCodeFilePath + " " + "\"" + packageFolder + "\"" + " " + "\"" + input.RaefPresetFile + "\"" + " " + "\"" + projectFolder + "\"" + " " + "\"" + input.RaefEconFilterFile + "\"";
                    info.RedirectStandardInput = false;
                    info.RedirectStandardOutput = true;
                    info.RedirectStandardError = true;
                    info.UseShellExecute = false;
                    info.CreateNoWindow = true;

                    using (var proc = new Process())
                    {
                        proc.StartInfo = info;
                        proc.Start();
                        StreamReader myStreamReader = proc.StandardOutput;
                        string procErrors = "";
                        proc.ErrorDataReceived += new DataReceivedEventHandler((sender, e) =>  //Use DataReceivedEventHandler to read error data, simply using proc.StandardError would sometimes freeze, due to buffer filling up
                        {
                            if (!String.IsNullOrEmpty(e.Data))
                            {
                                procErrors += (e.Data);
                            }
                        });
                        proc.BeginErrorReadLine();
                        string stream = myStreamReader.ReadToEnd();
                        logger.Trace(stream);
                        if (procErrors.Length > 1 && procErrors.ToLower().Contains("error"))  //Don't throw exception over warnings or empty error message.
                        {
                            logger.Error(procErrors);
                            throw new Exception("R script failed, check log file for details");
                        }
                        procResult = proc.StandardOutput.ReadToEnd();
                        proc.Close();
                    }
                }
                catch (Exception ex)
                {
                    logger.Trace("Error: " + ex);
                    throw new Exception("Economic filter RAEF tool failed: ");
                }
                return result;

            }
        }
    }
}
