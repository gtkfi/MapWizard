using System;
using System.Diagnostics;
using System.IO;
using NLog;

namespace MapWizard.Tools
{
    /// <summary>
    /// Input parameters for Undiscovered Deposits tool.
    /// - depositsCSVPath
    /// </summary>
    public class UndiscoveredDepositsInputParams : ToolParameters
    {
        /// <summary>
        /// CSV file for negative binomial.
        /// </summary>
        public string DepositsNegativeCSV
        {
            get { return GetValue<string>("depositsNegativeCSV"); }
            set { Add<string>("depositsNegativeCSV", value); }
        }
        /// <summary>
        /// CSV file for Custom run.
        /// </summary>
        public string DepositsCustomCSV
        {
            get { return GetValue<string>("depositsCustomCSV"); }
            set { Add<string>("depositsCustomCSV", value); }
        }
        /// <summary>
        /// Rationale for estimations.
        /// </summary>
        public string EstRationaleTXT
        {
            get { return GetValue<string>("estRationaleTXT"); }
            set { Add<string>("estRationaleTXT", value); }
        }
        /// <summary>
        /// Rationale for Mark3 estimations.
        /// </summary>
        public string Mark3EstRationaleTXT
        {
            get { return GetValue<string>("mark3EstRationaleTXT"); }
            set { Add<string>("mark3EstRationaleTXT", value); }
        }
        /// <summary>
        /// Rationale for custom run estimations.
        /// </summary>
        public string CustomEstRationaleTXT
        {
            get { return GetValue<string>("customEstRationaleTXT"); }
            set { Add<string>("customEstRationaleTXT", value); }
        }
        /// <summary>
        /// Method of evaluation (Custom, middle/MARK3, negative binomial).
        /// </summary>
        public string Method
        {
            get { return GetValue<string>("method"); }
            set { Add<string>("method", value); }
        }
        /// <summary>
        /// N90 probability.
        /// </summary>
        public string N90
        {
            get { return GetValue<string>("N90"); }
            set { Add<string>("N90", value); }
        }
        /// <summary>
        /// N50 probability.
        /// </summary>
        public string N50
        {
            get { return GetValue<string>("N50"); }
            set { Add<string>("N50", value); }
        }

        /// <summary>
        /// N10 probability.
        /// </summary>
        public string N10
        {
            get { return GetValue<string>("N10"); }
            set { Add<string>("N10", value); }
        }
        /// <summary>
        /// N5 probability.
        /// </summary>
        public string N5
        {
            get { return GetValue<string>("N5"); }
            set { Add<string>("N5", value); }
        }
        /// <summary>
        /// N1 probability.
        /// </summary>
        public string N1
        {
            get { return GetValue<string>("N1"); }
            set { Add<string>("N1", value); }
        }
        /// <summary>
        /// Tract ID.
        /// </summary>
        public string TractID
        {
            get { return GetValue<string>("TractID"); }
            set { Add<string>("TractID", value); }
        }
        /// <summary>
        /// Extension folder name for negative binomial.
        /// </summary>
        public string NegBinomialExtensionFolder
        {
            get { return GetValue<string>("NegBinomialExtensionFolder"); }
            set { Add<string>("NegBinomialExtensionFolder", value); }
        }
        /// <summary>
        /// Extension folder name for Mark3.
        /// </summary>
        public string Mark3ExtensionFolder
        {
            get { return GetValue<string>("Mark3ExtensionFolder"); }
            set { Add<string>("Mark3ExtensionFolder", value); }
        }
        /// <summary>
        /// Extension folder name for Custom.
        /// </summary>
        public string CustomExtensionFolder
        {
            get { return GetValue<string>("CustomExtensionFolder"); }
            set { Add<string>("CustomExtensionFolder", value); }
        }

        public string LastRunTract
        {
            get { return GetValue<string>("LastRunTract"); }
            set { Add<string>("LastRunTract", value); }
        }
    }

