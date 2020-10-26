using System;
using System.Diagnostics;
using System.IO;
using NLog;

namespace MapWizard.Tools
{
    /// <summary>
    /// input parameters for Monte Carlo Simulation -tool
    /// - GradePdf (Grade R-object)
    /// - TonnagePdf (Tonnage R-object)
    /// - NDepositsPmf (Number of deposits R-object)
    /// </summary>
    public class MonteCarloSimulationInputParams : ToolParameters
    {
        /// <summary>
        ///Location of the R object (grade.rds) produced by the Grade-tonnage model tool. The object contains the estimated probability density functions of metal grades.
        /// </summary>
        public string GradePlot
        {
            get { return GetValue<string>("GradePlot"); }
            set { Add<string>("GradePlot", value); }
        }
        /// <summary>
        /// Location of the R object (tonnage.rds) produced by the Grade-tonnage model tool.  The object contains the estimated probability density function of ore or metal tonnage. 
        /// </summary>
        public string TonnagePlot
        {
            get { return GetValue<string>("TonnagePlot"); }
            set { Add<string>("TonnagePlot", value); }
        }
        /// <summary>
        /// Location of the R object (tongrade.rds) produced by the Grade-tonnage model tool.  The object contains the estimated probability density function of ore or metal tonnage. 
        /// </summary>
        public string GradeTonnagePlot
        {
            get { return GetValue<string>("GradeTonnagePlot"); }
            set { Add<string>("GradeTonnagePlot", value); }
        }
        /// <summary>
        ///  Location of the R object (oPmf.rds) produced by the Undiscovered deposits tool. The object contains the estimated probability mass function of the number of undiscovered deposits. 
        /// </summary>
        public string NDepositsPmf
        {
            get { return GetValue<string>("NDepositsPmf"); }
            set { Add<string>("NDepositsPmf", value); }
        }
        /// <summary>
        /// Name of extension folder.
        /// </summary>
        public string ExtensionFolder
        {
            get { return GetValue<string>("ExtensionFolder"); }
            set { Add<string>("ExtensionFolder", value); }
        }

        /// <summary>
        /// Name of selected tract
        /// </summary>
        public string TractID
        {
            get { return GetValue<string>("TractId"); }
            set { Add<string>("TractId", value); }
        }

        /// <summary>
        /// Last run selected tract 
        /// </summary>
        public string LastRunTract
        {
            get { return GetValue<string>("LastRunTract"); }
            set { Add<string>("LastRunTract", value); }
        }
    }

    /// <summary>
    /// Output parameters for Monte Carlo Simulation -tool
    /// - SummaryTotalTonnage 
    /// - TotalTonPd 
    /// - MarginalPfd 
    /// - SimulatedDeposits
    /// </summary>
    public class MonteCarloSimulationResult : ToolResult
    {
        /// <summary>
        /// Total tonnage sumamry
        /// </summary>
        public string SummaryTotalTonnage
        {
            get { return GetValue<string>("SummaryTotalTonnage"); }
            internal set { Add<string>("SummaryTotalTonnage", value); }
        }
        /// <summary>
        /// Total tonnage pdf.
        /// </summary>
        public string TotalTonPlot
        {
            get { return GetValue<string>("TotalTonPlot"); }
            internal set { Add<string>("TotalTonPlot", value); }
        }
        /// <summary>
        /// Marginal pdf.
        /// </summary>
        public string MarginalPlot
        {
            get { return GetValue<string>("MarginalPlot"); }
            internal set { Add<string>("MarginalPlot", value); }
        }
        /// <summary>
        /// Simulated deposits csv file.
        /// </summary>
        public string SimulatedDepositsCSV
        {
            get { return GetValue<string>("SimulatedDepositsCSV"); }
            internal set { Add<string>("SimulatedDepositsCSV", value); }
        }

    }

    /// <summary>
    /// MonteCarloSimulationTool excecution.
    /// </summary>
    public class MonteCarloSimulationTool : ITool
    {
        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();

