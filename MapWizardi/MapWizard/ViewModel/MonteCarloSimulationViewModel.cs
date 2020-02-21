using System;
using System.Threading.Tasks;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using MapWizard.Model;
using MapWizard.Tools;
using NLog;
using MapWizard.Tools.Settings;
using MapWizard.Service;
using System.IO;
using System.Diagnostics;
using System.ComponentModel;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// This class contains properties that the MonteCarloView can data bind to.
    /// <para>
    /// Use the <strong>mvvminpc</strong> snippet to add bindable properties to this ViewModel.
    /// </para>
    /// <para>
    /// You can also use Blend to data bind with the tool's support.
    /// </para>
    /// <para>
    /// See http://www.galasoft.ch/mvvm
    /// </para>
    /// </summary>
    public class MonteCarloSimulationViewModel : ViewModelBase, INotifyPropertyChanged
    {
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private MonteCarloSimulationModel model;
        private MonteCarloSimulationResultModel result;
        private bool isBusy;
        private bool useModelName;
        private string lastRunDate;
        private int runStatus;

        /// <summary>
        /// Initializes an instance of MonteCarloSimulationViewModel Class.
        /// </summary>
        /// <param name="logger">Logging for the MapWizard.</param>
        /// <param name="dialogService">Service for using dialogs and notifications.</param>
        /// <param name="settingsService">Service for using and editing settings.</param>
        public MonteCarloSimulationViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            lastRunDate = "Last Run: Never";
            runStatus = 2;
            useModelName = false;
            result = new MonteCarloSimulationResultModel();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            SelectGradeObjectCommand = new RelayCommand(SelectGradeObject, CanRunTool);
            SelectTonnageObjectCommand = new RelayCommand(SelectTonnageObject, CanRunTool);
            SelectNDepositsPmfObjectCommand = new RelayCommand(SelectNDepositsPmfObject, CanRunTool);
            OpenResultExcelObjectCommand = new RelayCommand(OpenResultExcelObject, CanRunTool);
            MonteCarloSimulationInputParams inputParams = new MonteCarloSimulationInputParams();
            string projectFolder = Path.Combine(settingsService.RootPath, "MCSim");
            if (!Directory.Exists(projectFolder))
            {
                Directory.CreateDirectory(projectFolder);
            }
            string param_json = Path.Combine(projectFolder, "monte_carlo_simulation_input_params.json");
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    Model = new MonteCarloSimulationModel
                    {
                        GradePdf = inputParams.GradePdf,
                        TonnagePdf = inputParams.TonnagePdf,
                        NDepositsPmf = inputParams.NDepositsPmf
                    };
                    if (String.IsNullOrEmpty(Model.GradePdf))
                    {
                        Model.GradePdf = "Please select Grade object";
                    }
                    if (String.IsNullOrEmpty(Model.TonnagePdf))
                    {
                        Model.TonnagePdf = "Please select Tonnage object";
                    }
                    if (String.IsNullOrEmpty(Model.NDepositsPmf))
                    {
                        Model.NDepositsPmf = "Please select NDepositsPmf object";
                    }
                    else
                    {
                        Model = new MonteCarloSimulationModel
                        {
                            GradePdf = inputParams.GradePdf,
                            TonnagePdf = inputParams.TonnagePdf,
                            NDepositsPmf = inputParams.NDepositsPmf
                        };
                    }
                }
                catch (Exception ex)
                {
                    Model = new MonteCarloSimulationModel
                    {
                        GradePdf = "Please select Grade object",
                        TonnagePdf = "Please select Tonnage object",
                        NDepositsPmf = "Please select NDepositsPmf object",
                        ExtensionFolder = ""
                    };
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Monte Carlo Simulation tool's inputs correctly.", "Error");
                }
            }
            else
            {
                Model = new MonteCarloSimulationModel
                {
                    GradePdf = "Please select Grade object",
                    TonnagePdf = "Please select Tonnage object",
                    NDepositsPmf = "Please select NDepositsPmf object",
                    ExtensionFolder = ""
                };
            }
            if (Directory.GetFiles(projectFolder).Length != 0)
            {
                LoadResults();
            }
            var lastRunFile = Path.Combine(settingsService.RootPath, "MCSim", "monte_carlo_simulation_last_run.lastrun");
            if (File.Exists(lastRunFile))
            {
                LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
            }
        }

        /// <summary>
        /// Load results of the last run.
        /// </summary>
        private void LoadResults()
        {
            var projectFolder = Path.Combine(settingsService.RootPath, "MCSim");
            var SummaryTotalTonnage = Path.Combine(projectFolder, "summary.txt");
            var SimulatedDepositsCSV = Path.Combine(projectFolder, "Tract_05_Sim_EF.csv"); // TAGGED: Change the naming of the file.
            var TotalTonPdf = Path.Combine(projectFolder, "plot.jpeg");
            var MarginalPdf = Path.Combine(projectFolder, "plotMarginals.jpeg");
            RunStatus = 1; // This will be changed into 0 if something goes wrong.
            try
            {
                if (File.Exists(SummaryTotalTonnage))
                {
                    Result.SummaryTotalTonnage = File.ReadAllText(SummaryTotalTonnage);
                }
                else
                {
                    Result.SummaryTotalTonnage = null;
                    RunStatus = 0;
                }
                //  TAGGED: Doesn't check all the files.
                if (File.Exists(SimulatedDepositsCSV))
                {
                    Result.SimulatedDepositsCSV = SimulatedDepositsCSV;
                }
                else
                {
                    Result.SimulatedDepositsCSV = null;
                    RunStatus = 0;
                }

                if (File.Exists(TotalTonPdf))
                {
                    Result.TotalTonPdf = TotalTonPdf;
                    Result.TotalTonPdfBitMap = BitmapFromUri(TotalTonPdf);
                }
                else
                {
                    Result.TotalTonPdf = null;
                    RunStatus = 0;
                }
                if (File.Exists(MarginalPdf))
                {
                    Result.MarginalPdf = MarginalPdf;
                    Result.MarginalPdfBitMap = BitmapFromUri(MarginalPdf);
                }
                else
                {
                    Result.MarginalPdf = null;
                    RunStatus = 0;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex + " Could not load results files");
                RunStatus = 0;
            }
        }

        /// <summary>
        /// Run tool command.
        /// </summary>
        /// @return Command.
        public RelayCommand RunToolCommand { get; }

        /// <summary>
        /// Select Grade Object command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectGradeObjectCommand { get; }

        /// <summary>
        /// Select Tonnage Object command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectTonnageObjectCommand { get; }

        /// <summary>
        /// Select NDepositsPmf Object command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectNDepositsPmfObjectCommand { get; }

        /// <summary>
        /// Open result Excel file -command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenResultExcelObjectCommand { get; }

        /// <summary>
        /// Monte Carlo Simulation model.
        /// </summary>
        /// <returns>Model.</returns>
        public MonteCarloSimulationModel Model
        {
            get
            {
                return model;
            }
            set
            {
                model = value;
                RaisePropertyChanged("MonteCarloSimulationModel");
            }
        }

        /// <summary>
        /// Deposit Density result model.
        /// </summary>
        /// <returns>Result model.</returns>
        public MonteCarloSimulationResultModel Result
        {
            get
            {
                return result;
            }
            set
            {
                result = value;
                RaisePropertyChanged("MonteCarloSimulationResultModel");
            }
        }

        /// <summary>
        /// Is busy?.
        /// </summary>
        /// <returns>Boolean representing the state.</returns>
        public bool IsBusy
        {
            get { return isBusy; }
            set
            {
                if (isBusy == value) return;
                isBusy = value;
                RaisePropertyChanged(() => IsBusy);
                RunToolCommand.RaiseCanExecuteChanged();
                SelectGradeObjectCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Run tool with user input.
        /// </summary>
        private async void RunTool()
        {

            Result.TotalTonPdf = null;
            Result.MarginalPdf = null;
            logger.Info("-->{0}", this.GetType().Name);
            if (UseModelName == false)
            {
                Model.ExtensionFolder = "";
            }
            var rootPath = Path.Combine(settingsService.RootPath, "MCSim");
            try
            {
                DirectoryInfo rootDirectory = new DirectoryInfo(rootPath);
                //Clear the folder from all the old files.
                foreach (FileInfo file in rootDirectory.GetFiles())
                {
                    if (file.Name != "monte_carlo_simulation_last_run.lastrun")
                    {
                        file.Delete();
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to clear output folder");
                dialogService.ShowNotification("Failed to clear output folder", "Error");
                RunStatus = 0;
                return;
            }
            // 1. Collect input parameters
            MonteCarloSimulationInputParams input = new MonteCarloSimulationInputParams
            {

                GradePdf = Model.GradePdf,
                TonnagePdf = Model.TonnagePdf,
                NDepositsPmf = Model.NDepositsPmf,
                ExtensionFolder = Model.ExtensionFolder
            };
            // 2. Execute tool
            MonteCarloSimulationResult ddResult = default(MonteCarloSimulationResult);
            IsBusy = true;
            try
            {
                await Task.Run(() =>
                {
                    MonteCarloSimulationTool tool = new MonteCarloSimulationTool();
                    ddResult = tool.Execute(input) as MonteCarloSimulationResult;
                    Result.SummaryTotalTonnage = ddResult.SummaryTotalTonnage;
                    Result.TotalTonPdf = ddResult.TotalTonPdf;
                    Result.MarginalPdf = ddResult.MarginalPdf;
                    Result.SimulatedDepositsCSV = ddResult.SimulatedDepositsCSV;
                    Result.TotalTonPdfBitMap = BitmapFromUri(Result.TotalTonPdf);
                    Result.MarginalPdfBitMap = BitmapFromUri(Result.MarginalPdf);
                });
                if (Model.ExtensionFolder != "" && Model.ExtensionFolder != null)
                {
                    DirectoryInfo extDirectory = new DirectoryInfo(Path.Combine(rootPath, Model.ExtensionFolder));
                    foreach (FileInfo file2 in extDirectory.GetFiles()) // Select files from selected model root folder.
                    {
                        var destPath = Path.Combine(rootPath, file2.Name);
                        var sourcePath = Path.Combine(Path.Combine(rootPath, Model.ExtensionFolder), file2.Name);
                        File.Copy(sourcePath, destPath, true); // Copy files to new Root folder.
                    }
                }
                string lastRunFile = Path.Combine(Path.Combine(settingsService.RootPath, "MCSim", "monte_carlo_simulation_last_run.lastrun"));
                File.Create(lastRunFile);
                dialogService.ShowNotification("Monte Carlo simulation tool completed successfully", "Success");
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to execute REngine() script");
                dialogService.ShowNotification("Run failed. Check output for details", "Error");
                RunStatus = 0;
            }
            finally
            {
                IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Select grade object.
        /// </summary>
        private void SelectGradeObject()
        {
            try
            {
                string objectFile = dialogService.OpenFileDialog(Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult"), "", true, true);
                if (!string.IsNullOrEmpty(objectFile))
                {
                    Model.GradePdf = objectFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
        }

        /// <summary>
        /// Select tonange object.
        /// </summary>
        private void SelectTonnageObject()
        {
            try
            {
                string objectFile = dialogService.OpenFileDialog(Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult"), "", true, true);
                if (!string.IsNullOrEmpty(objectFile))
                {
                    Model.TonnagePdf = objectFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
        }

        /// <summary>
        /// Select undiscovered deposits result object.
        /// </summary>
        private void SelectNDepositsPmfObject()
        {
            try
            {
                string objectFile = dialogService.OpenFileDialog(Path.Combine(settingsService.RootPath, "UndiscDep", "SelectedResult"), "", true, true);
                if (!string.IsNullOrEmpty(objectFile))
                {
                    Model.NDepositsPmf = objectFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
        }

        /// <summary>
        /// Open result file in default system program associated with CSV files.
        /// </summary>
        private void OpenResultExcelObject()
        {
            try
            {
                Process.Start(result.SimulatedDepositsCSV);
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to open csv file");
                dialogService.ShowNotification("Failed to open csv file. Check output for details", "Error");
            }
        }

        /// <summary>
        /// Whether to save result in separate folder.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool UseModelName
        {
            get { return useModelName; }
            set
            {
                if (value == useModelName) return;
                useModelName = value;
                RaisePropertyChanged("UseModelName");
            }
        }

        /// <summary>
        /// Check if tool can be executed.
        /// </summary>
        /// <returns>Boolean representing the state.</returns>
        private bool CanRunTool()
        {
            return !IsBusy;
        }

        /// <summary>
        /// Run status.
        /// </summary>
        /// @return Boolean representing the state.
        public int RunStatus
        {
            get { return runStatus; }
            set
            {
                if (value == runStatus) return;
                runStatus = value;
                RaisePropertyChanged("RunStatus");
            }
        }

        /// <summary>
        /// Date and time of last run.
        /// </summary>
        /// @return Date.
        public string LastRunDate
        {
            get { return lastRunDate; }
            set
            {
                if (value == lastRunDate) return;
                lastRunDate = value;
                RaisePropertyChanged("LastRunDate");
            }
        }

        /// <summary>
        /// Method to create bitmap from image. Prevents file locks from binding in XAML.
        /// </summary>
        /// <param name="source">Path for bitmap.</param>
        /// <returns>Bitmap.</returns>
        private ImageSource BitmapFromUri(string source)
        {
            try
            {
                Uri sourceUri = new Uri(source);
                var bitmap = new BitmapImage();
                bitmap.BeginInit();
                bitmap.UriSource = sourceUri;
                bitmap.CreateOptions = BitmapCreateOptions.IgnoreImageCache; //Image cache must be ignored, to be able to update the images.
                bitmap.CacheOption = BitmapCacheOption.OnLoad;
                bitmap.EndInit();
                bitmap.Freeze(); //Bitmap must be freezable, so it can be accessed from other threads.
                return bitmap;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to create BitMap from imagefile.");
                throw;
            }
        }
    }
}
