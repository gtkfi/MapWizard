using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RDotNet;
using System.Diagnostics;
using NLog;

namespace MapWizard.Tools
{
    /// <summary>
    /// input parameters for Deposit density tool
    /// - DepositTypeId
    /// - MedianTonnage (tons)
    /// - AreaOfTrack (square kilometers)
    /// - NumbOfKnownDeposits
    /// - ExistingDepositDensityModelID: General / WMS / PodiformCr / PorCu
    /// - CSVPath, path to input csv -file
    /// </summary>
    public class DepositDensityInputParams : ToolParameters
    {
        /// <summary>
        /// Deposit type
        /// </summary>
        public string DepositTypeId
        {
            get { return GetValue<string>("DepositTypeId"); }
            set { Add<string>("DepositTypeId", value); }
        }
        /// <summary>
        /// Median tonnage of the deposit type of the assessed deposit type in million metric tons. This is only relevant for the General model.
        /// </summary>
        public string MedianTonnage
        {
            get { return GetValue<string>("MedianTonnage"); }
            set { Add<string>("MedianTonnage", value); }
        }
        /// <summary>
        /// Surface area of the permissive tract in square kilometers. 
        /// </summary>
        public string AreaOfTrack
        {
            get { return GetValue<string>("AreaOfTrack"); }
            set { Add<string>("AreaOfTrack", value); }
        }
        /// <summary>
        /// Number of known deposits.
        /// </summary>
        public string NumbOfKnownDeposits
        {
            get { return GetValue<string>("NumbOfKnownDeposits"); }
            set { Add<string>("NumbOfKnownDeposits", value); }
        }
        /// <summary>
        /// Id of existing deposit density model.
        /// </summary>
        public string ExistingDepositDensityModelID
        {
            get { return GetValue<string>("ExistingDepositDensityModelID"); }
            set { Add<string>("ExistingDepositDensityModelID", value); }
        }
        /// <summary>
        /// Path of csv file for general calculation.
        /// </summary>
        public string CSVPath
        {
            get { return GetValue<string>("GeneralCSVPath"); }
            set { Add<string>("GeneralCSVPath", value); }
        }

    }

    /// <summary>
    /// The N90 value gives the estimated number of undiscovered deposits at a probability of 0.90. 
    /// This probability is often called an “elicitation percentile of 90” among assessment geoscientists.
    /// The N50 and N10 values are similar and list the estimated number of undiscovered deposits at elicitation percentiles of 50 and 10.
    /// Output parameters for Deposit density tool:
    /// - Note (if estimates cannot be calulated, note is written here)
    /// </summary>
    public class DepositDensityResult : ToolResult
    {
        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();

        /// <summary>
        /// N10
        /// </summary>
        public string N10
        {
            get { return GetValue<string>("N10"); }
            internal set { Add<string>("N10", value); }
        }
        /// <summary>
        /// N50
        /// </summary>
        public string N50
        {
            get { return GetValue<string>("N50"); }
            internal set { Add<string>("N50", value); }
        }
        /// <summary>
        /// N90
        /// </summary>
        public string N90
        {
            get { return GetValue<string>("N90"); }
            internal set { Add<string>("N90", value); }
        }
        /// <summary>
        /// NExp
        /// </summary>
        public string NExp
        {
            get { return GetValue<string>("NExp"); }
            internal set { Add<string>("NExp", value); }
        }
        /// <summary>
        /// Bibiolgraphic info.
        /// </summary>
        public string BiblInfo
        {
            get { return GetValue<string>("BiblInfo"); }
            internal set { Add<string>("BiblInfo", value); }
        }
        /// <summary>
        /// Path for result plot image: A jpeg file containing a plot of the global model used; data points and regression and prediction lines.
        /// </summary>
        public string PlotImagePath
        {
            get { return GetValue<string>("PlotImagePath"); }
            internal set { Add<string>("PlotImagePath", value); }
        }
        /// <summary>
        /// Notes. If estimates cannot be calulated, note is written here.
        /// </summary>
        public string Note
        {
            get { return GetValue<string>("Note"); }
            internal set { Add<string>("Note", value); }
        }

    }

    /// <summary>
    /// DepositDensityTool excecution.
    /// </summary>
    public class DepositDensityTool : ITool
    {

        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();
        //Input params
        private double Area;
        private double MedTons;
        private double NKnown = 0;
        private string modelId;