        /// <summary>
        ///  Excecutes tool and returns results as parameters.
        /// </summary>
        /// <param name="inputParams">Input parameters</param>
        /// <returns>Result as MonteCarloSimulationResult</returns>
        public ToolResult Execute(ToolParameters inputParams)
        {
            var input = inputParams as MonteCarloSimulationInputParams;
            MonteCarloSimulationResult result = new MonteCarloSimulationResult();
            //string projectFolder = Path.Combine(inputParams.Env.RootPath, "MCSim", input.ExtensionFolder);
            string MCSimFolder = Path.Combine(inputParams.Env.RootPath, "MCSim");
            string projectFolder = Path.Combine(MCSimFolder, input.TractID, input.ExtensionFolder);
            try
            {
                if (!Directory.Exists(projectFolder))
                {
                    Directory.CreateDirectory(projectFolder);
                }
                input.Save(Path.Combine(MCSimFolder, "monte_carlo_simulation_input_params.json"));
                input.Save(Path.Combine(projectFolder, "monte_carlo_simulation_input_params.json"));
                ////Create possible extension folder
                //if (input.ExtensionFolder != null && input.ExtensionFolder != "")
                //{
                //    projectFolder = Path.Combine(projectFolder,input.ExtensionFolder);
                //    if (!Directory.Exists(projectFolder))
                //    {
                //        Directory.CreateDirectory(projectFolder);
                //    }
                //}
            }
            catch (Exception ex)
            {
                throw new Exception("Failed to initialize model folder:" + ex);
            }
            var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
            var rCodeFilePath = path + "scripts/MonteCarloSimulationWrapper.R";
            var scriptPath = path + "scripts/MonteCarloSimulation/";
            var summaryTxt = Path.Combine(projectFolder, "summary.txt");
            string rScriptExecutablePath = result.Env.RPath;
            string procResult = string.Empty;
            string tractName = input.TractID;
            string tonnagePDF = input.TonnagePlot.Contains("Please select") ? "NA" : input.TonnagePlot;
            string gradePDF = input.GradePlot.Contains("Please select") ?   "NA" : input.GradePlot;
            string gradeTonnagePDF = input.GradeTonnagePlot.Contains("Please select") ? "NA" : input.GradeTonnagePlot;

            var info = new ProcessStartInfo();
            info.FileName = rScriptExecutablePath;
            info.WorkingDirectory = path + "scripts/";
            info.Arguments = "\"" + rCodeFilePath + "\" \"" + input.NDepositsPmf + "\" \"" + tonnagePDF + "\" \"" + gradePDF + "\" \"" + gradeTonnagePDF + "\" \"" + scriptPath + "oMeta.rds" + "\" \"" + summaryTxt + "\" \"" + projectFolder + "\"";
            info.Arguments += " "+tractName;
            info.RedirectStandardInput = false;
            info.RedirectStandardOutput = true;
            info.RedirectStandardError = true;
            info.UseShellExecute = false;
            info.CreateNoWindow = true;

            using (var proc = new Process())
            {
                try
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
                        logger.Error(procErrors);
                    result.SummaryTotalTonnage = File.ReadAllText(Path.Combine(projectFolder, "summary.txt"));
                    result.SimulatedDepositsCSV = Path.Combine(projectFolder, tractName + "_05_SIM_EF.csv");
                    result.TotalTonPlot = Path.Combine(projectFolder, "plot.jpeg");
                    result.MarginalPlot = Path.Combine(projectFolder, "plotMarginals.jpeg");
                }
                catch (Exception ex)
                {
                    throw new Exception("R script failed, check log file for details.");
                }
            }
            return result;
        }

        /// <summary>
        /// Create Estimation CSV.
        /// </summary>
        private void CreateEstimationCsv(string pathToCsv, string depositsEstimations)
        {
            File.WriteAllText(pathToCsv, depositsEstimations);
        }
    }
}
