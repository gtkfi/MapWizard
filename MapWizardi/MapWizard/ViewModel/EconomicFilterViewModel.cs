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
using System.Diagnostics;
using System.ComponentModel;
using System.Windows;
using MahApps.Metro.Controls;
using MahApps.Metro.Controls.Dialogs;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// This class contains properties that the EconomicFilterView can data bind to.
    /// </summary>
    public class EconomicFilterViewModel : ViewModelBase, INotifyPropertyChanged
    {
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private EconomicFilterModel model;
        private EconomicFilterResultModel result;
        private ViewModelLocator viewModelLocator;
        private bool isBusy;
        private ObservableCollection<string> metals;
        private ObservableCollection<string> raefModelNames;
        private ObservableCollection<string> screenerModelNames;
        private int tabIndex;
        private bool raefUseModelName;
        private bool screenerUseModelName;
        private int raefSelectedModelIndex;
        private int screenerSelectedModelIndex;
        private bool noFolderNameGiven;
        private string lastRunDate;
        private int runStatus;

        /// <summary>
        /// Initializes a new instance of the EconomicFilterViewModel class.
        /// </summary>
        /// <param name="logger">Logging for the MapWizard.</param>
        /// <param name="dialogService">Service for using dialogs and notifications.</param>
        /// <param name="settingsService">Service for using and editing settings.</param>
        public EconomicFilterViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            lastRunDate = "Last Run: Never";
            runStatus = 2;
            tabIndex = 0;
            noFolderNameGiven = false;
            raefUseModelName = false;
            screenerUseModelName = false;
            raefSelectedModelIndex = 0;
            raefSelectedModelIndex = 0;
            raefModelNames = new ObservableCollection<string>();
            screenerModelNames = new ObservableCollection<string>();
            viewModelLocator = new ViewModelLocator();
            result = new EconomicFilterResultModel();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            SelectMCSimResultCommand = new RelayCommand(SelectMCSimResult, CanRunTool);
            OpenEcoTonnagesStatFileCommand = new RelayCommand(OpenEcoTonnagesStatFile, CanRunTool);
            OpenEcoTonnagesResultFileCommand = new RelayCommand(OpenEcoTonnagesResultFile, CanRunTool);
            SelectRaefPackageFolderCommand = new RelayCommand(SelectRAEFPackageFolder, CanRunTool);
            SelectRaefPresetFileCommand = new RelayCommand(SelectRAEFPresetFile, CanRunTool);
            ShowRaefResultsCommand = new RelayCommand(ShowRaefResults, CanRunTool);
            SelectRaefEconFilterFileCommand = new RelayCommand(SelectRaefEconFilterFile, CanRunTool);
            RaefShowModelDialog = new RelayCommand(RaefOpenModelDialog, CanRunTool);
            ScreenerShowModelDialog = new RelayCommand(ScreenerOpenModelDialog, CanRunTool);
            RaefSelectModelCommand = new RelayCommand(RaefSelectResult, CanRunTool);
            ScreenerSelectModelCommand = new RelayCommand(ScreenerSelectResult, CanRunTool);
            EconomicFilterInputParams inputParams = new EconomicFilterInputParams();
            string projectFolder = Path.Combine(settingsService.RootPath, "EconFilter");
            if (!Directory.Exists(projectFolder))
            {
                Directory.CreateDirectory(projectFolder);
            }
            string param_json = Path.Combine(projectFolder, "economic_filter_input_params.json");
            Model = new EconomicFilterModel
            {
                MonteCarloResultTable = "",
                RaefPresetFile = "Choose file",
                RaefEconFilterFile = "Choose file",
                RaefExtensionFolder = "",
                ScreenerExtensionFolder = ""
            };
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    Model = new EconomicFilterModel
                    {
                        //MonteCarloResultTable = inputParams.MCResults // Screener not in use in beta version, include this later.
                    };
                    if (String.IsNullOrEmpty(Model.MonteCarloResultTable))
                    {
                        Model.MonteCarloResultTable = "Please select monte Carlo simulation result table";
                        MetalIds = null;
                    }
                    else
                    {
                        //MetalIds = setMetalIds(); Screener not in use in beta version, include this later.
                        Model = new EconomicFilterModel
                        {
                            MonteCarloResultTable = inputParams.MCResults,
                            SelectedMetal = inputParams.Metal,
                            SelectedMetalIndex = inputParams.MetalIndex,
                            PerType = inputParams.perType,
                            PerCent = inputParams.percentage,
                            ScreenerExtensionFolder = inputParams.ScreenerExtensionFolder,
                            RaefPresetFile = inputParams.RaefPresetFile,
                            RaefEconFilterFile = inputParams.RaefEconFilterFile
                        };
                    }
                }
                catch (Exception ex)
                {
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Economic Filter tool's inputs correctly.", "Error");
                }
            }
            if (String.IsNullOrEmpty(Model.MonteCarloResultTable))
            {
                Model.MonteCarloResultTable = "Please select monte Carlo simulation result table";
                MetalIds = null;
            }
            if (String.IsNullOrEmpty(Model.RaefPresetFile))
            {
                Model.RaefPresetFile = "Choose file";
            }
            if (String.IsNullOrEmpty(Model.RaefEconFilterFile))
            {
                Model.RaefEconFilterFile = "Choose file";
            }
            //LoadScreenerResults();
            if (Directory.Exists(Path.Combine(projectFolder, "RAEF", "SelectedResult")))
            {
                if (Directory.GetFiles(Path.Combine(projectFolder, "RAEF", "SelectedResult")).Length != 0)
                {
                    LoadRaefResults();  // Load last run.
                }
            }
            if (Directory.Exists(Path.Combine(projectFolder, "RAEF")))
            {
                FindRaefModelnames(projectFolder);  // Find saved results.
            }
            //FindScreenerModelNames
            var lastRunFile = Path.Combine(settingsService.RootPath, "EconFilter", "economic_filter_last_run.lastrun");
            if (File.Exists(lastRunFile))
            {
                LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
            }
        }

        /// <summary>
        /// PerTypes.
        /// </summary>
        /// @return PerTypes.
        public ObservableCollection<string> PerTypes { get; } = new ObservableCollection<string>() { "Count %", "Metal %" };

        /// <summary>
        /// Run tool command.
        /// </summary>
        /// @return Command.
        public RelayCommand RunToolCommand { get; }

        /// <summary>
        /// Show results command.
        /// </summary>
        /// @return Command.
        public RelayCommand ShowRaefResultsCommand { get; }

        /// <summary>
        /// Select Monte Carlo Simulator result command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectMCSimResultCommand { get; }

        /// <summary>
        /// Open file command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenEcoTonnagesStatFileCommand { get; }

        /// <summary>
        /// Open file command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenEcoTonnagesResultFileCommand { get; }

        /// <summary>
        /// Open folder command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectRaefPackageFolderCommand { get; }

        /// <summary>
        /// Open file command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectRaefPresetFileCommand { get; }

        /// <summary>
        /// Open file command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectRaefEconFilterFileCommand { get; }

        /// <summary>
        /// Show dialog command.
        /// </summary>
        /// @return Command.
        public RelayCommand RaefShowModelDialog { get; }

        /// <summary>
        /// Show dialog command.
        /// </summary>
        /// @return Command.
        public RelayCommand ScreenerShowModelDialog { get; }

        /// <summary>
        /// Select model command.
        /// </summary>
        /// @return Command.
        public RelayCommand RaefSelectModelCommand { get; }

        /// <summary>
        /// Select model command.
        /// </summary>
        /// @return Command.
        public RelayCommand ScreenerSelectModelCommand { get; }

        /// <summary>
        /// Run tool with user input.
        /// </summary>
        private async void RunTool()
        {
            logger.Info("-->{0}", this.GetType().Name);
            if (TabIndex == 1)
            {
                int selectedMetalIndex = GetMetalIndex(Model.SelectedMetal);
                Model.SelectedMetalIndex = selectedMetalIndex.ToString();
            }
            if (RaefUseModelName == false)
            {
                Model.RaefExtensionFolder = "";
            }
            if (ScreenerUseModelName == false)
            {
                Model.ScreenerExtensionFolder = "";
            }
            // 1. Collect input parameters
            EconomicFilterInputParams input = new EconomicFilterInputParams
            {
                MCResults = Model.MonteCarloResultTable,
                Metal = Model.SelectedMetal,
                MetalIndex = Model.SelectedMetalIndex,
                MetalsToCalculate = Model.MetalsToCalculate,
                perType = Model.PerType,
                percentage = Model.PerCent,
                ModelIndex = TabIndex.ToString(),
                RaefPackageFolder = Model.RaefPackageFolder,
                RaefExtensionFolder = Model.RaefExtensionFolder,
                ScreenerExtensionFolder = Model.ScreenerExtensionFolder,
                RaefPresetFile = Model.RaefPresetFile,
                RaefEconFilterFile = Model.RaefEconFilterFile
            };
            // 2. Execute tool
            EconomicFilterResult ddResult = default(EconomicFilterResult);
            IsBusy = true;
            try
            {
                await Task.Run(() =>
                {
                    EconomicFilterTool tool = new EconomicFilterTool();
                    ddResult = tool.Execute(input) as EconomicFilterResult;
                    Result.EcoTonnages = ddResult.EcoTonnage;
                    Result.EcoTonnageStats = ddResult.EcoTonnageStats;
                    Result.EcoTonHistrogram = ddResult.EcoTonHistogram;
                    Result.ResultPlot = ddResult.ResultPlot;
                    if (ddResult.ResultPlot != null)
                        Result.ScreenerPlotBitMap = BitmapFromUri(ddResult.ResultPlot);  // Create a bitmap for view to bind to, to preent result plot file locking.
                    if (ddResult.EcoTonHistogram != null)
                        Result.ScreenerHistogramBitMap = BitmapFromUri(ddResult.EcoTonHistogram);
                });
                var raefModelFolder = Path.Combine(input.Env.RootPath, "EconFilter", "RAEF", Model.RaefExtensionFolder);
                if (!RaefModelNames.Contains(raefModelFolder))
                    RaefModelNames.Add(raefModelFolder);
                var screenerModelFolder = Path.Combine(input.Env.RootPath, "EconFilter", "Screener", Model.ScreenerExtensionFolder);
                if (!ScreenerModelNames.Contains(screenerModelFolder))
                    ScreenerModelNames.Add(screenerModelFolder);

                string lastRunFile = Path.Combine(Path.Combine(settingsService.RootPath, "EconFilter", "economic_filter_last_run.lastrun"));
                File.Create(lastRunFile);
                dialogService.ShowNotification("Economic Filter tool completed successfully", "Success");
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
        /// Select result for Raef.
        /// </summary>
        private void RaefSelectResult()
        {
            if (RaefModelNames.Count > 0)
            {

                try
                {
                    var modelDirPath = RaefModelNames[RaefSelectedModelIndex];
                    var modelDirInfo = new DirectoryInfo(RaefModelNames[RaefSelectedModelIndex]);
                    var efRootPath = Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", "SelectedResult");
                    viewModelLocator.ReportingViewModel.IsRaefDone = "Yes";
                    viewModelLocator.ReportingViewModel.SaveInputs();
                    if (!Directory.Exists(efRootPath))
                    {
                        Directory.CreateDirectory(efRootPath);
                    }

                    // If selected model folder is not raef root
                    if (modelDirPath != efRootPath)
                    {  
                        DirectoryInfo dir = new DirectoryInfo(efRootPath);
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
                            var destPath = Path.Combine(efRootPath, file2.Name);
                            var sourcePath = Path.Combine(modelDirPath, file2.Name);
                            if (File.Exists(destPath))
                            {
                                File.Delete(destPath);
                            }
                            File.Copy(sourcePath, destPath); // Copy files to new Root folder.
                        }
                    }
                    EconomicFilterInputParams inputParams = new EconomicFilterInputParams();
                    string selectedProjectFolder = Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", "SelectedResult");
                    string param_json = Path.Combine(selectedProjectFolder, "economic_filter_input_params.json");
                    if (File.Exists(param_json))
                    {
                        inputParams.Load(param_json);

                        Model.MonteCarloResultTable = inputParams.MCResults;
                        Model.RaefPresetFile = inputParams.RaefPresetFile;
                        Model.RaefEconFilterFile = inputParams.RaefEconFilterFile;
                        Model.RaefExtensionFolder = inputParams.RaefExtensionFolder;
                        Model.RaefPackageFolder = inputParams.RaefPackageFolder;
                        Model.SelectedMetal = inputParams.Metal;
                        Model.SelectedMetalIndex = inputParams.MetalIndex;
                        Model.MetalsToCalculate = inputParams.MetalsToCalculate;
                        Model.PerType = inputParams.perType;
                        Model.PerCent = inputParams.percentage;
                        TabIndex = Convert.ToInt32(inputParams.ModelIndex);
                        Model.ScreenerExtensionFolder = inputParams.ScreenerExtensionFolder;
                    }
                    LoadRaefResults();
                }
                catch (Exception ex)
                {
                    logger.Trace(ex, "Error in Model Selection:");
                    dialogService.ShowNotification("Run failed. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                }
                NoFolderNameGiven = false;
                    var metroWindow = (Application.Current.MainWindow as MetroWindow);
                    var dialog = metroWindow.GetCurrentDialogAsync<BaseMetroDialog>();
                    metroWindow.HideMetroDialogAsync(dialog.Result);
            }
        }

        /// <summary>
        /// Select result for Screener.
        /// </summary>
        private void ScreenerSelectResult()
        {
            if (ScreenerModelNames.Count > 0)
            {
                try
                {  
                    var modelDirPath = ScreenerModelNames[ScreenerSelectedModelIndex];
                    var modelDirInfo = new DirectoryInfo(ScreenerModelNames[ScreenerSelectedModelIndex]);
                    var efRootPath = Path.Combine(settingsService.RootPath, "EconFilter", Model.ScreenerExtensionFolder, "SelectedResult");
                    if (!Directory.Exists(efRootPath))
                    {
                        Directory.CreateDirectory(efRootPath);
                    }
                    if (modelDirPath != efRootPath)
                    {  
                        DirectoryInfo dir = new DirectoryInfo(efRootPath);
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
                            var destPath = Path.Combine(efRootPath, file2.Name);
                            var sourcePath = Path.Combine(modelDirPath, file2.Name);
                            if (File.Exists(destPath))
                            {
                                File.Delete(destPath);
                            }
                            File.Copy(sourcePath, destPath); // Copy files to new Root folder.
                        }
                    }
                }
                catch (Exception ex)
                {
                    logger.Trace(ex, "Error in Model Selection:");

                }
                NoFolderNameGiven = false;
                    var metroWindow = (Application.Current.MainWindow as MetroWindow);
                    var dialog = metroWindow.GetCurrentDialogAsync<BaseMetroDialog>();
                    metroWindow.HideMetroDialogAsync(dialog.Result);
            }
        }

        /// <summary>
        /// Select MCSim file.
        /// </summary>
        private void SelectMCSimResult()
        {
            try
            {
                string objectFile = dialogService.OpenFileDialog(Path.Combine(settingsService.RootPath, "MCSim"), "", true, true);
                if (!string.IsNullOrEmpty(objectFile))
                {
                    Model.MonteCarloResultTable = objectFile.Replace("\\", "/");
                    MetalIds = SetMetalIds();
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
            finally
            {
            }

        }

        /// <summary>
        /// Metal Index.
        /// </summary>
        /// <param name="selected">Index</param>
        /// <returns>Index value.</returns>
        private int GetMetalIndex(string selected)
        {
            int retValue = 0;
            try
            {
                var reader = new StreamReader(Model.MonteCarloResultTable);
                using (reader)
                {
                    ObservableCollection<string> metalValues = new ObservableCollection<string>();
                    // Read firstline -> do nothing.
                    var line = reader.ReadLine();
                    // Read nextline -> get data.
                    var values = line.Split(',');
                    Model.MetalsToCalculate = null; 
                    for (int i = 0; i < values.Length; i++)
                    {
                        if (values[i] == selected)
                            retValue = i + 1;
                        if (values[i].Contains(" _MetricTons"))
                        {
                            Model.MetalsToCalculate += Model.MetalsToCalculate == null ? (i + 1).ToString() : "," + (i + 1).ToString(); // Null conditional might not woork when the list is empty?
                        }
                    }

                }
            }
            catch (Exception e)
            {
                logger.Error(e, "Failed to read metal index");
                throw;
                //throw new Exception("Reading metal index failed: " + result, e);
            }
            return retValue;
        }

        /// <summary>
        /// Public property for RAEF model names.
        /// </summary>
        /// @return Collection of Raef run names.
        public ObservableCollection<string> RaefModelNames
        {
            get { return raefModelNames; }
            set
            {
                if (value == raefModelNames) return;
                raefModelNames = value;
            }

        }

        /// <summary>
        /// Public property for screener model names
        /// </summary>
        /// @return Collection of Raef run names.
        public ObservableCollection<string> ScreenerModelNames
        {
            get { return screenerModelNames; }
            set
            {
                if (value == screenerModelNames) return;
                screenerModelNames = value;
            }

        }

        /// <summary>
        /// Method to open dialog and saving its result for RAEF preset file.
        /// </summary>
        public void SelectRAEFPresetFile()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    Model.RaefPresetFile = csvFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
        }

        /// <summary>
        /// Method to open dialog and saving its result for RAEF economic filter file.
        /// </summary>
        public void SelectRaefEconFilterFile()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    Model.RaefEconFilterFile = csvFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
        }

        /// <summary>
        /// Function to select raef package folder
        /// </summary>
        public void SelectRAEFPackageFolder()
        {
            try
            {
                string folder = dialogService.SelectFolderDialog(Model.RaefPackageFolder, Environment.SpecialFolder.MyComputer);
                if (!string.IsNullOrEmpty(folder))
                {
                    Model.RaefPackageFolder = folder;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to Show OpenFolderDialog");
            }
        }

        /// <summary>
        /// Function to set metal Ids for screener
        /// </summary>
        /// <returns>Collection of metal values.</returns>
        private ObservableCollection<string> SetMetalIds()
        {
            if (Model.MonteCarloResultTable == "Please select monte Carlo simulation result table")
            {
                return new ObservableCollection<string>() { " - " };
            }
            else
            {
                try
                {
                    using (var reader = new StreamReader(Model.MonteCarloResultTable))
                    {
                        ObservableCollection<string> metalValues = new ObservableCollection<string>();
                        // Read firstline -> do nothing.
                        var line = reader.ReadLine();
                        // Read nextline -> get data.
                        var values = line.Split(',');
                        Model.MetalsToCalculate = "";
                        for (int i = 0; i < values.Length; i++)
                        {
                            if (values[i].Contains(" _MetricTons"))
                            {
                                metalValues.Add(values[i]);
                                Model.MetalsToCalculate += Model.MetalsToCalculate == "" ? i.ToString() : "," + i.ToString();
                            }
                        }
                        return metalValues;
                    }
                }
                catch (Exception ex)
                {
                    logger.Error(ex, "Error in reading table:" + ex);
                    dialogService.ShowNotification("Error in reading table. Check output for details. ", "Error");
                    //throw new Exception("Error in reading table: "+ex);
                    return new ObservableCollection<string>() { " - " }; ;
                }
            }
        }

        /// <summary>
        /// Load Screener results of the last run.
        /// </summary>
        public void LoadScreenerResults()
        {
            var projectFolder = Path.Combine(settingsService.RootPath, "EconFilter", "Screener");
            var EcoTonnage = Path.Combine(projectFolder, "eco_tonnages.csv");
            var EcoTonnageStats = Path.Combine(projectFolder, "eco_tonnage_stat.csv"); //Correct path?
            var EcoTonHistogram = Path.Combine(projectFolder, "eco_ton_histogram.jpeg");
            var ResultPlot = Path.Combine(projectFolder, "result_plot.jpeg");

            try
            {
                if (File.Exists(EcoTonnage))
                {
                    Result.EcoTonnages = EcoTonnage;
                }
                else
                    Result.EcoTonnages = null;

                if (File.Exists(EcoTonnageStats))
                    Result.EcoTonnageStats = EcoTonnageStats;
                else
                    Result.EcoTonnageStats = null;

                if (File.Exists(EcoTonHistogram))
                    Result.EcoTonHistrogram = EcoTonHistogram;
                else
                    Result.EcoTonHistrogram = null;

                if (File.Exists(ResultPlot))
                {
                    Result.ResultPlot = ResultPlot;
                }
                else
                    Result.ResultPlot = null;

            }
            catch (Exception ex)
            {
                logger.Error(ex + " Could not load results files");
            }
        }

        /// <summary>
        /// Load Raef results of the last run.
        /// </summary>
        private void LoadRaefResults()
        {
            var projectFolder = Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", "SelectedResult");
            bool EF1Exists = false;
            bool EF4Exists = false;
            RunStatus = 0;
            try 
            {
                if (Directory.Exists(projectFolder))
                {
                    DirectoryInfo di = new DirectoryInfo(projectFolder);
                    foreach (FileInfo file in di.GetFiles())
                    {
                        if (file.Name.Contains("EF_01_Parameters_"))
                        {
                            EF1Exists = true;
                        }
                        if (file.Name.Contains("EF_04_Contained_Stats_")) //File.Exists(Path.Combine(input.Env.RootPath, "EconFilter", "RAEF", "SelectedResult", "EF_04_Contained_Stats_C.csv"))
                        {
                            EF4Exists = true;
                        }
                    }
                    if (EF1Exists == true && EF4Exists == true)
                    {
                        RunStatus = 1;
                    }
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
        /// <param name="projectFolder">Models's folder.</param>
        private void FindRaefModelnames(string projectFolder)
        {
            string raefProjectFolder = Path.Combine(projectFolder, "RAEF");
            DirectoryInfo raefFolderInfo = new DirectoryInfo(raefProjectFolder);
            foreach (DirectoryInfo result in raefFolderInfo.GetDirectories())
            {
                if (result.Name != "SelectedResult")
                {
                    foreach (FileInfo file in result.GetFiles())
                    {
                        if (file.Name == "economic_filter_input_params.json")
                        {
                            raefModelNames.Add(result.FullName);
                        }
                    }
                }
            }
            // Goes also through the main folder.
            foreach (FileInfo file in raefFolderInfo.GetFiles()) 
            {
                if (file.Name == "economic_filter_input_params.json")
                {
                    raefModelNames.Add(raefFolderInfo.FullName);
                }
            }
        }

        /// <summary>
        /// Check if tool can be executed.
        /// </summary>
        /// <returns> Boolean representing whether tool can be run</returns>
        private bool CanRunTool()
        {
            return !IsBusy;
        }

        /// <summary>
        /// Method stub to show selectPDFs-dialog
        /// </summary>
        public void RaefOpenModelDialog()
        {
            viewModelLocator.Main.DialogContentSource = "EconomicFilterViewModel(RAEF)";
            dialogService.ShowMessageDialog();
        }

        /// <summary>
        /// Method stub to show selectPDFs-dialog
        /// </summary>
        public void ScreenerOpenModelDialog()
        {
            viewModelLocator.Main.DialogContentSource = "EconomicFilterViewModel(Screener)";
            dialogService.ShowMessageDialog();
        }

        /// <summary>
        /// Method to open Eco tonnage stats result file in default program associated with csv files.
        /// </summary>
        private void OpenEcoTonnagesStatFile()
        {
            // projectFolder + TracktID + "_05_SIM_EF.csv"
            //string resultExcel = projectFolder + tracktID + "\\" + tracktID + "_05_SIM_EF.csv";
            try
            {
                Process.Start(result.EcoTonnageStats);
            }
            catch (Exception ex)
            {
                logger.Error(ex + " CSV file not found.");
            }
        }

        /// <summary>
        /// Method to open Eco tonnages result file in default program associated with csv files.
        /// </summary>
        private void OpenEcoTonnagesResultFile()
        {
            try
            {
                Process.Start(result.EcoTonnages);
            }
            catch (Exception ex)
            {
                logger.Error(ex + "CSV file not found.");
            }
        }

        /// <summary>
        /// Method to open Raef result folder in in file explorer.
        /// </summary>
        private void ShowRaefResults()
        {
            try
            {
                if (Model.RaefExtensionFolder == null)//
                {
                    Model.RaefExtensionFolder = "";
                }
                if (Directory.Exists(Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", model.RaefExtensionFolder)))
                {
                    Process.Start(Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", model.RaefExtensionFolder));
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex + "Failed to open results folder.");
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

        /// <summary>
        /// Public tabindex property for the View to bind to.
        /// </summary>
        /// @return Bitmap.
        public int TabIndex
        {
            get { return tabIndex; }
            set
            {
                if (value == tabIndex) return;
                tabIndex = value;
                RaisePropertyChanged("TabIndex");
            }
        }

        /// <summary>
        /// Economic filter model.
        /// </summary>
        /// @return Model.
        public EconomicFilterModel Model
        {
            get
            {
                return model;
            }
            set
            {
                model = value;
                RaisePropertyChanged("EconomicFilterModel");
            }
        }

        /// <summary>
        /// Economic Filter result model.
        /// </summary>
        /// @return Result model.
        public EconomicFilterResultModel Result
        {
            get
            {
                return result;
            }
            set
            {
                result = value;
                RaisePropertyChanged("EconomicFilterResultModel");
            }
        }

        /// <summary>
        /// Public property for Screener metal Ids
        /// </summary>
        /// @return ID collection.
        public ObservableCollection<string> MetalIds
        {
            get
            {
                return metals;
            }
            set
            {
                metals = value;
                RaisePropertyChanged("MetalIds");
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
            }
        }

        /// <summary>
        /// Public property for whether Raef should use model name
        /// </summary>
        /// @return Boolean representing the choice.
        public bool RaefUseModelName
        {
            get { return raefUseModelName; }
            set
            {
                if (value == raefUseModelName) return;
                raefUseModelName = value;
                RaisePropertyChanged("RaefUseModelName");
            }
        }

        /// <summary>
        /// Public property for whether Screener should use model name
        /// </summary>
        /// @return Boolean representing the choice.
        public bool ScreenerUseModelName
        {
            get { return screenerUseModelName; }
            set
            {
                if (value == screenerUseModelName) return;
                screenerUseModelName = value;
                RaisePropertyChanged("ScreenerUseModelName");
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
        /// Date of last run.
        /// </summary>
        /// @return Boolean representing the state.
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
        /// Determines if the folder name id given.
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
        /// Public property indicating the selected RAEF model index, for the view to bind to.
        /// </summary>
        /// @return Boolean representing the choice.
        public int RaefSelectedModelIndex
        {
            get { return raefSelectedModelIndex; }
            set
            {
                if (value == raefSelectedModelIndex) return;
                raefSelectedModelIndex = value;
                RaisePropertyChanged("RaefSelectedModelIndex");
            }
        }

        /// <summary>
        ///  Public property indicating the selected screener model index, for the view to bind to.
        /// </summary>
        /// @return Boolean representing the choice.
        public int ScreenerSelectedModelIndex
        {
            get { return screenerSelectedModelIndex; }
            set
            {
                if (value == screenerSelectedModelIndex) return;
                screenerSelectedModelIndex = value;
                RaisePropertyChanged("ScreenerSelectedModelIndex");
            }
        }
    }
}


