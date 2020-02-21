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
        public string GradePdf
        {
            get { return GetValue<string>("GradePdf"); }
            set { Add<string>("GradePdf", value); }
        }
        /// <summary>
        /// Location of the R object (tonnage.rds) produced by the Grade-tonnage model tool.  The object contains the estimated probability density function of ore or metal tonnage. 
        /// </summary>
        public string TonnagePdf
        {
            get { return GetValue<string>("TonnagePdf"); }
            set { Add<string>("TonnagePdf", value); }
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
        public string TotalTonPdf
        {
            get { return GetValue<string>("TotalTonPdf"); }
            internal set { Add<string>("TotalTonPdf", value); }
        }
        /// <summary>
        /// Marginal pdf.
        /// </summary>
        public string MarginalPdf
        {
            get { return GetValue<string>("MarginalPdf"); }
            internal set { Add<string>("MarginalPdf", value); }
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
            string projectFolder = Path.Combine(inputParams.Env.RootPath, "MCSim", input.ExtensionFolder);
            projectFolder = projectFolder.Replace("\\", "/");
            try
            {

                if (!Directory.Exists(projectFolder))
                {
                    Directory.CreateDirectory(projectFolder);
                }

                input.Save(Path.Combine(projectFolder, "monte_carlo_simulation_input_params.json"));
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

            var info = new ProcessStartInfo();
            info.FileName = rScriptExecutablePath;
            info.WorkingDirectory = path + "scripts/";
            info.Arguments = "\"" + rCodeFilePath + "\" \"" + input.NDepositsPmf + "\" \"" + input.TonnagePdf + "\" \"" + input.GradePdf + "\" \"" + scriptPath + "oMeta.rds" + "\" \"" + summaryTxt + "\" \"" + projectFolder + "\" " + input.ExtensionFolder;
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
                    result.SimulatedDepositsCSV = Path.Combine(projectFolder, "Tract_05_Sim_EF.csv");
                    result.TotalTonPdf = Path.Combine(input.Env.RootPath, "MCSim", input.ExtensionFolder, "plot.jpeg");
                    result.MarginalPdf = Path.Combine(input.Env.RootPath, "MCSim", input.ExtensionFolder, "plotMarginals.jpeg");
                }
                catch (Exception ex)
                {
                    throw new Exception("R script failed, check log file for details.");
                }
            }

            return result;
        }

        private void CreateEstimationCsv(string pathToCsv, string depositsEstimations)
        {
            File.WriteAllText(pathToCsv, depositsEstimations);
        }
    }
}