        //Input params from csv -files
        private double a;
        private double b;
        private double c;
        private double t10n; //t10,N-3
        private double Syx; //sy|x
        private double N;
        private double MeanLogArea;
        private double MeanLogMedTons;
        private double sLogArea;
        private double sLogMedTons;
        private string biblInfo;

        //calculations
        private double logN50;
        private double N50;
        private double logN10;
        private double N10;
        private double logN90;
        private double N90;
        private double varN;
        private double logNexp;
        private double NExp;

        /// <summary>
        /// Excecutes tool and returns results as parameters
        /// </summary>
        /// <param name="inputParams">Input parameters</param>
        /// <returns>Result as DepositDensityResult</returns>
        public ToolResult Execute(ToolParameters inputParams)
        {

            DepositDensityInputParams input = inputParams as DepositDensityInputParams;
            string outputFolder = input.Env.RootPath + @"\DensModel\";

            if (!Directory.Exists(outputFolder))
            {
                Directory.CreateDirectory(outputFolder);
            }
            input.Save(outputFolder + "deposit_density_input_params.json");
            modelId = input.ExistingDepositDensityModelID;
            Area = Convert.ToDouble(input.AreaOfTrack);
            MedTons = Convert.ToDouble(input.MedianTonnage);
            NKnown = input.NumbOfKnownDeposits != "" ? Convert.ToDouble(input.NumbOfKnownDeposits) : 0;
            DepositDensityResult result = new DepositDensityResult();
            readinputParamsFromCSV(input.CSVPath);

            //Calculate values based as which deposit type selected
            if (input.ExistingDepositDensityModelID == "General")
            {
                result = GeneralCalculation();
            }
            else
            {
                result = DepositTypeCalculation(input.ExistingDepositDensityModelID);
            }
            return result;
        }

        /// <summary>
        /// Calculate deposit density (General)
        /// </summary>
        /// <returns>Result as DepositDensityResult</returns>
        private DepositDensityResult GeneralCalculation()
        {
            DepositDensityResult result = new DepositDensityResult();
            string path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");

            string GeneralPlot = Path.Combine(path, "scripts/DepositDensity/GeneralPlot.jpeg");
            try
            {
                //N50
                logN50 = a + b * Math.Log10(Area) + c * Math.Log10(MedTons);
                N50 = Math.Pow(10, logN50);

                //N10
                logN10 = Math.Log10(N50) + t10n * Syx * Math.Sqrt(1 + 1 / N + Math.Pow(2, (MeanLogArea - Math.Log10(Area)) * Math.Pow(2, MeanLogMedTons - Math.Log10(MedTons))) / ((N - 1) * sLogArea * sLogMedTons));
                N10 = Math.Pow(10, logN10);

                //N90
                double mlal = Math.Pow((MeanLogArea - Math.Log10(Area)), 2);
                double mlmtl = Math.Pow((MeanLogMedTons - Math.Log10(MedTons)), 2);
                logN90 = Math.Log10(N50) - t10n * Syx * Math.Sqrt(1 + 1 / N + (mlal * mlmtl) / ((N - 1) * sLogArea * sLogMedTons));
                N90 = Math.Pow(10, logN90);

                //Nexp
                varN = Math.Pow(((Math.Log10(N10) - Math.Log10(N50)) / t10n), 2);
                logNexp = Math.Log10(N50) + (varN) / 2;
                NExp = Math.Pow(10, logNexp);

                if (NKnown > NExp)
                {
                    result.N50 = " - ";
                    result.N10 = " - ";
                    result.N90 = " - ";
                    result.NExp = Math.Round(NExp).ToString();
                    result.BiblInfo = biblInfo;
                    result.PlotImagePath = GeneralPlot;
                    result.Note = "The number of undiscovered deposits cannot be estimated using the global deposit density model. The number of known deposits is larger than the expected number of deposits estimated by the global deposit density model for a permissive tract of the given size. This suggests that there might be a problem with the number of known deposits.";
                    return result;
                }
                //if NKnown > 0, values are calculated again NExp must be calculated before this can be done, so values must be calculated again with NKnown value
                if (NKnown > 0)
                {
                    logN50 = Math.Log10(NExp - NKnown) - (varN) / 2;
                    N50 = Math.Pow(10, logN50);
                    //N10
                    logN10 = Math.Log10(N50) + t10n * Syx * Math.Sqrt(1 + 1 / N + Math.Pow(2, (MeanLogArea - Math.Log10(Area)) * Math.Pow(2, MeanLogMedTons - Math.Log10(MedTons))) / ((N - 1) * sLogArea * sLogMedTons));
                    N10 = Math.Pow(10, logN10);
                    //N90
                    mlal = Math.Pow((MeanLogArea - Math.Log10(Area)), 2);
                    mlmtl = Math.Pow((MeanLogMedTons - Math.Log10(MedTons)), 2);
                    logN90 = Math.Log10(N50) - t10n * Syx * Math.Sqrt(1 + 1 / N + (mlal * mlmtl) / ((N - 1) * sLogArea * sLogMedTons));
                    N90 = Math.Pow(10, logN90);
                    //Nexp
                    varN = Math.Pow(((Math.Log10(N10) - Math.Log10(N50)) / t10n), 2);
                    logNexp = Math.Log10(N50) + (varN) / 2;
                    NExp = Math.Pow(10, logNexp);
                }

                //Add values to result.
                result.N50 = Math.Round(N50).ToString();
                result.N10 = Math.Round(N10).ToString();
                result.N90 = Math.Round(N90).ToString();
                result.NExp = Math.Round(NExp).ToString();
                result.BiblInfo = biblInfo;
                result.PlotImagePath = GeneralPlot;
                createResultFile(result, "General", GeneralPlot);
            }
            catch (Exception ex)
            {
                throw new Exception("Error in general type calculation:" + ex);
            }
            return result;
        }