    /// <summary>
    /// Output parameters for Undiscovered Deposits tool.
    /// - PlotImage
    /// - Summary
    /// - PlotImagePath
    /// -EstRationaleTXT
    /// -NDepositsPmf
    /// </summary>
    public class UndiscoveredDepositsResult : ToolResult
    {
        /// <summary>
        /// Result plot image.
        /// </summary>
        public string PlotImage
        {
            get { return GetValue<string>("PlotImage"); }
            internal set { Add<string>("PlotImage", value); }
        }
        /// <summary>
        /// Result summary.
        /// </summary>
        public string Summary
        {
            get { return GetValue<string>("Summary"); }
            internal set { Add<string>("Summary", value); }
        }
        /// <summary>
        /// NDepositsPmf file (Number of undiscovered deposits).
        /// </summary>
        public string NDepositsPmf
        {
            get { return GetValue<string>("NDepositsPmf"); }
            internal set { Add<string>("NdepositsPmf", value); }
        }
        /// <summary>
        /// Estimation rationale text file.
        /// </summary>
        public string EstRationaleTXT
        {
            get { return GetValue<string>("estRationaleTXT"); }
            set { Add<string>("estRationaleTXT", value); }
        }
    }

    /// <summary>
    /// Undiscovered Deposits excecution.
    /// </summary>
    public class UndiscoveredDepositsTool : ITool
    {
        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();

