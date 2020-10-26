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
using System.Collections.ObjectModel;
using MahApps.Metro.Controls;
using MahApps.Metro.Controls.Dialogs;
using System.Windows;

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
        private ViewModelLocator viewModelLocator = new ViewModelLocator();

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
            viewModelLocator = new ViewModelLocator();
            result = new MonteCarloSimulationResultModel();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            FindTractsCmd = new RelayCommand(FindTracts, CanRunTool);
            TractChangedCommand = new RelayCommand(TractChanged, CanRunTool);
            ShowModelDialog = new RelayCommand(OpenModelDialog, CanRunTool);
            SelectModelCommand = new RelayCommand(SelectResult, CanRunTool);
            SelectGradeObjectCommand = new RelayCommand(SelectGradeObject, CanRunTool);
            SelectTonnageObjectCommand = new RelayCommand(SelectTonnageObject, CanRunTool);
            SelectGradeTonnageObjectCommand = new RelayCommand(SelectGradeTonnageObject, CanRunTool);
            SelectNDepositsPmfObjectCommand = new RelayCommand(SelectNDepositsPmfObject, CanRunTool);
            OpenResultExcelObjectCommand = new RelayCommand(OpenResultExcelObject, CanRunTool);
            OpenTotalTonnagePlotCommand = new RelayCommand(OpenTotalTonnagePlot, CanRunTool);
            OpenMarginalPlotCommand = new RelayCommand(OpenMarginalPlot, CanRunTool);
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
                        GradePlot = inputParams.GradePlot,
                        TonnagePlot = inputParams.TonnagePlot,
                        NDepositsPmf = inputParams.NDepositsPmf,
                        SelectedTract = inputParams.TractID,
                        LastRunTract = "Tract: " + inputParams.LastRunTract
                    };
                    FindTractIDs();  // Gets the tractID names from PermissiveTractTool's Delineation folder.
                    //FindMCSimTractIDs(); // Gets the tractID names from MCSim folder
                }
                catch (Exception ex)
                {
                    Model = new MonteCarloSimulationModel();
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Monte Carlo Simulation tool's inputs correctly. Inputs were initialized to default values.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Monte Carlo Simulation tool's inputs correctly. Inputs were initialized to default values.", "Error");
                }
            }
            else
            {
                Model = new MonteCarloSimulationModel();
                FindTractIDs();  // Gets the tractID names from PermissiveTractTool's Delineation folder.
                //FindMCSimTractIDs(); // Gets the tractID names from MCSim folder
            }
            if (Model.SelectedTract != null)
            {
                LoadResults();
            }
            if (Model.SelectedTract != null)
            {
                projectFolder = Path.Combine(projectFolder, Model.SelectedTract);
                if (Directory.Exists(projectFolder))
                {
                    Model.ModelNames.Clear();
                    FindModelnames(projectFolder);  // Find saved results.
                }
            }
            var lastRunFile = Path.Combine(settingsService.RootPath, "MCSim", "monte_carlo_simulation_last_run.lastrun");
            if (File.Exists(lastRunFile))
            {
                Model.LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
            }
        }

        /// <summary>
        /// Run tool command.
        /// </summary>
        /// @return Command.
        public RelayCommand RunToolCommand { get; }

        /// <summary>
        /// Find tracts command.
        /// </summary>
        /// @return Command.
        public RelayCommand FindTractsCmd { get; }

        /// <summary>
        /// Tract change command.
        /// </summary>
        /// @return Command.
        public RelayCommand TractChangedCommand { get; }

        /// <summary>
        /// Show model dialog command.
        /// </summary>
        /// @return Command.
        public RelayCommand ShowModelDialog { get; }

        /// <summary>
        /// Select model command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectModelCommand { get; }

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
        /// Select Grade-Tonnage Object command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectGradeTonnageObjectCommand { get; }

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
        /// Open total tonnage plot -command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenTotalTonnagePlotCommand { get; }

        /// <summary>
        /// Open maarginal plot -command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenMarginalPlotCommand { get; }

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
        /// Run tool with user input.
        /// </summary>
        private async void RunTool()
        {
            if(!Model.GradePlot.Contains("Please select") && Model.TonnagePlot.Contains("Please select"))
            {
                dialogService.ShowNotification("Cannot run when only Grade object is defined!", "Error");
                return;
            }

            if (Model.TonnagePlot.Contains("Please select") && Model.GradeTonnagePlot.Contains("Please select"))
            {
                dialogService.ShowNotification("Please select Grade and Tonnage objects OR Tonnage object OR GradeTonnage object!", "Error");
                return;
            }


            Result.TotalTonPlot = null;
            Result.MarginalPlot = null;
            logger.Info("-->{0}", this.GetType().Name);
            if (Model.UseModelName == false)
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
                dialogService.ShowNotification("Failed to clear output folder.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to clear output folder in Monte Carlo Simulation tool.", "Error");
                Model.RunStatus = 0;
                return;
            }
            // 1. Collect input parameters
            MonteCarloSimulationInputParams input = new MonteCarloSimulationInputParams
            {

                GradePlot = Model.GradePlot,
                TonnagePlot = Model.TonnagePlot,
                GradeTonnagePlot = Model.GradeTonnagePlot,
                NDepositsPmf = Model.NDepositsPmf,
                ExtensionFolder = Model.ExtensionFolder,
                TractID = model.SelectedTract,
                LastRunTract = model.SelectedTract
            };
            // 2. Execute tool
            MonteCarloSimulationResult ddResult = default(MonteCarloSimulationResult);
            Model.IsBusy = true;
            try
            {
                await Task.Run(() =>
                {
                    MonteCarloSimulationTool tool = new MonteCarloSimulationTool();
                    ddResult = tool.Execute(input) as MonteCarloSimulationResult;
                    Result.SummaryTotalTonnage = ddResult.SummaryTotalTonnage;
                    Result.TotalTonPlot = ddResult.TotalTonPlot;
                    Result.MarginalPlot = ddResult.MarginalPlot;
                    Result.SimulatedDepositsCSV = ddResult.SimulatedDepositsCSV;
                    Result.TotalTonPlotBitMap = BitmapFromUri(Result.TotalTonPlot);
                    Result.MarginalPlotBitMap = BitmapFromUri(Result.MarginalPlot);
                });
                var modelFolder = Path.Combine(rootPath, Model.SelectedTract, Model.ExtensionFolder);
                Model.ModelNames.Clear();
                FindModelnames(Path.Combine(rootPath, Model.SelectedTract));  // Find saved results.
                string lastRunFile = Path.Combine(Path.Combine(settingsService.RootPath, "MCSim", "monte_carlo_simulation_last_run.lastrun"));
                File.Create(lastRunFile).Close();
                dialogService.ShowNotification("Monte Carlo simulation tool completed successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Monte Carlo simulation tool completed successfully.", "Success");
                Model.LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                Model.LastRunTract = "Tract: " + model.SelectedTract;

                Model.RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to execute REngine() script");
                dialogService.ShowNotification("Run failed. Check output for details. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Monte Carlo Simulation tool run failed. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                Model.RunStatus = 0;
            }
            finally
            {
                Model.IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Select certain result.
        /// </summary>
        private void SelectResult()
        {
            if (Model.ModelNames.Count <= 0)
            {
                dialogService.ShowNotification("There are no results to select.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("There are no results to select.", "Error");
                return;
            }
            try
            {
                var modelDirPath = Model.ModelNames[Model.SelectedModelIndex];
                var modelDirInfo = new DirectoryInfo(Model.ModelNames[Model.SelectedModelIndex]);
                var selectedProjectFolder = Path.Combine(settingsService.RootPath, "MCSim", Model.SelectedTract, "SelectedResult");
                if (modelDirPath == selectedProjectFolder)
                {
                    dialogService.ShowNotification("SelectedResult folder cannot be selected. ", "Error");
                    return;
                }
                if (!Directory.Exists(selectedProjectFolder))
                {
                    Directory.CreateDirectory(selectedProjectFolder);
                }
                DirectoryInfo di = new DirectoryInfo(selectedProjectFolder);
                foreach (FileInfo file in di.GetFiles())
                {
                    file.Delete();
                }
                foreach (DirectoryInfo dir in di.GetDirectories())
                {
                    dir.Delete(true);
                }
                foreach (FileInfo file2 in modelDirInfo.GetFiles())
                {
                    var destPath = Path.Combine(selectedProjectFolder, file2.Name);
                    var sourcePath = Path.Combine(modelDirPath, file2.Name);
                    File.Copy(sourcePath, destPath, true);
                }
                MonteCarloSimulationInputParams inputParams = new MonteCarloSimulationInputParams();
                string param_json = Path.Combine(selectedProjectFolder, "monte_carlo_simulation_input_params.json");
                if (File.Exists(param_json))
                {
                    inputParams.Load(param_json);
                    Model.GradePlot = inputParams.GradePlot;
                    Model.TonnagePlot = inputParams.TonnagePlot;
                    Model.NDepositsPmf = inputParams.NDepositsPmf;
                    Model.ExtensionFolder = inputParams.ExtensionFolder;
                    Model.SelectedTract = inputParams.TractID;
                    File.Copy(param_json, Path.Combine(settingsService.RootPath, "MCSim", "monte_carlo_simulation_input_params.json"), true);
                }
                dialogService.ShowNotification("Monte Carlo Simulation result selected successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Monte Carlo Simulation result selected successfully.", "Success");
            }
            catch (Exception ex)
            {
                logger.Trace(ex, "Error in result selection");
                dialogService.ShowNotification("Failed to select result.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to select result in Monte Carlo Simulation tool.", "Error");
            }
            var metroWindow = (Application.Current.MainWindow as MetroWindow);
            var dialog = metroWindow.GetCurrentDialogAsync<BaseMetroDialog>();
            metroWindow.HideMetroDialogAsync(dialog.Result);
            LoadResults();
        }

        /// <summary>
        /// Load results of the last run.
        /// </summary>
        private void LoadResults()
        {
            // This makes sure that tool doesn't throw an error when it's not run.
            if (Model.SelectedTract != null)
            {
                var projectFolder = Path.Combine(settingsService.RootPath, "MCSim", Model.SelectedTract, "SelectedResult");
                var SummaryTotalTonnage = Path.Combine(projectFolder, "summary.txt");
                var SimulatedDepositsCSV = Path.Combine(projectFolder, Model.SelectedTract + "_05_Sim_EF.csv"); // TAGGED: Change the naming of the file.
                var TotalTonPdf = Path.Combine(projectFolder, "plot.jpeg");
                var MarginalPdf = Path.Combine(projectFolder, "plotMarginals.jpeg");
                if (Directory.Exists(projectFolder))
                {
                    Model.RunStatus = 1; // This will be changed into 0 if something goes wrong.
                    try
                    {
                        if (File.Exists(SummaryTotalTonnage))
                        {
                            Result.SummaryTotalTonnage = File.ReadAllText(SummaryTotalTonnage);
                        }
                        else
                        {
                            Result.SummaryTotalTonnage = null;
                            Model.RunStatus = 0;
                        }
                        //  TAGGED: Doesn't check all the files.
                        if (File.Exists(SimulatedDepositsCSV))
                        {
                            Result.SimulatedDepositsCSV = SimulatedDepositsCSV;
                        }
                        else
                        {
                            Result.SimulatedDepositsCSV = null;
                            Model.RunStatus = 0;
                        }

                        if (File.Exists(TotalTonPdf))
                        {
                            Result.TotalTonPlot = TotalTonPdf;
                            Result.TotalTonPlotBitMap = BitmapFromUri(TotalTonPdf);
                        }
                        else
                        {
                            Result.TotalTonPlot = null;
                            Model.RunStatus = 0;
                        }
                        if (File.Exists(MarginalPdf))
                        {
                            Result.MarginalPlot = MarginalPdf;
                            Result.MarginalPlotBitMap = BitmapFromUri(MarginalPdf);
                        }
                        else
                        {
                            Result.MarginalPlot = null;
                            Model.RunStatus = 0;
                        }
                    }
                    catch (Exception ex)
                    {
                        logger.Error(ex + " Could not load result files.");
                        dialogService.ShowNotification("Couldn't load Monte Carlo Simulation tool's result files correctly.", "Error");
                        viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Monte Carlo Simulation tool's result files correctly.", "Error");
                        Model.RunStatus = 0;
                    }
                }
            }
        }

        private void FindTracts()
        {
            FindTractIDs();
        }

        /// <summary>
        /// Update which tract is chosen and get the tract spesific results.
        /// </summary>
        private void TractChanged()
        {
            if (Model.SelectedTract != null)
            {
                string projectFolder = Path.Combine(settingsService.RootPath, "MCSim");
                projectFolder = Path.Combine(projectFolder, Model.SelectedTract);
                if (Directory.Exists(projectFolder))
                {
                    Model.ModelNames.Clear();
                    FindModelnames(projectFolder);  // Find saved results.
                }
            }
        }

        /// <summary>
        /// Find all saved results, which have been made by past runs.
        /// </summary>
        /// <param name="projectFolder">Models's folder.</param>
        private void FindModelnames(string projectFolder)
        {
            DirectoryInfo folderInfo = new DirectoryInfo(projectFolder);
            foreach (DirectoryInfo result in folderInfo.GetDirectories())
            {
                if (result.Name != "SelectedResult")
                {
                    foreach (FileInfo file in result.GetFiles())
                    {
                        if (file.Name == "monte_carlo_simulation_input_params.json")
                        {
                            Model.ModelNames.Add(result.FullName);
                        }
                    }
                }
            }
            // Goes also through the main folder.
            foreach (FileInfo file in folderInfo.GetFiles())
            {
                if (file.Name == "monte_carlo_simulation_input_params.json")
                {
                    Model.ModelNames.Add(folderInfo.FullName);
                }
            }
        }

        /// <summary>
        /// Get TractIDs.
        /// </summary>
        public void FindTractIDs()
        {
            Model.TractIDNames = new ObservableCollection<string>();
            string tractRootPath = Path.Combine(settingsService.RootPath, "TractDelineation", "Tracts");
            if (Directory.Exists(tractRootPath))
            {
                DirectoryInfo di = new DirectoryInfo(tractRootPath);
                foreach (DirectoryInfo dir in di.GetDirectories())
                {
                    Model.TractIDNames.Add(dir.Name);  // Get TractID by getting the name of the directory.
                }
            }
            else
            {
                Directory.CreateDirectory(Path.Combine(settingsService.RootPath, "TractDelineation", "Tracts"));
            }
        }

        /// <summary>
        /// Select grade object.
        /// </summary>
        private void SelectGradeObject()
        {
            try
            {
                string objectFile = dialogService.OpenFileDialog(Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult"), "RDS files|*.rds;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(objectFile))
                {
                    Model.GradePlot = objectFile.Replace("\\", "/");
                    Model.GradeTonnagePlot = "";
                }
                else {
                    Model.GradePlot = "";
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to select input file for Grade Object in Monte Carlo Simulation tool.", "Error");
            }
        }

        /// <summary>
        /// Select tonange object.
        /// </summary>
        private void SelectTonnageObject()
        {
            try
            {
                string objectFile = dialogService.OpenFileDialog(Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult"), "RDS files|*.rds;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(objectFile))
                {
                    Model.TonnagePlot = objectFile.Replace("\\", "/");
                    Model.GradeTonnagePlot = "";
                }
                else
                {
                    Model.TonnagePlot = "";
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to select input file for Tonnage Object in Monte Carlo Simulation tool.", "Error");
            }
        }

        /// <summary>
        /// Select grade-tonnange object.
        /// </summary>
        private void SelectGradeTonnageObject()
        {
            try
            {
                string objectFile = dialogService.OpenFileDialog(Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult"), "RDS files|*.rds;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(objectFile))
                {
                    Model.GradeTonnagePlot = objectFile.Replace("\\", "/");
                    Model.GradePlot = "";
                    Model.TonnagePlot = "";
                }
                else
                {
                    Model.GradeTonnagePlot = "";
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to select input file for Grade-Tonnage Object in Monte Carlo Simulation tool.", "Error");
            }
        }

        /// <summary>
        /// Select undiscovered deposits result object.
        /// </summary>
        private void SelectNDepositsPmfObject()
        {
            try
            {
                string objectFile = dialogService.OpenFileDialog(Path.Combine(settingsService.RootPath, "UndiscDep", Model.SelectedTract, "SelectedResult"), "RDS files|*.rds;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(objectFile))
                {
                    Model.NDepositsPmf = objectFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to select input file for Pmf Object in Monte Carlo Simulation tool.", "Error");
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
                dialogService.ShowNotification("Failed to open csv file. Check output for details.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to open csv file in Monte Carlo Simulation tool.", "Error");
            }
        }

        /// <summary>
        /// Open total tonnage image.
        /// </summary>
        private void OpenTotalTonnagePlot()
        {
            try
            {
                bool openFile = dialogService.MessageBoxDialog();
                if (openFile == true)
                {
                    if (File.Exists(Result.TotalTonPlot))
                    {
                        Process.Start(Result.TotalTonPlot);
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to open imagefile");
                dialogService.ShowNotification("Failed to open imagefile.", "Error");
            }
        }

        /// <summary>
        /// Open marginal image.
        /// </summary>
        private void OpenMarginalPlot()
        {
            try
            {
                bool openFile = dialogService.MessageBoxDialog();
                if (openFile == true)
                {
                    if (File.Exists(Result.MarginalPlot))
                    {
                        Process.Start(Result.MarginalPlot);
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to open imagefile");
                dialogService.ShowNotification("Failed to open imagefile.", "Error");
            }
        }

        /// <summary>
        /// Check if tool can be executed.
        /// </summary>
        /// <returns>Boolean representing the state.</returns>
        private bool CanRunTool()
        {
            return !Model.IsBusy;
        }

        /// <summary>
        /// Method stub to show selectPDFs-dialog
        /// </summary>
        public void OpenModelDialog()
        {
            viewModelLocator.Main.DialogContentSource = "MonteCarloSimulationViewModel";
            dialogService.ShowMessageDialog();
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
