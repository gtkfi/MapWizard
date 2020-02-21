using System;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
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
        private bool isBusy;
        private bool negBinomialUseModelName;
        private bool mark3UseModelName;
        private bool customUseModelName;
        private int selectedModelIndex;
        private ObservableCollection<string> modelNames;
        private string lastRunDate;
        private int runStatus;

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
            lastRunDate = "Last Run: Never";
            runStatus = 2;
            negBinomialUseModelName = false;
            mark3UseModelName = false;
            customUseModelName = false;
            selectedModelIndex = 0;
            modelNames = new ObservableCollection<string>();
            result = new UndiscoveredDepositsResultModel();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            AddEstimationCommand = new RelayCommand(AddEstimation, CanRunTool);
            AddCustomEstimationCommand = new RelayCommand(AddCustomEstimation, CanRunTool);
            SelectModelCommand = new RelayCommand(SelectResult, CanRunTool);
            ShowModelDialog = new RelayCommand(OpenModelDialog, CanRunTool);
            viewModelLocator = new ViewModelLocator();
            UndiscoveredDepositsInputParams inputParams = new UndiscoveredDepositsInputParams();
            string selectedProjectFolder = Path.Combine(settingsService.RootPath, "UndiscDep", "SelectedResult");
            try
            {
                if (!Directory.Exists(selectedProjectFolder))
                {
                    Directory.CreateDirectory(selectedProjectFolder);
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Could not create Undiscovered Deposits project folder");
                throw;
            }
            string param_json = Path.Combine(selectedProjectFolder, "undiscovered_deposits_input_params.json");
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    Model = new UndiscoveredDepositsModel
                    {
                        DepositsCsvString = inputParams.depositsNegativeCSV,
                        CustomFunctionCsvString = inputParams.depositsCustomCSV,
                        EstN90 = inputParams.N90,
                        EstN50 = inputParams.N50,
                        EstN10 = inputParams.N10,
                        EstN5 = inputParams.N5,
                        EstN1 = inputParams.N1,
                        TractId = inputParams.TractID,
                        NegBinomialExtensionFolder = "",
                        Mark3ExtensionFolder = "",
                        CustomExtensionFolder = "",
                        EstimateRationale = inputParams.estRationaleTXT,
                        MARK3EstimateRationale = inputParams.mark3EstRationaleTXT,
                        CustomEstimateRationale = inputParams.customEstRationaleTXT
                    };
                }
                catch (Exception ex)
                {
                    Model = new UndiscoveredDepositsModel
                    {
                        DepositsCsvString = "Name,Weight,N90,N50,N10"
                    };
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Undiscovered Deposits tool's inputs correctly.", "Error");
                }
            }
            else
            {
                Model = new UndiscoveredDepositsModel
                {
                    DepositsCsvString = "Name,Weight,N90,N50,N10"
                };
            }
            try
            {
                if (Directory.GetFiles(selectedProjectFolder).Length != 0)
                {
                    LoadResults();
                }
                //  Find saved results from all the methods.
                DirectoryInfo projectFolderInfo = null;
                if (Directory.Exists(Path.Combine(settingsService.RootPath, "UndiscDep", "NegativeBinomial")))
                {
                    projectFolderInfo = new DirectoryInfo(Path.Combine(settingsService.RootPath, "UndiscDep", "NegativeBinomial")); //NegativeBinomial results
                    FindModelnames(projectFolderInfo);
                }
                if (Directory.Exists(Path.Combine(settingsService.RootPath, "UndiscDep", "MARK3")))
                {
                    projectFolderInfo = new DirectoryInfo(Path.Combine(settingsService.RootPath, "UndiscDep", "MARK3")); //MARK3 results
                    FindModelnames(projectFolderInfo);
                }
                if (Directory.Exists(Path.Combine(settingsService.RootPath, "UndiscDep", "Custom")))
                {
                    projectFolderInfo = new DirectoryInfo(Path.Combine(settingsService.RootPath, "UndiscDep", "Custom")); //Custom results
                    FindModelnames(projectFolderInfo);
                }
                var lastRunFile = Path.Combine(settingsService.RootPath, "UndiscDep", "undiscovered_deposits_last_run.lastrun");
                if (File.Exists(lastRunFile))
                {
                    LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to load model names");
                throw;
            }
        }

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
        /// Is busy?
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

            if (NegBinomialUseModelName == false)
            {
                Model.NegBinomialExtensionFolder = "";
            }
            if (Mark3UseModelName == false)
            {
                Model.Mark3ExtensionFolder = "";
            }
            if (CustomUseModelName == false)
            {
                Model.CustomExtensionFolder = "";
            }
            UndiscoveredDepositsInputParams input = new UndiscoveredDepositsInputParams
            {
                depositsNegativeCSV = Model.DepositsCsvString,
                depositsCustomCSV = Model.CustomFunctionCsvString,
                estRationaleTXT = Model.EstimateRationale,
                mark3EstRationaleTXT = Model.MARK3EstimateRationale,
                customEstRationaleTXT = Model.CustomEstimateRationale,
                N90 = Model.EstN90,
                N50 = Model.EstN50,
                N10 = Model.EstN10,
                N5 = Model.EstN5,
                N1 = Model.EstN1,
                method = usedMethod,
                TractID = Model.TractId,
                NegBinomialExtensionFolder = Model.NegBinomialExtensionFolder,
                Mark3ExtensionFolder = Model.Mark3ExtensionFolder,
                CustomExtensionFolder = Model.CustomExtensionFolder
            };
            // 2. Execute tool
            UndiscoveredDepositsResult ddResult = default(UndiscoveredDepositsResult);
            IsBusy = true;
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
                var modelFolder = Path.Combine(input.Env.RootPath, "UndiscDep", "NegativeBinomial", Model.NegBinomialExtensionFolder);
                if (usedMethod == "Negative" && !ModelNames.Contains(modelFolder))
                    ModelNames.Add(modelFolder);

                modelFolder = Path.Combine(input.Env.RootPath, "UndiscDep", "Mark3", Model.Mark3ExtensionFolder);
                if (usedMethod == "Middle" && !ModelNames.Contains(modelFolder))
                    ModelNames.Add(modelFolder);

                modelFolder = Path.Combine(input.Env.RootPath, "UndiscDep", "Custom", Model.CustomExtensionFolder);
                if (usedMethod == "Custom" && !ModelNames.Contains(modelFolder))
                    ModelNames.Add(modelFolder);

                string lastRunFile = Path.Combine(Path.Combine(settingsService.RootPath, "UndiscDep", "undiscovered_deposits_last_run.lastrun"));
                File.Create(lastRunFile);
                dialogService.ShowNotification("UndiscoveredDepositsTool completed successfully", "Success");
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
        /// Select certain result.
        /// </summary>
        private void SelectResult()
        {
            if (ModelNames.Count > 0)
            {
                try
                {
                    var modelDirPath = ModelNames[SelectedModelIndex];
                    var modelDirInfo = new DirectoryInfo(ModelNames[SelectedModelIndex]);
                    var efRootPath = Path.Combine(settingsService.RootPath, "UndiscDep", "SelectedResult");
                    if (!Directory.Exists(efRootPath))
                    {
                        Directory.CreateDirectory(efRootPath);
                    }
                    if (modelDirPath != efRootPath)
                    {
                        DirectoryInfo di = new DirectoryInfo(efRootPath);
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
                            var destPath = Path.Combine(efRootPath, file2.Name);
                            var sourcePath = Path.Combine(modelDirPath, file2.Name);
                            File.Copy(sourcePath, destPath, true);
                        }
                    }

                    UndiscoveredDepositsInputParams inputParams = new UndiscoveredDepositsInputParams();
                    string selectedProjectFolder = Path.Combine(settingsService.RootPath, "UndiscDep", "SelectedResult");
                    string param_json = Path.Combine(selectedProjectFolder, "undiscovered_deposits_input_params.json");

                    if (File.Exists(param_json))
                    {
                        inputParams.Load(param_json);

                        Model.DepositsCsvString = inputParams.depositsNegativeCSV;
                        Model.CustomFunctionCsvString = inputParams.depositsCustomCSV;
                        Model.EstN90 = inputParams.N90;
                        Model.EstN50 = inputParams.N50;
                        Model.EstN10 = inputParams.N10;
                        Model.EstN5 = inputParams.N5;
                        Model.EstN1 = inputParams.N1;
                        Model.TractId = inputParams.TractID;
                        Model.NegBinomialExtensionFolder = inputParams.NegBinomialExtensionFolder;
                        Model.Mark3ExtensionFolder = inputParams.Mark3ExtensionFolder;
                        Model.CustomExtensionFolder = inputParams.CustomExtensionFolder;
                        Model.EstimateRationale = inputParams.estRationaleTXT;
                        Model.MARK3EstimateRationale = inputParams.mark3EstRationaleTXT;
                        Model.CustomEstimateRationale = inputParams.customEstRationaleTXT;
                    }

                    string summary = Path.Combine(selectedProjectFolder, "summary.txt");
                    string plot = Path.Combine(selectedProjectFolder, "plot.jpeg");
                    string estRationale = Path.Combine(selectedProjectFolder, "EstRationale.txt");

                    if (File.Exists(summary) && File.Exists(plot) && File.Exists(estRationale))
                    {
                        string depEst = Path.Combine(selectedProjectFolder, "nDepEst.csv");
                        string depEstMiddle = Path.Combine(selectedProjectFolder, "nDepEstMiddle.csv");
                        string depEstCustom = Path.Combine(selectedProjectFolder, "nDepEstCustom.csv");
                        if (inputParams.method == "Negative" && File.Exists(depEst))
                        {
                            viewModelLocator.ReportingViewModel.IsUndiscDepDone = "Yes (NegativeBinomial)";
                        }
                        else if (inputParams.method == "Middle" && File.Exists(depEstMiddle))
                        {
                            viewModelLocator.ReportingViewModel.IsUndiscDepDone = "Yes (MARK3)";
                        }
                        else if (inputParams.method == "Custom" && File.Exists(depEstCustom))
                        {
                            viewModelLocator.ReportingViewModel.IsUndiscDepDone = "Yes (Custom)";
                        }
                        else
                        {
                            viewModelLocator.ReportingViewModel.IsUndiscDepDone = "No";
                        }
                        viewModelLocator.ReportingViewModel.SaveInputs();
                    }
                    else
                    {
                        viewModelLocator.ReportingViewModel.IsUndiscDepDone = "No";
                    }
                }
                catch (Exception ex)
                {
                    logger.Trace(ex, "Error in Model Selection:");
                }
                var metroWindow = (Application.Current.MainWindow as MetroWindow);
                var dialog = metroWindow.GetCurrentDialogAsync<BaseMetroDialog>();
                metroWindow.HideMetroDialogAsync(dialog.Result);
                LoadResults();
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
        /// Load results of the last run.
        /// </summary>
        private void LoadResults()
        {
            try
            {
                var projectFolder = Path.Combine(settingsService.RootPath, "UndiscDep", "SelectedResult");
                var Summary = Path.Combine(projectFolder, "summary.txt");
                var PlotImage = Path.Combine(projectFolder, "plot.jpeg");
                var NDepositsPmf = Path.Combine(projectFolder, "oPmf.rds");
                RunStatus = 1;  // Change status to error if any of the result files is not found.

                if (File.Exists(Summary))
                {
                    Result.Summary = File.ReadAllText(Summary);
                }
                else
                {
                    Result.Summary = null;
                    RunStatus = 0;
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
                    RunStatus = 0;
                }
                if (File.Exists(NDepositsPmf))
                    Result.NDepositsPmf = NDepositsPmf;
                else
                {
                    Result.NDepositsPmf = null;
                    RunStatus = 0;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex + " Could not load results files");
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
                            modelNames.Add(model.FullName);
                        }
                    }
                }
            }
            foreach (FileInfo file in projectFolderInfo.GetFiles())
            {
                if (file.Name == "undiscovered_deposits_input_params.json")
                {
                    modelNames.Add(projectFolderInfo.FullName);
                }
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
        /// Whether last run has been succesful, failed or the tool has not been run yet on this project.
        /// </summary>
        /// <returns>Integer representing the status.</returns>
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
        /// Date of last run.
        /// </summary>
        /// <returns>Date.</returns>
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
        /// Collection containing names of previously ran models for model selection.
        /// </summary>
        /// @return Collection of model names.
        public ObservableCollection<string> ModelNames
        {
            get { return modelNames; }
            set
            {
                if (value == modelNames) return;
                modelNames = value;
            }
        }

        /// <summary>
        /// Public property for index of selected model, for View to bind to.
        /// </summary>
        /// @return Collection of model names.
        public int SelectedModelIndex
        {
            get { return selectedModelIndex; }
            set
            {
                if (value == selectedModelIndex) return;
                selectedModelIndex = value;
                RaisePropertyChanged("SelectedModelIndex");
            }
        }

        /// <summary>
        /// Whether to use a name for Neg. Binomial model.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool NegBinomialUseModelName
        {
            get { return negBinomialUseModelName; }
            set
            {
                if (value == negBinomialUseModelName) return;
                negBinomialUseModelName = value;
                RaisePropertyChanged("NegBinomialUseModelName");
            }
        }

        /// <summary>
        ///  Whether to use a name for Mark3 model.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool Mark3UseModelName
        {
            get { return mark3UseModelName; }
            set
            {
                if (value == mark3UseModelName) return;
                mark3UseModelName = value;
                RaisePropertyChanged("Mark3UseModelName");
            }
        }

        /// <summary>
        /// Whether to use a name for Custom model
        /// </summary>
        /// @return Boolean representing the choice.
        public bool CustomUseModelName
        {
            get { return customUseModelName; }
            set
            {
                if (value == customUseModelName) return;
                customUseModelName = value;
                RaisePropertyChanged("CustomUseModelName");
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