        /// <summary>
        /// Excecutes tool and returns results as parameters
        /// </summary>
        /// <param name="inputParams">Input parameters</param>
        /// <returns>Result as UndiscoveredDepositsResult</returns>
        public ToolResult Execute(ToolParameters inputParams)
        {
            var input = inputParams as UndiscoveredDepositsInputParams;
            UndiscoveredDepositsResult result = new UndiscoveredDepositsResult();
            string usedMethod = "";
            string pathToCsv = "";
            string pathToTxt = "";
            string undiscDepFolder = Path.Combine(inputParams.Env.RootPath, "UndiscDep");
            string projectFolder = Path.Combine(undiscDepFolder, input.TractID);
            if (!Directory.Exists(projectFolder))
            {
                Directory.CreateDirectory(projectFolder);
            }
            //Create estimation based on input data and method
            try
            {
                if (input.Method == "Negative")
                {
                    projectFolder = Path.Combine(projectFolder, "NegativeBinomial", input.NegBinomialExtensionFolder);
                    if (!Directory.Exists(projectFolder))
                    {
                        Directory.CreateDirectory(projectFolder);
                    }
                    DirectoryInfo di = new DirectoryInfo(projectFolder); // clear
                    foreach (FileInfo file in di.GetFiles())
                    {
                        if (file.Name != Path.Combine("plot.jpeg"))
                        {
                            file.Delete();
                        }
                    }
                    usedMethod = "NegBinomial";
                    pathToCsv = projectFolder + @"\nDepEst.csv";
                    CreateEstimationCsv(pathToCsv, input.DepositsNegativeCSV);
                    pathToTxt = projectFolder + @"\EstRationale.txt";
                    CreateRationaleTxt(pathToTxt, input.EstRationaleTXT);
                }
                else if (input.Method == "Custom")
                {
                    projectFolder = Path.Combine(projectFolder, "Custom", input.CustomExtensionFolder);
                    if (!Directory.Exists(projectFolder))
                    {
                        Directory.CreateDirectory(projectFolder);
                    }
                    DirectoryInfo di = new DirectoryInfo(projectFolder);
                    foreach (FileInfo file in di.GetFiles())
                    {
                        if (file.Name != Path.Combine("plot.jpeg"))
                        {
                            file.Delete();
                        }
                    }
                    usedMethod = "CustomMark4";
                    pathToCsv = projectFolder + @"\nDepEstCustom.csv";
                    CreateEstimationCsv(pathToCsv, input.DepositsCustomCSV);
                    pathToTxt = projectFolder + @"\EstRationale.txt";
                    CreateRationaleTxt(pathToTxt, input.CustomEstRationaleTXT);
                }
                else if (input.Method == "Middle")
                {
                    projectFolder = Path.Combine(projectFolder, "MARK3", input.Mark3ExtensionFolder);
                    if (!Directory.Exists(projectFolder))
                    {
                        Directory.CreateDirectory(projectFolder);
                    }
                    DirectoryInfo di = new DirectoryInfo(projectFolder);
                    foreach (FileInfo file in di.GetFiles())
                    {
                        if (file.Name != Path.Combine("plot.jpeg"))
                        {
                            file.Delete();
                        }
                    }
                    usedMethod = "CustomMark3";
                    pathToCsv = projectFolder + @"\nDepEstMiddle.csv";
                    string customEstimations = "";// "N90,N50,N10,N5,N1\n";
                    customEstimations += input.N90 + "\n" + input.N50 + "\n" + input.N10 + "\n" + input.N5 + "\n" + input.N1 + "\n";
                    CreateEstimationCsv(pathToCsv, customEstimations);
                    pathToTxt = projectFolder + @"\EstRationale.txt";
                    CreateRationaleTxt(pathToTxt, input.Mark3EstRationaleTXT);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Failed to create estimation: " + ex);
            }
            input.Save(Path.Combine(undiscDepFolder, "undiscovered_deposits_input_params.json"));
            try
            {
                var path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                var rCodeFilePath = path + "scripts/UndiscoveredDepositsWrapper.R";
                string rScriptExecutablePath = inputParams.Env.RPath;
                string procResult = string.Empty;
                var info = new ProcessStartInfo();
                info.FileName = rScriptExecutablePath;

                info.WorkingDirectory = path + "scripts/";
                string tmpSummary = Path.Combine(projectFolder, "summary.txt");
                string describ = "describ";
                string tractName = new DirectoryInfo(projectFolder).Name;
                //string outputCsv = Path.Combine(projectFolder, tractName + input.TractID + ".csv");
                string outputCsv = Path.Combine(projectFolder, "TractPmf.csv");
                string tract = input.TractID;

                info.Arguments = "\"" + rCodeFilePath + "\" \"" + usedMethod + "\" \"" + pathToCsv + "\" \"" + tmpSummary + "\" \"" + describ + "\" \"" + projectFolder + "\" \"" + outputCsv + "\" \"" + tract;

                info.RedirectStandardInput = false;
                info.RedirectStandardOutput = true;
                info.RedirectStandardError = true;
                info.UseShellExecute = false;
                info.CreateNoWindow = true;

                using (var proc = new Process())
                {
                    proc.StartInfo = info;
                    proc.Start();
                    using (StreamReader errorReader = proc.StandardError)
                    {
                        //StreamReader myStreamReader = proc.StandardOutput; TAGGED: no usage?
                        string errors = errorReader.ReadToEnd();
                        //string stream = myStreamReader.ReadToEnd(); TAGGED: no usage?
                        procResult = proc.StandardOutput.ReadToEnd();
                        proc.Close();
                        logger.Error("Errors:" + errors);
                        if (errors.Length > 1 && errors.ToLower().Contains("error"))  //Don't throw exception over warnings or empty error message.
                        {
                            logger.Error(errors);
                            throw new Exception("R script execution failed. Check log file for details");
                        }
                    }
                    result.Summary = File.ReadAllText(Path.Combine(projectFolder, "summary.txt"));
                    result.PlotImage = Path.Combine(projectFolder, "plot.jpeg");
                    result.NDepositsPmf = Path.Combine(projectFolder, "oPmf.rds");
                    result.EstRationaleTXT = Path.Combine(projectFolder, "EstRationale.txt");
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Failed to run Undiscovered deposits tool: " + ex);
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

        /// <summary>
        /// Create estimate rationale textfile.
        /// </summary>
        private void CreateRationaleTxt(string pathToTXT, string estimatedRationale)
        {
            File.WriteAllText(pathToTXT, estimatedRationale);
        }
    }
}
