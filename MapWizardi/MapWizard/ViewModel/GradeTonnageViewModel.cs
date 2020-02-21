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
using System.ComponentModel;
using System.IO;
using MahApps.Metro.Controls.Dialogs;
using System.Windows;
using MahApps.Metro.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// This class contains properties that the GradeTonnageView can data bind to.
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
    public class GradeTonnageViewModel : ViewModelBase, INotifyPropertyChanged
    {
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private GradeTonnageModel model;
        private GradeTonnageResultModel result;
        private ViewModelLocator viewModelLocator;
        private bool isBusy;
        private bool useModelName;
        private int selectedIndex;
        private int runStatus;  // 0=error, 1=success, 2=not run yet.
        private ObservableCollection<string> modelNames;
        private string lastRunDate;
        private int selectedModelIndex;
        private bool saveToDepositModels;
        private string depositModelsExtension;
        private bool noFolderNameGiven;

        /// <summary>
        /// Initializes a new instance of the GradeTonnageViewModel class.
        /// </summary>
        /// <param name="logger">Logging for the MapWizard.</param>
        /// <param name="dialogService">Service for using dialogs and notifications.</param>
        /// <param name="settingsService">Service for using and editing settings.</param>
        public GradeTonnageViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            lastRunDate = "Last Run: Never";
            runStatus = 2;
            modelNames = new ObservableCollection<string>();
            selectedModelIndex = 0;
            depositModelsExtension = "";
            saveToDepositModels = false;
            noFolderNameGiven = false;
            useModelName = false;
            var GTFolder = Path.Combine(settingsService.RootPath, "GTModel");
            var GTDirInfo = new DirectoryInfo(GTFolder);
            if (!Directory.Exists(GTFolder))
            {
                Directory.CreateDirectory(GTFolder);
            }
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            SelectFileCommand = new RelayCommand(SelectFile, CanRunTool);
            SelectMetalFileCommand = new RelayCommand(SelectMetalFile, CanRunTool);
            SelectFolderCommand = new RelayCommand(SelectFolder, CanRunTool);
            SelectModelCommand = new RelayCommand(SelectResult, CanRunTool);
            ShowModelDialog = new RelayCommand(OpenModelDialog, CanRunTool);
            viewModelLocator = new ViewModelLocator();
            result = new GradeTonnageResultModel();
            GradeTonnageInputParams inputParams = new GradeTonnageInputParams();
            string projectFolder = Path.Combine(settingsService.RootPath, "GTModel");
            string selectedProjectFolder = Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult");
            if (!Directory.Exists(selectedProjectFolder))
            {
                Directory.CreateDirectory(selectedProjectFolder);
            }
            string param_json = Path.Combine(selectedProjectFolder, "GradeTonnage_input_params.json");
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    Model = new GradeTonnageModel
                    {
                        CSVPath = inputParams.CSVPath,
                        IsTruncated = inputParams.IsTruncated,
                        PdfType = inputParams.PDFType,
                        MinDepositCount = Convert.ToInt32(inputParams.MinDepositCount),
                        RandomSampleCount = Convert.ToInt32(inputParams.RandomSampleCount),
                        Seed = Convert.ToInt32(inputParams.Seed),
                        Folder = inputParams.Folder,
                        ExtensionFolder = inputParams.ExtensionFolder,
                        RunGrade = inputParams.RunGrade,
                        RunTonnage = inputParams.RunTonnage,
                        ModelType = inputParams.ModelType
                    };
                }
                catch(Exception ex)
                {
                    Model = new GradeTonnageModel
                    {
                        CSVPath = "Select Data",
                        Seed = 1,
                        PdfType = "Normal",
                        IsTruncated = "FALSE",
                        MinDepositCount = 30,
                        RandomSampleCount = 1000000,
                        RunGrade = "false",
                        RunTonnage = "false",
                        ExtensionFolder = "",
                        ModelType = "GT"
                    };
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Grade Tonnage tool's inputs correctly.", "Error");
                }
            }
            else
            {
                Model = new GradeTonnageModel
                {
                    CSVPath = "Select Data",
                    Seed = 1,
                    PdfType = "Normal",
                    IsTruncated = "FALSE",
                    MinDepositCount = 30,
                    RandomSampleCount = 1000000,
                    RunGrade = "false",
                    RunTonnage = "false",
                    ExtensionFolder = "",
                    ModelType = "GT"
                };
            }
            if (Directory.GetFiles(selectedProjectFolder).Length != 0)
            {
                LoadResults();
            }
            FindModelnames(projectFolder);
            var lastRunFile = Path.Combine(projectFolder, "GradeTonnage_last_run.lastrun");
            if (File.Exists(lastRunFile))
            {
                LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
            }
        }

        /// <summary>
        /// Run tool command.
        /// </summary>
        /// @return Command.
        public RelayCommand RunToolCommand { get; }

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
        /// Select file command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectFileCommand { get; }

        /// <summary>
        /// Select metalfile command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectMetalFileCommand { get; }

        /// <summary>
        /// Select folder command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectFolderCommand { get; }

        /// <summary>
        /// Pdf types.
        /// </summary>
        /// @return Pdf type collection.
        public ObservableCollection<string> PdfTypes { get; } = new ObservableCollection<string>() { "normal", "kde" };

        /// <summary>
        /// Is truncated?
        /// </summary>
        /// @return Truncation collection.
        public ObservableCollection<string> Truncated { get; } = new ObservableCollection<string>() { "FALSE", "TRUE" };

        /// <summary>
        /// Model for GradeTonnage.
        /// </summary>
        /// @return Model.
        public GradeTonnageModel Model
        {
            get
            {
                return model;
            }
            set
            {
                model = value;
                RaisePropertyChanged("GradeTonnageModel");
            }
        }

        /// <summary>
        /// Gradetonnage result model.
        /// </summary>
        /// @return Result model.
        public GradeTonnageResultModel Result
        {
            get
            {
                return result;
            }
            set
            {
                result = value;
                RaisePropertyChanged("GradeTonnageResultModel");
            }
        }

        /// <summary>
        /// Is busy?
        /// </summary>
        /// @return Boolean representing the state.
        public bool IsBusy
        {
            get { return isBusy; }
            set
            {
                if (isBusy == value) return;
                isBusy = value;
                RaisePropertyChanged(() => IsBusy);
                RunToolCommand.RaiseCanExecuteChanged();
                SelectFileCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Run GradeTonnage with user input.
        /// </summary>
        private async void RunTool()
        {
            logger.Info("-->{0}", this.GetType().Name);
            // 1. Collect input parameters
            string rootFolder = settingsService.RootPath;
            if (UseModelName == false)
            {
                Model.ExtensionFolder = "";
            }
            GradeTonnageInputParams inputParams = new GradeTonnageInputParams
            {
                CSVPath = Model.CSVPath,
                IsTruncated = Model.IsTruncated.ToString(),
                PDFType = Model.PdfType,
                MinDepositCount = Model.MinDepositCount.ToString(),
                RandomSampleCount = Model.RandomSampleCount.ToString(),
                Seed = Model.Seed.ToString(),
                Folder = rootFolder,
                ExtensionFolder = Model.ExtensionFolder,
                RunGrade = Model.RunGrade,
                RunTonnage = Model.RunTonnage,
                ModelType = Model.ModelType
            };
            logger.Trace(
              "GradeTonnageInputParams:\n" +
              "\tCSVPath: '{0}'\n" +
              "\tIsTruncated: '{1}'\n" +
              "\tPDFType: '{2}'\n" +
              "\tMinDepositCount: '{3}'\n" +
              "\tRandomSampleCount: '{4}'\n" +
              "\tSeed:'{5}'",
              inputParams.CSVPath,
              inputParams.IsTruncated,
              inputParams.PDFType,
              inputParams.MinDepositCount,
              inputParams.RandomSampleCount,
              inputParams.Seed,
              inputParams.Folder,
              inputParams.ModelType
            );
            // 2. Execute tool
            GradeTonnageResult tonnageResult = default(GradeTonnageResult);
            IsBusy = true;
            try
            {
                await Task.Run(() =>
                {
                    GradeTonnageTool tool = new GradeTonnageTool();
                    logger.Info("calling GradeTonnageTool.Execute(inputParams)");
                    tonnageResult = tool.Execute(inputParams) as GradeTonnageResult;
                    logger.Trace("GradeTonnageResult:\n" +
              "\tPlotImage: '{0}'\n" +
              "\tTonnagePdf: '{1}'\n" +
              "\tSummary: '{2}'\n" +
              "\tOutput: '{3}'",
              tonnageResult.TonnagePlot,
              tonnageResult.TonnagePdf,
              tonnageResult.TonnageSummary,
              tonnageResult.GradePlot,
              tonnageResult.GradePdf,
              tonnageResult.GradeSummary,
              tonnageResult.Output
            );
                    // 3. Publish results
                    logger.Trace("Publishing results");
                    Result.TonnagePlot = tonnageResult.TonnagePlot;
                    Result.TonnagePlotBitMap = BitmapFromUri(tonnageResult.TonnagePlot);
                    Result.Output = tonnageResult.Output;
                    Result.TonnageSummary = tonnageResult.TonnageSummary;
                    Result.TonnagePdf = tonnageResult.TonnagePdf;
                    Result.GradePlot = tonnageResult.GradePlot;
                    Result.GradePlotBitMap = BitmapFromUri(tonnageResult.GradePlot);
                    Result.GradeSummary = tonnageResult.GradeSummary;
                    Result.GradePdf = tonnageResult.GradePdf;
                });
                var modelFolder = Path.Combine(inputParams.Env.RootPath, "GTModel", Model.ExtensionFolder);
                if (!ModelNames.Contains(modelFolder))
                {
                    ModelNames.Add(modelFolder);
                }
                string lastRunFile = Path.Combine(Path.Combine(inputParams.Env.RootPath, "GTModel", "GradeTonnage_last_run.lastrun"));
                File.Create(lastRunFile);
                dialogService.ShowNotification("GradeTonnageTool completed successfully", "Success");
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to execute REngine() script");
                dialogService.ShowNotification("Run failed. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error"); //Tää on vähän tymä. voihan sen exceptioninki tähän koittaa tunkea, en tiä vaan miltä näyttäs ilman formatointia. joka tapauksessa tää on liian laaja ja geneerinen yms. voihan tähänki laittaa tietty mekaniikan että jos klikkaa sitä viestiä niin avaa koko messagen???? oisko pikkasen hyvä.
                RunStatus = 0;
            }
            finally
            {
                IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Select Grade-Tonnage input file from filesystem.
        /// </summary>
        private void SelectFile()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    model.CSVPath = csvFile;
                    model.CSVPath = csvFile.Replace("\\", "/");
                    model.ModelType = "GT";
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file", "Error");
            }
            finally
            {
                SelectedIndex = 0;  // This is used to disable inputs depending on input type.
                Result.TonnageSummary = "";
                Result.TonnagePdf = "";
                result.TonnagePlot = "";
                Result.GradeSummary = "";
                Result.GradePdf = "";
                result.GradePlot = "";
            }
        }

        /// <summary>
        /// Select Metal Tonnage input file.
        /// </summary>
        private void SelectMetalFile()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    model.CSVPath = csvFile;
                    model.CSVPath = csvFile.Replace("\\", "/");
                    model.ModelType = "MT";
                    model.RunGrade = "False";
                    model.RunTonnage = "True";
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file", "Error");
            }
            finally
            {
                SelectedIndex = 1;  // These are used to disable inputs depending on input type.
                Result.TonnageSummary = "";
                Result.TonnagePdf = "";
                result.TonnagePlot = "";
                Result.GradeSummary = "";
                Result.GradePdf = "";
                result.GradePlot = "";
            }
        }

        /// <summary>
        /// Select folder containing existing Grade-Tonnage Model, copy selected model to GTModel root folder, and show plots and summaries in results-tab.
        /// </summary>
        private void SelectFolder()
        {
            try
            {
                string folder = dialogService.SelectFolderDialog(settingsService.DepositModelsPath, Environment.SpecialFolder.MyComputer);
                if (!string.IsNullOrEmpty(folder))
                {
                    string tonnage_summary = "";
                    string grade_summary = "";
                    Result.TonnagePlot = Path.Combine(folder, "tonnage_plot.jpeg");
                    result.TonnagePlotBitMap = BitmapFromUri(Path.Combine(folder, "tonnage_plot.jpeg"));
                    tonnage_summary = File.ReadAllText(Path.Combine(folder, "tonnage_summary.txt"));//TAGEGD
                    Result.TonnageSummary = tonnage_summary;
                    Result.TonnagePdf = Path.Combine(folder, "tonnage.rds");
                    result.GradePlot = Path.Combine(folder, "grade_plot.jpeg");
                    result.GradePlotBitMap = BitmapFromUri(Path.Combine(folder, "grade_plot.jpeg"));
                    grade_summary = File.ReadAllText(Path.Combine(folder, "grade_summary.txt")); //TAGGED
                    result.GradeSummary = grade_summary;
                    result.GradePdf = Path.Combine(folder, "grade.rds");       //TAGGED  //tonnageResult.GradePdf; //Change name
                    var gtRootPath = Path.Combine(settingsService.RootPath, "GTModel");
                    var gtGradePath = Path.Combine(gtRootPath); //TAGGED
                    var gtGradeDir = new DirectoryInfo(gtGradePath);
                    var gtTonnagePath = Path.Combine(gtRootPath);  //TAGGED
                    var gtTonnageDir = new DirectoryInfo(gtTonnagePath);
                    System.IO.DirectoryInfo di = new DirectoryInfo(gtRootPath);
                    if (!Directory.Exists(gtRootPath))
                    {
                        Directory.CreateDirectory(gtRootPath);
                    }
                    foreach (FileInfo file in di.GetFiles())
                    {
                        file.Delete();
                    }
                    System.IO.DirectoryInfo fi = new DirectoryInfo(folder);
                    foreach (FileInfo fi3 in fi.GetFiles())
                    {
                        File.Copy(Path.Combine(folder, fi3.Name), Path.Combine(gtRootPath, fi3.Name));
                    }
                    if (!ModelNames.Contains(gtRootPath))
                        ModelNames.Add(gtRootPath);
                }
                SelectedIndex = 2; // This is used to disable input controls on GradeTonnageInputView, depending on input type.         
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show FolderBrowserDialog");
                dialogService.ShowNotification("Failed to select existing model", "Error");
            }
        }

        /// <summary>
        /// Select certain result.
        /// </summary>
        private void SelectResult()
        {
            if (ModelNames.Count > 0)
            {
                if (SaveToDepositModels == true && DepositModelsExtension.Length == 0)
                {
                    NoFolderNameGiven = true;
                    return;
                }
                try
                {
                    var modelDirPath = ModelNames[SelectedModelIndex];
                    var modelDirInfo = new DirectoryInfo(ModelNames[SelectedModelIndex]);
                    var gtRootPath = Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult");
                    viewModelLocator.ReportingViewModel.GTModelPath = gtRootPath;
                    viewModelLocator.ReportingViewModel.GTModelName = Path.GetFileName(modelDirPath);
                    viewModelLocator.ReportingViewModel.SaveInputs();
                    if (!Directory.Exists(gtRootPath))
                    {
                        Directory.CreateDirectory(gtRootPath);
                    }
                    if (modelDirPath != gtRootPath)
                    {
                        DirectoryInfo dir = new DirectoryInfo(gtRootPath);
                        foreach (FileInfo file in dir.GetFiles())
                        {
                            file.Delete();
                        }
                        foreach (DirectoryInfo direk in dir.GetDirectories())
                        {
                            direk.Delete(true);
                        }
                        foreach (FileInfo file2 in modelDirInfo.GetFiles()) // Select files from selected model root folder.
                        {
                            var destPath = Path.Combine(gtRootPath, file2.Name);
                            var sourcePath = Path.Combine(modelDirPath, file2.Name);
                            if (File.Exists(destPath))
                            {
                                File.Delete(destPath);
                            }
                            File.Copy(sourcePath, destPath);
                            if (SaveToDepositModels == true)
                            {
                                var depositPath = Path.Combine(settingsService.DepositModelsPath, "DepositModels", "GradeTonnage", DepositModelsExtension);
                                Directory.CreateDirectory(depositPath);
                                destPath = Path.Combine(depositPath, file2.Name);
                                var depositDirInfo = new DirectoryInfo(depositPath);
                                if (File.Exists(destPath))
                                {
                                    File.Delete(destPath);
                                }
                                File.Copy(sourcePath, destPath);
                            }
                        }
                    }
                    else
                    {
                        if (SaveToDepositModels == true)
                        {

                            foreach (FileInfo file in modelDirInfo.GetFiles())  // Select files from selected model root folder.
                            {
                                var sourcePath = Path.Combine(modelDirPath, file.Name);
                                var depositPath = Path.Combine(settingsService.DepositModelsPath, "DepositModels", "GradeTonnage", DepositModelsExtension);
                                Directory.CreateDirectory(depositPath);
                                var destPath = Path.Combine(depositPath, file.Name);
                                var depositDirInfo = new DirectoryInfo(depositPath);
                                if (File.Exists(destPath))
                                {
                                    File.Delete(destPath);
                                }
                                File.Copy(sourcePath, destPath);
                            }
                            foreach (DirectoryInfo di in modelDirInfo.GetDirectories())
                            {
                                var newDirPath = Path.Combine(gtRootPath, di.Name);
                                string sourcePath;
                                string destPath;
                                DirectoryInfo newDirInfo = new DirectoryInfo(newDirPath);
                                Directory.CreateDirectory(Path.Combine(settingsService.DepositModelsPath, "DepositModels", "GradeTonnage", DepositModelsExtension, di.Name));
                                foreach (FileInfo file2 in di.GetFiles())
                                {
                                    sourcePath = Path.Combine(modelDirPath, di.Name, file2.Name);
                                    destPath = Path.Combine(settingsService.DepositModelsPath, "DepositModels", "GradeTonnage", DepositModelsExtension, di.Name, file2.Name);
                                    File.Copy(sourcePath, destPath);
                                }
                            }
                        }
                    }
                    GradeTonnageInputParams inputParams = new GradeTonnageInputParams();
                    string selectedProjectFolder = Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult");
                    if (!Directory.Exists(selectedProjectFolder))
                    {
                        Directory.CreateDirectory(selectedProjectFolder);
                    }
                    string param_json = Path.Combine(selectedProjectFolder, "GradeTonnage_input_params.json");

                    if (File.Exists(param_json))
                    {
                        inputParams.Load(param_json);

                        Model.CSVPath = inputParams.CSVPath;
                        Model.IsTruncated = inputParams.IsTruncated;
                        Model.PdfType = inputParams.PDFType;
                        Model.MinDepositCount = Convert.ToInt32(inputParams.MinDepositCount);
                        Model.RandomSampleCount = Convert.ToInt32(inputParams.RandomSampleCount);
                        Model.Seed = Convert.ToInt32(inputParams.Seed);
                        Model.Folder = inputParams.Folder;
                        Model.ExtensionFolder = inputParams.ExtensionFolder;
                        Model.RunGrade = inputParams.RunGrade;
                        Model.RunTonnage = inputParams.RunTonnage;
                        Model.ModelType = inputParams.ModelType;
                    }
                    dialogService.ShowNotification("Model selected successfully", "Success");
                }
                catch (Exception ex)
                {
                    logger.Trace(ex, "Error in Model Selection");
                    dialogService.ShowNotification("Failed to select model", "Error");
                }
                NoFolderNameGiven = false;
                var metroWindow = (Application.Current.MainWindow as MetroWindow);
                var dialog = metroWindow.GetCurrentDialogAsync<BaseMetroDialog>();
                metroWindow.HideMetroDialogAsync(dialog.Result);
                LoadResults();
            }
        }

        /// <summary>
        /// Find all saved results, which have been made by past runs.
        /// </summary>
        /// <param name="projectFolder">Grade-Tonnage folder.</param>
        private void FindModelnames(string projectFolder)
        {
            DirectoryInfo projectFolderInfo = new DirectoryInfo(projectFolder);  // Search existing models from project folder.
            foreach (DirectoryInfo model in projectFolderInfo.GetDirectories())
            {
                if (model.Name != "SelectedResult")
                {
                    foreach (FileInfo file in model.GetFiles())
                    {
                        if (file.Name == "GradeTonnage_input_params.json")
                        {
                            modelNames.Add(model.FullName);
                        }
                    }
                }
            }
            foreach (FileInfo file in projectFolderInfo.GetFiles())  // Search from main folder.
            {
                if (file.Name == "GradeTonnage_input_params.json")
                {
                    modelNames.Add(projectFolderInfo.FullName);
                }
            }
        }

        /// <summary>
        /// Check if tool can be executed (not busy.)
        /// </summary>
        /// @return Boolean representing the state.
        private bool CanRunTool()
        {
            return !IsBusy;
        }

        /// <summary>
        /// Date of last run
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
        /// Whether last run has been succesful, failed or the tool has not been run yet on this project.
        /// </summary>
        /// @return Integer representing the status.
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
        /// Public index for View to bind to.
        /// </summary>
        /// @return Integer representing the tab.
        public int SelectedIndex
        {
            get { return selectedIndex; }
            set
            {
                if (value == selectedIndex) return;
                selectedIndex = value;
                RaisePropertyChanged("SelectedIndex");
            }
        }

        /// <summary>
        /// Public Model names property
        /// </summary>
        /// @return Collection of models.
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
        /// Public index for View to bind to
        /// </summary>
        /// @return Integer representing the selected model.
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
        /// Extension folder for Deposit model.
        /// </summary>
        /// @return Extendion folder name.
        public string DepositModelsExtension
        {
            get { return depositModelsExtension; }
            set
            {
                if (value == depositModelsExtension) return;
                depositModelsExtension = value;
            }
        }

        /// <summary>
        /// Whether to save to deposit models
        /// </summary>
        /// @return Boolean representing the choice.
        public bool SaveToDepositModels
        {
            get { return saveToDepositModels; }
            set
            {
                if (value == saveToDepositModels) return;
                saveToDepositModels = value;
            }
        }

        /// <summary>
        /// Method stub to show selectPDFs-dialog
        /// </summary>
        public void OpenModelDialog()
        {
            viewModelLocator.Main.DialogContentSource = "GradeTonnageViewModel";
            dialogService.ShowMessageDialog();
        }

        /// <summary>
        /// Boolean representing whether folder name has been given or not.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool NoFolderNameGiven
        {
            get { return noFolderNameGiven; }
            set
            {
                if (value == noFolderNameGiven) return;
                noFolderNameGiven = value;
                RaisePropertyChanged("NoFolderNameGiven");
            }
        }

        /// <summary>
        /// Boolean representing whether to use model name or not.
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
        /// Method to create bitmap from image. Prevents file locks from binding in XAML.
        /// </summary>
        /// <param name="source">Path for bitmap.</param>
        /// <returns>Bitmap.</returns>
        private ImageSource BitmapFromUri(string source)
        {
            if(source == null)
            {
                return null;  // No picture for either grade or tonnage so no error.
            }
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

        /// <summary>
        /// Load results of the last run.
        /// </summary>
        private void LoadResults()
        {
            var GTFolder = Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult");
            var GTGradePdf = Path.Combine(GTFolder, "grade.rds");
            var GTGradePlot = Path.Combine(GTFolder, "grade_plot.jpeg");
            var GTTonnagePdf = Path.Combine(GTFolder, "tonnage.rds");
            var GTGradeSummary = Path.Combine(GTFolder, "grade_summary.txt");
            var GTTonnageSummary = Path.Combine(GTFolder, "tonnage_summary.txt");
            var GTTonnagePlot = Path.Combine(GTFolder, "tonnage_plot.jpeg");
            RunStatus = 1;  // Set status to error if any of the files is not found.
            try
            {
                if (File.Exists(GTGradeSummary))
                {
                    Result.GradeSummary = File.ReadAllText(GTGradeSummary);
                }
                else
                {
                    Result.GradeSummary = null;
                    if (Model.RunGrade == "True")
                    {
                        RunStatus = 0;
                    }
                }
                if (File.Exists(GTGradePdf))
                {
                    Result.GradePdf = GTGradePdf;
                }
                else
                {
                    Result.GradePdf = null;
                    if (Model.RunGrade == "True")
                    {
                        RunStatus = 0;
                    }
                }
                if (File.Exists(GTGradePlot))
                {
                    Result.GradePlot = GTGradePlot;
                    Result.GradePlotBitMap = BitmapFromUri(GTGradePlot);
                }
                else
                {
                    Result.GradePlot = null;
                    Result.GradePlotBitMap = null;
                    if (Model.RunGrade == "True")
                    {
                        RunStatus = 0;
                    }
                }
                if (File.Exists(GTTonnagePlot))
                {
                    Result.TonnagePlot = GTTonnagePlot;
                    Result.TonnagePlotBitMap = BitmapFromUri(GTTonnagePlot);
                }
                else
                {
                    Result.TonnagePlot = null;
                    Result.TonnagePlotBitMap = null;
                    if (Model.RunTonnage == "True")
                    {
                        RunStatus = 0;
                    }
                }
                if (File.Exists(GTTonnagePdf))
                {
                    Result.TonnagePdf = File.ReadAllText(GTTonnagePdf);
                }
                else
                {
                    Result.TonnagePdf = null;
                    if (Model.RunTonnage == "True")
                    {
                        RunStatus = 0;
                    }
                }
                if (File.Exists(GTTonnageSummary))
                {
                    Result.TonnageSummary = File.ReadAllText(GTTonnageSummary);
                }
                else
                {
                    Result.TonnageSummary = null;
                    if (Model.RunTonnage == "True")
                    {
                        RunStatus = 0;
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex + " Could not load results files");
                dialogService.ShowNotification("Failed to load Grade Tonnage tool's result files", "Error");
            }
        }
    }
}