        /// <summary>
        /// Calculate deposit density (Type PodiformCr, VSM, or PorCu).
        /// </summary>
        /// <param name="DepositDensityModelID">Deposit density model Id</param>
        /// <returns>Result as DepositDensityResult</returns>
        private DepositDensityResult DepositTypeCalculation(string DepositDensityModelID)
        {
            try
            {
                DepositDensityResult result = new DepositDensityResult();

                string path = System.AppDomain.CurrentDomain.BaseDirectory.Replace(@"\", @"/");
                string plot = path + "/scripts/DepositDensity/";

                switch (DepositDensityModelID)
                {
                    case "PodiformCr":
                        plot += "Podiformplot.jpeg";
                        break;
                    case "VMS":
                        plot += "VMSplot.jpeg";
                        break;
                    case "PorCu":
                        plot += "porphyryPlot.jpeg";
                        break;
                    default:
                        break;
                }

                //N50
                logN50 = a + b * Math.Log10(Area);
                N50 = Math.Pow(10, logN50);

                //N10
                logN10 = Math.Log10(N50) + t10n * Syx * Math.Sqrt(1 + 1 / N + Math.Pow((MeanLogArea - Math.Log10(Area)), 2) / ((N - 1) * sLogArea));
                N10 = Math.Pow(10, logN10);

                //N90
                double mlal = Math.Pow((MeanLogArea - Math.Log10(Area)), 2);
                double mlmtl = Math.Pow((MeanLogMedTons - Math.Log10(MedTons)), 2);
                logN90 = Math.Log10(N50) - t10n * Syx * Math.Sqrt(1 + 1 / N + Math.Pow(MeanLogArea - Math.Log10(Area), 2) / ((N - 1) * sLogArea));
                N90 = Math.Pow(10, logN90);

                //Nexp
                varN = Math.Pow(((Math.Log10(N10) - Math.Log10(N50)) / t10n), 2);
                logNexp = Math.Log10(N50) + (varN) / 2;
                NExp = Math.Pow(10, logNexp);

                if (NKnown > NExp)
                {
                    result.N50 = " - ";
                    result.N10 = " - ";
                    result.N90 = " - ";
                    result.NExp = Math.Round(NExp).ToString();
                    result.BiblInfo = biblInfo;
                    result.PlotImagePath = plot;
                    result.Note = "The number of undiscovered deposits cannot be estimated using the global deposit density model. The number of known deposits is larger than the expected number of deposits estimated by the global deposit density model for a permissive tract of the given size. This suggests that there might be a problem with the number of known deposits.";
                    return result;
                }

                //if NKnown > 0, values are calculated again 
                if (NKnown > 0)
                {
                    logN50 = Math.Log10(NExp - NKnown) - (varN) / 2;
                    N50 = Math.Pow(10, logN50);
                    //N10
                    logN10 = Math.Log10(N50) + t10n * Syx * Math.Sqrt(1 + 1 / N + Math.Pow((MeanLogArea - Math.Log10(Area)), 2) / ((N - 1) * sLogArea));
                    N10 = Math.Pow(10, logN10);
                    //N90
                    mlal = Math.Pow((MeanLogArea - Math.Log10(Area)), 2);
                    mlmtl = Math.Pow((MeanLogMedTons - Math.Log10(MedTons)), 2);
                    logN90 = Math.Log10(N50) - t10n * Syx * Math.Sqrt(1 + 1 / N + Math.Pow(MeanLogArea - Math.Log10(Area), 2) / ((N - 1) * sLogArea));
                    N90 = Math.Pow(10, logN90);
                    //Nexp
                    varN = Math.Pow(((Math.Log10(N10) - Math.Log10(N50)) / t10n), 2);
                    logNexp = Math.Log10(N50) + (varN) / 2;
                    NExp = Math.Pow(10, logNexp);
                }

                //Add values to result
                result.N50 = Math.Round(N50).ToString();
                result.N10 = Math.Round(N10).ToString();
                result.N90 = Math.Round(N90).ToString();
                result.NExp = Math.Round(NExp).ToString();
                result.BiblInfo = biblInfo;
                result.PlotImagePath = plot;
                createResultFile(result, DepositDensityModelID, plot);
                return result;
            }
            catch (Exception ex)
            {
                throw new Exception("Error on deposit type calculation: " + ex);
            }

        }

        /// <summary>
        /// Method to create the result file.
        /// </summary>
        /// <param name="result">Result as DepositDensityResult</param>
        /// <param name="ModelID">Model Id</param>
        /// <param name="plot">Result plot image</param>
        private void createResultFile(DepositDensityResult result, string ModelID, string plot)
        {
            try
            {
                string outputFolder = Path.Combine(result.Env.RootPath, "DensModel");

                if (!System.IO.Directory.Exists(outputFolder))
                {
                    System.IO.Directory.CreateDirectory(outputFolder);
                }

                string strFilePath = Path.Combine(outputFolder, ModelID + "_results_" + DateTime.Now.ToFileTime() + ".txt");
                StringBuilder sbOutput = new StringBuilder();
                sbOutput.AppendLine("N10: " + result.N10);
                sbOutput.AppendLine("N50: " + result.N50);
                sbOutput.AppendLine("N90: " + result.N90);
                sbOutput.AppendLine("NExp: " + result.NExp);
                sbOutput.AppendLine("BiblInfo: " + result.BiblInfo);
                File.WriteAllText(strFilePath, sbOutput.ToString());

                //Copy plot image to result folder
                File.Copy(plot, Path.Combine(outputFolder, "plot_" + ModelID + ".jpeg"), true);
            }
            catch (Exception ex)
            {
                logger.Trace(ex + "Failed to create result File");
                throw new Exception(ex + "Failed to create result File");
            }
        }

        /// <summary>
        /// Method to read input parameters from CSV file.
        /// </summary>
        /// <param name="CSVPath">CSV path</param>
        private void readinputParamsFromCSV(string CSVPath)
        {
            try
            {
                using (var reader = new StreamReader(CSVPath))
                {
                    while (!reader.EndOfStream)
                    {
                        var line = reader.ReadLine();
                        line = reader.ReadLine();
                        var values = line.Split(';');
                        a = Convert.ToDouble(values[0]);
                        b = Convert.ToDouble(values[1]);
                        c = values[2] != "" ? Convert.ToDouble(values[2]) : 0;

                        t10n = Convert.ToDouble(values[3]);
                        Syx = Convert.ToDouble(values[4]);
                        N = Convert.ToDouble(values[5]);
                        MeanLogArea = Convert.ToDouble(values[6]);
                        MeanLogMedTons = values[7] != "" ? Convert.ToDouble(values[7]) : 0;
                        sLogArea = Convert.ToDouble(values[8]);
                        sLogMedTons = values[9] != "" ? Convert.ToDouble(values[9]) : 0;
                        biblInfo = Convert.ToString(values[10]);
                    }
                }

            }
            catch (Exception ex)
            {
                throw new Exception("Failed to read input parameters: " + ex);
            }
        }
    }
}
