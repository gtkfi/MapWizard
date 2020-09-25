
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
using System.ComponentModel;
using System.Windows;
using MahApps.Metro.Controls;
using MahApps.Metro.Controls.Dialogs;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Diagnostics;
using System.Collections.ObjectModel;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// This class contains properties that the UndiscoveredDepositsView can data bind to.
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
    public class UndiscoveredDepositsViewModel : ViewModelBase, INotifyPropertyChanged
    {
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private UndiscoveredDepositsModel model;
        private UndiscoveredDepositsResultModel result;
        private ViewModelLocator viewModelLocator;

        /// <summary>
        /// Initialize new instance of UndiscoveredDepositsViewModel
        /// </summary>
        /// <param name="logger">Logging for the MapWizard.</param>
        /// <param name="dialogService">Service for using dialogs and notifications.</param>
        /// <param name="settingsService">Service for using and editing settings.</param>
        public UndiscoveredDepositsViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            result = new UndiscoveredDepositsResultModel();
            TractChangedCommand = new RelayCommand(TractChanged, CanRunTool);
            FindTractsCommand = new RelayCommand(FindTractIDs, CanRunTool);
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            AddEstimationCommand = new RelayCommand(AddEstimation, CanRunTool);
            AddCustomEstimationCommand = new RelayCommand(AddCustomEstimation, CanRunTool);
            SelectModelCommand = new RelayCommand(SelectResult, CanRunTool);
            ShowModelDialog = new RelayCommand(OpenModelDialog, CanRunTool);
            OpenUndiscDepPlotCommand = new RelayCommand(OpenUndiscDepPlot, CanRunTool);
            viewModelLocator = new ViewModelLocator();
            UndiscoveredDepositsInputParams inputParams = new UndiscoveredDepositsInputParams();
            string projectFolder = Path.Combine(settingsService.RootPath, "UndiscDep");
            if (!Directory.Exists(projectFolder))
            {
                Directory.CreateDirectory(projectFolder);
            }
            string param_json = Path.Combine(projectFolder, "undiscovered_deposits_input_params.json");
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    Model = new UndiscoveredDepositsModel
                    {
                        DepositsCsvString = inputParams.DepositsNegativeCSV,
                        CustomFunctionCsvString = inputParams.DepositsCustomCSV,
                        EstN90 = inputParams.N90,
                        EstN50 = inputParams.N50,
                        EstN10 = inputParams.N10,
                        EstN5 = inputParams.N5,
                        EstN1 = inputParams.N1,
                        SelectedTract = inputParams.TractID,
                        NegBinomialExtensionFolder = "",
                        Mark3ExtensionFolder = "",
                        CustomExtensionFolder = "",
                        EstimateRationale = inputParams.EstRationaleTXT,
                        MARK3EstimateRationale = inputParams.Mark3EstRationaleTXT,
                        CustomEstimateRationale = inputParams.CustomEstRationaleTXT,
                        LastRunTract = inputParams.LastRunTract
                    };
                }
                catch (Exception ex)
                {
                    Model = new UndiscoveredDepositsModel();
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Undiscovered Deposits tool's inputs correctly. Inputs were initialized to default values.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Undiscovered Deposits tool's inputs correctly. Inputs were initialized to default values.", "Error");
                }
            }
            else
            {
                Model = new UndiscoveredDepositsModel();
            }
            FindTractIDs();
            LoadResults();
            try
            {
                if (Model.SelectedTract != null)
                {
                    projectFolder = Path.Combine(projectFolder, Model.SelectedTract);
                    if (Directory.Exists(projectFolder))
                    {
                        //  Find saved results from all the methods.
                        DirectoryInfo projectFolderInfo = null;
                        Model.ModelNames.Clear();
                        if (Directory.Exists(Path.Combine(projectFolder, "NegativeBinomial")))
                        {
                            projectFolderInfo = new DirectoryInfo(Path.Combine(projectFolder, "NegativeBinomial")); //NegativeBinomial results
                            FindModelnames(projectFolderInfo);
                        }
                        if (Directory.Exists(Path.Combine(projectFolder, "MARK3")))
                        {
                            projectFolderInfo = new DirectoryInfo(Path.Combine(projectFolder, "MARK3")); //MARK3 results
                            FindModelnames(projectFolderInfo);
                        }
                        if (Directory.Exists(Path.Combine(projectFolder, "Custom")))
                        {
                            projectFolderInfo = new DirectoryInfo(Path.Combine(projectFolder, "Custom")); //Custom results
                            FindModelnames(projectFolderInfo);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to load model names");
                dialogService.ShowNotification("Failed to load model names.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to load model names correctly in Undiscovered Deposits tool.", "Error");
            }
            var lastRunFile = Path.Combine(settingsService.RootPath, "UndiscDep", "undiscovered_deposits_last_run.lastrun");
            if (File.Exists(lastRunFile))
            {
                Model.LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
            }
        }

        /// <summary>
        /// Tract change command.
        /// </summary>
        /// @return Command.
        public RelayCommand TractChangedCommand { get; }

        /// <summary>
        /// Command for getting tracts.
        /// </summary>
        /// @return Command.
        public RelayCommand FindTractsCommand { get; }

        /// <summary>
        /// Run tool command.
        /// </summary>
        /// @return Command.
        public RelayCommand RunToolCommand { get; }

        /// <summary>
        /// Add estimation command.
        /// </summary>
        /// @return Command.
        public RelayCommand AddEstimationCommand { get; }

        /// <summary>
        /// Add custom estimation command.
        /// </summary>
        /// @return Command.
        public RelayCommand AddCustomEstimationCommand { get; }

        /// <summary>
        /// Select model command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectModelCommand { get; }

        /// <summary>
        /// Open plots command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenUndiscDepPlotCommand { get; }

        /// <summary>
        /// Show model command.
        /// </summary>
        /// @return Command.
        public RelayCommand ShowModelDialog { get; }

        /// <summary>
        /// Undiscovered deposits model.
        /// </summary>
        /// @return UndiscoveredDepositsModel.
        public UndiscoveredDepositsModel Model
        {
            get
            {
                return model;
            }
            set
            {
                model = value;
                RaisePropertyChanged("UndiscoveredDepositsModel");
            }
        }

        /// <summary>
        /// Deposit Density result model.
        /// </summary>
        /// @return UndiscoveredDepositsResultModel.
        public UndiscoveredDepositsResultModel Result
        {
            get
            {
                return result;
            }
            set
            {
                result = value;
                RaisePropertyChanged("UndiscoveredDepositsResultModel");
            }
        }

        /// <summary>
        /// Update which tract is chosen and get the tract spesific results.
        /// </summary>
        private void TractChanged()
        {
            viewModelLocator.DepositDensityViewModel.Model.SelectedTract = Model.SelectedTract;
            string projectFolder = Path.Combine(settingsService.RootPath, "UndiscDep");
            if (Model.SelectedTract != null)
            {
                projectFolder = Path.Combine(projectFolder, Model.SelectedTract);
                if (Directory.Exists(projectFolder))
                {
                    //  Find saved results from all the methods.
                    DirectoryInfo projectFolderInfo = null;
                    Model.ModelNames.Clear();
                    if (Directory.Exists(Path.Combine(projectFolder, "NegativeBinomial")))
                    {
                        projectFolderInfo = new DirectoryInfo(Path.Combine(projectFolder, "NegativeBinomial")); //NegativeBinomial results
                        FindModelnames(projectFolderInfo);
                    }
                    if (Directory.Exists(Path.Combine(projectFolder, "MARK3")))
                    {
                        projectFolderInfo = new DirectoryInfo(Path.Combine(projectFolder, "MARK3")); //MARK3 results
                        FindModelnames(projectFolderInfo);
                    }
                    if (Directory.Exists(Path.Combine(projectFolder, "Custom")))
                    {
                        projectFolderInfo = new DirectoryInfo(Path.Combine(projectFolder, "Custom")); //Custom results
                        FindModelnames(projectFolderInfo);
                    }
                }
            }
        }

        /// <summary>
        /// Run tool with user input.
        /// </summary>
        private async void RunTool()
        {
            logger.Info("-->{0}", this.GetType().Name);
            // 1. Collect input parameters
            string usedMethod = "";
            if (Model.SelectedTabIndex == 1)
                usedMethod = "Negative";
            else if (Model.SelectedTabIndex == 2)
                usedMethod = "Middle";
            else if (Model.SelectedTabIndex == 3)
                usedMethod = "Custom";

            if (Model.NegBinomialUseModelName == false)
            {
                Model.NegBinomialExtensionFolder = "";
            }
            if (Model.Mark3UseModelName == false)
            {
                Model.Mark3ExtensionFolder = "";
            }
            if (Model.CustomUseModelName == false)
            {
                Model.CustomExtensionFolder = "";
            }
            UndiscoveredDepositsInputParams input = new UndiscoveredDepositsInputParams
            {
                DepositsNegativeCSV = Model.DepositsCsvString,
                DepositsCustomCSV = Model.CustomFunctionCsvString,
                EstRationaleTXT = Model.EstimateRationale,
                Mark3EstRationaleTXT = Model.MARK3EstimateRationale,
                CustomEstRationaleTXT = Model.CustomEstimateRationale,
                N90 = Model.EstN90,
                N50 = Model.EstN50,
                N10 = Model.EstN10,
                N5 = Model.EstN5,
                N1 = Model.EstN1,
                Method = usedMethod,
                TractID = Model.SelectedTract,
                NegBinomialExtensionFolder = Model.NegBinomialExtensionFolder,
                Mark3ExtensionFolder = Model.Mark3ExtensionFolder,
                CustomExtensionFolder = Model.CustomExtensionFolder,
                LastRunTract = "Tract: "+Model.SelectedTract

            };
            // 2. Execute tool
            UndiscoveredDepositsResult ddResult = default(UndiscoveredDepositsResult);
            Model.IsBusy = true;
            try
            {
                await Task.Run(() =>
                {
                    UndiscoveredDepositsTool tool = new UndiscoveredDepositsTool();
                    ddResult = tool.Execute(input) as UndiscoveredDepositsResult;
                    Result.Summary = ddResult.Summary;
                    Result.PlotImage = ddResult.PlotImage;
                    Result.PlotImageBitMap = BitmapFromUri(Result.PlotImage);
                });

                //TODO: refactor this cleaner
                var projectFolder = Path.Combine(input.Env.RootPath, "UndiscDep", Model.SelectedTract);                
                DirectoryInfo projectFolderInfo = null;
                Model.ModelNames.Clear();
                var modelFolder = Path.Combine(input.Env.RootPath, "UndiscDep", Model.SelectedTract, "NegativeBinomial", Model.NegBinomialExtensionFolder);
                if (Directory.Exists(Path.Combine(projectFolder, "NegativeBinomial")))
                {
                    if(usedMethod == "Negative")
                    {
                        input.Save(Path.Combine(modelFolder, "undiscovered_deposits_input_params.json"));
                    }
                    projectFolderInfo = new DirectoryInfo(Path.Combine(projectFolder, "NegativeBinomial")); //NegativeBinomial results
                    FindModelnames(projectFolderInfo);
                }
                modelFolder = Path.Combine(input.Env.RootPath, "UndiscDep", Model.SelectedTract, "Mark3", Model.Mark3ExtensionFolder);
                if (Directory.Exists(Path.Combine(projectFolder, "MARK3")))
                {

                    if (usedMethod == "Middle")
                    {
                        input.Save(Path.Combine(modelFolder, "undiscovered_deposits_input_params.json"));
                    }
                    projectFolderInfo = new DirectoryInfo(Path.Combine(projectFolder, "MARK3")); //MARK3 results
                    FindModelnames(projectFolderInfo);
                }
                modelFolder = Path.Combine(input.Env.RootPath, "UndiscDep", Model.SelectedTract, "Custom", Model.CustomExtensionFolder);
                if (Directory.Exists(Path.Combine(projectFolder, "Custom")))
                {
                    if (usedMethod == "Custom")
                    {
                        input.Save(Path.Combine(modelFolder, "undiscovered_deposits_input_params.json"));
                    }
                    projectFolderInfo = new DirectoryInfo(Path.Combine(projectFolder, "Custom")); //Custom results
                    FindModelnames(projectFolderInfo);
                }

                string lastRunFile = Path.Combine(Path.Combine(settingsService.RootPath, "UndiscDep", "undiscovered_deposits_last_run.lastrun"));
                File.Create(lastRunFile).Close();
                input.Save(Path.Combine(settingsService.RootPath, "UndiscDep", "undiscovered_deposits_input_params.json"));
                dialogService.ShowNotification("UndiscoveredDepositsTool completed successfully", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("UndiscoveredDepositsTool completed successfully", "Success");
                Model.LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                Model.LastRunTract = "Tract: " + model.SelectedTract;
                Model.RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to execute REngine() script");
                dialogService.ShowNotification("Run failed. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Undiscovered Deposits Tool run failed. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
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
                var selectedProjectFolder = Path.Combine(settingsService.RootPath, "UndiscDep", Model.SelectedTract, "SelectedResult");
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
                Result.PlotImage = null;
                foreach (FileInfo file2 in modelDirInfo.GetFiles())
                {
                    var destPath = Path.Combine(selectedProjectFolder, file2.Name);
                    var sourcePath = Path.Combine(modelDirPath, file2.Name);
                    File.Copy(sourcePath, destPath, true);
                }
                UndiscoveredDepositsInputParams inputParams = new UndiscoveredDepositsInputParams();
                string param_json = Path.Combine(selectedProjectFolder, "undiscovered_deposits_input_params.json");
                if (File.Exists(param_json))
                {
                    inputParams.Load(param_json);
                    Model.DepositsCsvString = inputParams.DepositsNegativeCSV;
                    Model.CustomFunctionCsvString = inputParams.DepositsCustomCSV;
                    Model.EstN90 = inputParams.N90;
                    Model.EstN50 = inputParams.N50;
                    Model.EstN10 = inputParams.N10;
                    Model.EstN5 = inputParams.N5;
                    Model.EstN1 = inputParams.N1;
                    Model.SelectedTract = inputParams.TractID;
                    Model.NegBinomialExtensionFolder = inputParams.NegBinomialExtensionFolder;
                    Model.Mark3ExtensionFolder = inputParams.Mark3ExtensionFolder;
                    Model.CustomExtensionFolder = inputParams.CustomExtensionFolder;
                    Model.EstimateRationale = inputParams.EstRationaleTXT;
                    Model.MARK3EstimateRationale = inputParams.Mark3EstRationaleTXT;
                    Model.CustomEstimateRationale = inputParams.CustomEstRationaleTXT;
                    File.Copy(param_json, Path.Combine(settingsService.RootPath, "UndiscDep", "undiscovered_deposits_input_params.json"), true);
                }
                if (Model.SelectedTract.StartsWith("AGG"))
                {
                    viewModelLocator.ReportingAssesmentViewModel.Model.SelectedTractCombination = Model.SelectedTract;
                    viewModelLocator.ReportingAssesmentViewModel.CheckFiles();
                    viewModelLocator.ReportingAssesmentViewModel.SaveInputs();
                }
                else
                {
                    viewModelLocator.ReportingViewModel.Model.SelectedTract = Model.SelectedTract;
                    viewModelLocator.ReportingViewModel.CheckFiles();
                    viewModelLocator.ReportingViewModel.SaveInputs();
                }                                                
                dialogService.ShowNotification("Undiscovered Deposits result selected successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Undiscovered Deposits result selected successfully.", "Success");
            }
            catch (Exception ex)
            {
                logger.Trace(ex, "Error in result selection");
                dialogService.ShowNotification("Failed to select result.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to select result in Undiscovered Deposits tool.", "Error");
            }
            var metroWindow = (Application.Current.MainWindow as MetroWindow);
            var dialog = metroWindow.GetCurrentDialogAsync<BaseMetroDialog>();
            metroWindow.HideMetroDialogAsync(dialog.Result);
            LoadResults();
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
        /// Add estimation to estimation csv -string
        /// </summary>
        private void AddEstimation()
        {
            if (Model.DepositsCsvString == null || Model.DepositsCsvString == "")
            {
                Model.DepositsCsvString = "Name,Weight,N90,N50,N10";
            }
            Model.DepositsCsvString += "\n" + Model.EstName + "," + Model.EstWeight + "," + Model.EstN90 + "," + Model.EstN50 + "," + Model.EstN10;
        }

        /// <summary>
        ///  Add custom estimation to custom estimation csv -string
        /// </summary>
        private void AddCustomEstimation()
        {
            if (Model.CustomFunctionCsvString == null || Model.CustomFunctionCsvString == "")
            {
                Model.CustomFunctionCsvString = "N deposits, Probability\n";
            }
            Model.CustomFunctionCsvString += Model.NDeposits + "," + Model.Probability + "\n";
        }

        /// <summary>
        /// Method stub to show selectPDFs-dialog
        /// </summary>
        public void OpenModelDialog()
        {
            viewModelLocator.Main.DialogContentSource = "UndiscoveredDepositsViewModel";
            dialogService.ShowMessageDialog();
        }

        /// <summary>
        /// Open image file.
        /// </summary>
        private void OpenUndiscDepPlot()
        {
            try
            {
                bool openFile = dialogService.MessageBoxDialog();
                if (openFile == true)
                {
                    if (File.Exists(Result.PlotImage))
                    {
                        Process.Start(Result.PlotImage);
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
        /// Load results of the last run.
        /// </summary>
        private void LoadResults()
        {
            if (Model.SelectedTract != null)
            {
                try
                {
                    var projectFolder = Path.Combine(settingsService.RootPath, "UndiscDep", Model.SelectedTract, "SelectedResult");
                    // Makes sure that the result have been selected even once.
                    if (Directory.Exists(projectFolder))
                    {
                        var Summary = Path.Combine(projectFolder, "summary.txt");
                        var PlotImage = Path.Combine(projectFolder, "plot.jpeg");
                        var NDepositsPmf = Path.Combine(projectFolder, "oPmf.rds");
                        Model.RunStatus = 1;  // Change status to error if any of the result files is not found.

                        if (File.Exists(Summary))
                        {
                            Result.Summary = File.ReadAllText(Summary);
                        }
                        else
                        {
                            Result.Summary = null;
                            Model.RunStatus = 0;
                        }
                        if (File.Exists(PlotImage))
                        {
                            Result.PlotImage = PlotImage;
                            Result.PlotImageBitMap = BitmapFromUri(PlotImage);
                        }
                        else
                        {
                            Result.PlotImage = null;
                            Result.PlotImageBitMap = null;
                            Model.RunStatus = 0;
                        }
                        if (File.Exists(NDepositsPmf))
                            Result.NDepositsPmf = NDepositsPmf;
                        else
                        {
                            Result.NDepositsPmf = null;
                            Model.RunStatus = 0;
                        }
                    }
                }
                catch (Exception ex)
                {
                    logger.Error(ex + " Could not load results files");
                    dialogService.ShowNotification("Failed to load Undiscovered Deposits tool's result files.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Failed to load Undiscovered Deposits tool's result files.", "Error");
                }
            }
        }

        /// <summary>
        /// Find all saved results, which have been made by past runs.
        /// </summary>
        /// <param name="projectFolderInfo">Tool's folder.</param>
        private void FindModelnames(DirectoryInfo projectFolderInfo)
        {
            foreach (DirectoryInfo model in projectFolderInfo.GetDirectories())
            {
                if (model.Name != "SelectedResult")
                {
                    foreach (FileInfo file in model.GetFiles())
                    {
                        if (file.Name == "undiscovered_deposits_input_params.json")
                        {
                            Model.ModelNames.Add(model.FullName);
                        }
                    }
                }
            }
            foreach (FileInfo file in projectFolderInfo.GetFiles())
            {
                if (file.Name == "undiscovered_deposits_input_params.json")
                {
                    Model.ModelNames.Add(projectFolderInfo.FullName);
                }
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
