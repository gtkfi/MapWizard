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
using System.Text;
using System.Collections.Generic;
using System.Linq;

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
            viewModelLocator = new ViewModelLocator();
            result = new EconomicFilterResultModel();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            SelectMCSimResultCommand = new RelayCommand(SelectMCSimResult, CanRunTool);
            TractChangedCommand = new RelayCommand(TractChanged, CanRunTool);
            FindTractsCommand = new RelayCommand(FindTractIDs, CanRunTool);
            OpenEcoTonnagesStatFileCommand = new RelayCommand(OpenEcoTonnagesStatFile, CanRunTool);
            OpenEcoTonnagesResultFileCommand = new RelayCommand(OpenEcoTonnagesResultFile, CanRunTool);
            SelectRaefPackageFolderCommand = new RelayCommand(SelectRAEFPackageFolder, CanRunTool);
            SelectRaefPresetFileCommand = new RelayCommand(SelectRAEFPresetFile, CanRunTool);//TÄSSÄ OLI SelectRAEFPresetFile. muuta takas.
            ShowRaefResultsCommand = new RelayCommand(ShowRaefResults, CanRunTool);
            SelectRaefEconFilterFileCommand = new RelayCommand(SelectRaefEconFilterFile, CanRunTool);
            RaefShowModelDialog = new RelayCommand(RaefOpenModelDialog, CanRunTool);
            ScreenerShowModelDialog = new RelayCommand(ScreenerOpenModelDialog, CanRunTool);
            RaefSelectModelCommand = new RelayCommand(RaefSelectResult, CanRunTool);
            ScreenerSelectModelCommand = new RelayCommand(ScreenerSelectResult, CanRunTool);
            SelectGTMFileCommand = new RelayCommand(SelectGTMFile, CanRunTool);
            OpenScreenerHistogramCommand = new RelayCommand(OpenScreenerHistogram, CanRunTool);
            OpenScreenerPlotCommand = new RelayCommand(OpenScreenerPlot, CanRunTool);
            EconomicFilterInputParams inputParams = new EconomicFilterInputParams();
            string projectFolder = Path.Combine(settingsService.RootPath, "EconFilter");
            if (!Directory.Exists(projectFolder))
            {
                Directory.CreateDirectory(projectFolder);
            }
            string param_json = Path.Combine(projectFolder, "economic_filter_input_params.json");
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    Model = new EconomicFilterModel
                    {
                        //MonteCarloResultTable = inputParams.MCResults // Screener not in use in beta version, include this later.
                    };
                    //MetalIds = setMetalIds(); Screener not in use in beta version, include this later.
                    Model = new EconomicFilterModel
                    {
                        MonteCarloResultTable = inputParams.MCResults,
                        SelectedMetal = inputParams.Metal,
                        SelectedMetalIndex = inputParams.MetalIndex,
                        PerType = inputParams.perType,
                        PerCent = inputParams.percentage,
                        SelectedTract = inputParams.TractID,
                        ScreenerExtensionFolder = inputParams.ScreenerExtensionFolder,  // TAGGED: Raef extension folder?
                        RaefPresetFile = inputParams.RaefPresetFile,
                        RaefEconFilterFile = inputParams.RaefEconFilterFile,
                        RaefRunName = inputParams.RaefRunName,
                        LastRunTract = "Tract: "+inputParams.LastRunTract
                    };
                }
                catch (Exception ex)
                {
                    Model = new EconomicFilterModel();
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Economic Filter tool's inputs correctly. Inputs were initialized to default values.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Economic Filter tool's inputs correctly. Inputs were initialized to default values.", "Error");
                }
            }
            else
            {
                Model = new EconomicFilterModel();
            }
            //LoadScreenerResults();
            FindTractIDs();
            LoadRaefResults();  // Load last run.
            if (Model.SelectedTract != null)
            {
                projectFolder = Path.Combine(projectFolder, "RAEF", Model.SelectedTract);
                if (Directory.Exists(projectFolder))
                {
                    Model.RaefModelNames.Clear();
                    FindRaefModelnames(projectFolder);  // Find saved results.
                }
            }
            //FindScreenerModelNames
            var lastRunFile = Path.Combine(settingsService.RootPath, "EconFilter", "economic_filter_last_run.lastrun");
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
        public RelayCommand SelectGTMFileCommand { get; }

        /// <summary>
        /// Open histogram command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenScreenerHistogramCommand { get; }

        /// <summary>
        /// Open plot command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenScreenerPlotCommand { get; }

        /// <summary>
        /// Run tool with user input.
        /// </summary>
        private async void RunTool()
        {
            
            if (Model.UseRaefInputParams == true && Model.TabIndex != 1 && Model.RaefEmpiricalModel == false)
            {
                Model.RaefPresetFile = WriteCsvFile();
                if (Model.RaefPresetFile == "Choose file")
                    return;
            }
                

            logger.Info("-->{0}", this.GetType().Name);
            if (Model.TabIndex == 1)
            {
                int selectedMetalIndex = GetMetalIndex(Model.SelectedMetal);
                Model.SelectedMetalIndex = selectedMetalIndex.ToString();
            }
            if (Model.RaefUseModelName == false)
            {
                Model.RaefExtensionFolder = "";
            }
            if (Model.ScreenerUseModelName == false)
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
                ModelIndex = Model.TabIndex.ToString(),
                RaefPackageFolder = Model.RaefPackageFolder,
                TractID = Model.SelectedTract,
                RaefExtensionFolder = Model.RaefExtensionFolder,
                ScreenerExtensionFolder = Model.ScreenerExtensionFolder,
                RaefPresetFile = Model.RaefPresetFile,
                RaefEconFilterFile = Model.RaefEconFilterFile,
                RaefEmpiricalModel = Model.RaefEmpiricalModel.ToString(),
                RaefGtmFile = Model.RaefGTMFile,
                RaefRunName = Model.RaefRunName,
                LastRunTract = Model.SelectedTract
                //voi tähän tuleekin sitten aika paljon lisää tavaraa... :)
            };
            // 2. Execute tool
            EconomicFilterResult ddResult = default(EconomicFilterResult);
            Model.IsBusy = true;
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

                var raefModelFolder = "";
                if (Model.TabIndex != 1)
                {
                    raefModelFolder = Path.Combine(input.Env.RootPath, "EconFilter", "RAEF", Model.SelectedTract);
                    Model.RaefModelNames.Clear();
                    FindRaefModelnames(raefModelFolder);
                }
                 // Find saved results.
                //var screenerModelFolder = Path.Combine(input.Env.RootPath, "EconFilter", "Screener", Model.ScreenerExtensionFolder);
                //if (!Model.ScreenerModelNames.Contains(screenerModelFolder))
                //    Model.ScreenerModelNames.Add(screenerModelFolder);

                string lastRunFile = Path.Combine(Path.Combine(settingsService.RootPath, "EconFilter", "economic_filter_last_run.lastrun"));
                File.Create(lastRunFile).Close();
                dialogService.ShowNotification("Economic Filter tool completed successfully", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Economic Filter tool completed successfully", "Success");
                Model.LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                Model.LastRunTract = "Tract: " + Model.SelectedTract;
                Model.RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to execute REngine() script");
                dialogService.ShowNotification("Run failed. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Economic Filter tool run failed. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                Model.LastRunTract = "Tract: " + Model.SelectedTract;
                Model.RunStatus = 0;
            }
            finally
            {
                Model.IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Select result for Raef.
        /// </summary>
        private void RaefSelectResult()
        {
            if (Model.RaefModelNames.Count <= 0)
            {
                dialogService.ShowNotification("There are no results to select.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("There are no results to select.", "Error");
                return;
            }
            try
            {
                var modelDirPath = Model.RaefModelNames[Model.RaefSelectedModelIndex];
                var modelDirInfo = new DirectoryInfo(Model.RaefModelNames[Model.RaefSelectedModelIndex]);
                var selectedProjectFolder = Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", Model.SelectedTract, "SelectedResult");
                // If selected model folder is not raef root
                if (modelDirPath == selectedProjectFolder)
                {
                    dialogService.ShowNotification("SelectedResult folder cannot be selected. ", "Error");
                    return;
                }
                if (!Directory.Exists(selectedProjectFolder))
                {
                    Directory.CreateDirectory(selectedProjectFolder);
                }
                DirectoryInfo dir = new DirectoryInfo(selectedProjectFolder);
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
                    var destPath = Path.Combine(selectedProjectFolder, file2.Name);
                    var sourcePath = Path.Combine(modelDirPath, file2.Name);
                    File.Copy(sourcePath, destPath); // Copy files to new Root folder.
                }
                EconomicFilterInputParams inputParams = new EconomicFilterInputParams();
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
                    Model.TabIndex = Convert.ToInt32(inputParams.ModelIndex);
                    Model.SelectedTract = inputParams.TractID;
                    Model.ScreenerExtensionFolder = inputParams.ScreenerExtensionFolder;
                    File.Copy(param_json, Path.Combine(settingsService.RootPath, "EconFilter", "undiscovered_deposits_input_params.json"), true);
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
                dialogService.ShowNotification("Raef result selected successfully", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Raef result selected successfully in Economic Filter tool.", "Success");
            }
            catch (Exception ex)
            {
                logger.Trace(ex, "Error in result Selection:");
                dialogService.ShowNotification("Failed to select Raef result.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to select Raef result in Economic filter tool.", "Error");
            }
            var metroWindow = (Application.Current.MainWindow as MetroWindow);
            var dialog = metroWindow.GetCurrentDialogAsync<BaseMetroDialog>();
            metroWindow.HideMetroDialogAsync(dialog.Result);
            LoadRaefResults();
        }

        /// <summary>
        /// Select result for Screener.
        /// </summary>
        private void ScreenerSelectResult()
        {
            if (Model.ScreenerModelNames.Count > 0)
            {
                try
                {
                    var modelDirPath = Model.ScreenerModelNames[Model.ScreenerSelectedModelIndex];
                    var modelDirInfo = new DirectoryInfo(Model.ScreenerModelNames[Model.ScreenerSelectedModelIndex]);
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
                    dialogService.ShowNotification("Screener result selected successfully", "Success");
                    viewModelLocator.SettingsViewModel.WriteLogText("Screener result selected successfully in Economic Filter tool.", "Success");
                }
                catch (Exception ex)
                {
                    logger.Trace(ex, "Error in result Selection:");
                    dialogService.ShowNotification("Failed to select Screener result.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Failed to select Screener result in Economic filter tool.", "Error");
                }
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
                string objectFile = dialogService.OpenFileDialog(Path.Combine(settingsService.RootPath, "MCSim"), "", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(objectFile))
                {
                    Model.MonteCarloResultTable = objectFile.Replace("\\", "/");
                    Model.MetalIds = SetMetalIds();
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
        /// Update which tract is chosen and get the tract spesific results.
        /// </summary>
        private void TractChanged()
        {
            if (Model.SelectedTract != null)
            {
                string projectFolder = Path.Combine(settingsService.RootPath, "EconFilter");
                projectFolder = Path.Combine(projectFolder, "RAEF", Model.SelectedTract);
                if (Directory.Exists(projectFolder))
                {
                    Model.RaefModelNames.Clear();
                    FindRaefModelnames(projectFolder);  // Find saved results.
                }
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
                dialogService.ShowNotification("Failed to read metal index. Check output for details.", "Error");
                //throw new Exception("Reading metal index failed: " + result, e);
            }
            return retValue;
        }

        /// <summary>
        /// Method to open dialog and saving its result for RAEF preset file.
        /// </summary>
        public void SelectRAEFPresetFile()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    Model.RaefPresetFile = csvFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to open csv file. Check output for details.", "Error");
            }
        }

        /// <summary>
        /// Method to open dialog and saving its result for RAEF economic filter file.
        /// </summary>
        public void SelectRaefEconFilterFile()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    Model.RaefEconFilterFile = csvFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to open csv file. Check output for details.", "Error");
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
                dialogService.ShowNotification("Failed to open input file. Check output for details.", "Error");
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
                    dialogService.ShowNotification("Error in reading table. Check output for details.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Error reading table in Economic Filter tool. Check output for details.", "Error");
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
                dialogService.ShowNotification("Failed to load Economic Filter tool's Screener result files.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to load Economic Filter tool's Screener result files.", "Error");
            }
        }

        /// <summary>
        /// Load Raef results of the last run.
        /// </summary>
        private void LoadRaefResults()
        {
            // This makes sure that tool doesn't throw an error when it's not run.
            if (Model.SelectedTract != null)
            {
                try
                {
                    var projectFolder = Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", Model.SelectedTract, "SelectedResult");
                    bool EF1Exists = false;
                    bool EF4Exists = false;                    
                    if (Directory.Exists(projectFolder))
                    {
                        Model.RunStatus = 0;
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
                            Model.RunStatus = 1;
                        }
                    }
                }
                catch (Exception ex)
                {
                    logger.Error(ex + " Could not load results files");
                    dialogService.ShowNotification("Failed to load Economic Filter tool's Raef result files.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Failed to load Economic Filter tool's Raef result files.", "Error");
                }
            }
        }

        /// <summary>
        /// Find all saved results, which have been made by past runs.
        /// </summary>
        /// <param name="projectFolder">Models's folder.</param>
        private void FindRaefModelnames(string projectFolder)
        {
            //string raefProjectFolder = Path.Combine(projectFolder, "RAEF");
            //DirectoryInfo raefFolderInfo = new DirectoryInfo(raefProjectFolder);
            DirectoryInfo raefFolderInfo = new DirectoryInfo(projectFolder);
            foreach (DirectoryInfo result in raefFolderInfo.GetDirectories())
            {
                if (result.Name != "SelectedResult")
                {
                    foreach (FileInfo file in result.GetFiles())
                    {
                        if (file.Name == "economic_filter_input_params.json")
                        {
                            Model.RaefModelNames.Add(result.FullName);
                        }
                    }
                }
            }
            // Goes also through the main folder.
            foreach (FileInfo file in raefFolderInfo.GetFiles())
            {
                if (file.Name == "economic_filter_input_params.json")
                {
                    Model.RaefModelNames.Add(raefFolderInfo.FullName);
                }
            }
        }

        /// <summary>
        /// Check if tool can be executed.
        /// </summary>
        /// <returns> Boolean representing whether tool can be run</returns>
        private bool CanRunTool()
        {
            return !Model.IsBusy;
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
                dialogService.ShowNotification(" CSV file not found.", "Error");
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
                dialogService.ShowNotification(" CSV file not found.", "Error");
            }
        }

        /// <summary>
        /// Open histogram image file.
        /// </summary>
        private void OpenScreenerHistogram()
        {
            try
            {
                bool openFile = dialogService.MessageBoxDialog();
                if (openFile == true)
                {
                    if (File.Exists(Result.EcoTonHistrogram))
                    {
                        Process.Start(Result.EcoTonHistrogram);
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
        /// Open image file.
        /// </summary>
        private void OpenScreenerPlot()
        {
            try
            {
                bool openFile = dialogService.MessageBoxDialog();
                if (openFile == true)
                {
                    if (File.Exists(Result.ResultPlot))
                    {
                        Process.Start(Result.ResultPlot);
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
                if (Directory.Exists(Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", Model.SelectedTract, Model.RaefExtensionFolder)))
                {
                    Process.Start(Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", Model.SelectedTract, Model.RaefExtensionFolder));
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex + "Failed to open results folder.");
                dialogService.ShowNotification("Failed to open results folder.", "Error");
            }
        }

        private void SelectGTMFile()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    Model.RaefGTMFile = csvFile.Replace("\\", "/");//onko se GTM file? no se tulee selviämään.
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to open csv file. Check output for details.", "Error");
            }
        }

        private string WriteCsvFile()
        {
            try
            {
                //before your loop
                var csv = new StringBuilder();

                //in your loop
                //var first = reader[0].ToString();
                //var second = image.ToString();
                //Suggestion made by KyleMit
                //var newLine = string.Format("{0},{1}", first, second);
                //csv.AppendLine(
                int maxDepth = Math.Max(Model.RaefMax1, Math.Max(Model.RaefMax2, Math.Max(Model.RaefMax3, Model.RaefMax4)));//c# math max on tymä eikä ota enempää kuin 2 kerralla, siksi tää hölmö ketju. joku linQ max ois myös olemassa ja vois toki olla ihan pelkkä > komparisooni mutta olkoon nyt näin.

                switch (Model.RaefDepositType)
                { //check spelling for cases!
                    case "Flat-bedded/stratiform":
                        if (maxDepth < 61)
                            Model.RaefMineMethod = "Open pit";
                        else
                            Model.RaefMineMethod = "Room-and-pillar";
                        break;
                    case "Ore body massive / disseminated":
                        if (maxDepth < 61)
                            Model.RaefMineMethod = "Open pit";
                        else
                            Model.RaefMineMethod = "Block caving";
                        break;
                    case "Vein deposit / steep":
                        Model.RaefMineMethod = "Vertical crater retreat";
                        break;

                    default:
                        break;
                }

                EconomicFilterTool tool = new EconomicFilterTool(); //muokkaa tätä. tyhmää että tässä tehdään kokonainen econ. filter tooli. mieti pitäisikö tämä ehkä kuitenkin ympätä osaksi Toolia tämä CSV:n luontikin? voisi olla parempi ratkaisu.
                string output = tool.RaefGetCVandMRR(Model.RaefEconFilterFile, settingsService.RPath);
                List<string> CVandMRRList = output.Split(',').ToList();
                //output //parsi tästä lista.
                // ja sit listasta CountN*2 kappaletta noihin CSV:n vikoihin slotteihin, ja avot!
                //after your loop
                string envChoice1 = (Model.RaefEnvChoice1.ToLower() == "true") ? "Tailings Pond and Dam" : "NA";
                string liner = (Model.RaefLiner.ToLower() == "true") ? "Liner" : "NA";

                //File.WriteAllText(filePath, csv.ToString());
                //RS1 << -rbind(date2, time2, SimFile, WD, TN1, NumCat, Min1, Max1, Per1, Min2, Max2, Per2, Min3, Max3, Per3, Min4, Max4, Per4, DTy, minetypes, MillChoice[1], MillChoice[2], dpy, ECh[1], ECh[2], MSC, IRR, CCIF, OCIF, TA1, UDName1, KC1, KC2, KO1, KO2, MCho1, MCho2, MCho3, MCho4, MCho5, MCho6)


                //Model.RaefMineMethod
                //Model.RaefDepositType

                //Tää mine method pitää nyt päätellä tässä vaiheessa.
                //• Flat-bedded/stratiform deposits • Open pit (depth < 61meters [m]) • Room-and-pillar (depth > 61m) 

                //• Massive/disseminated deposits • Open pit (depth < 61m) • Block caving (depth > 61m) 
                //• Vein/steep deposits • Vertical crater retreat (the only mine option for vein/ steep deposits) 
                csv.AppendLine(",A,B");
                csv.AppendLine("1,Date," + "" + DateTime.Now + "");//Thu Dec 13 2018 formaatissa, liekö väliä.
                csv.AppendLine("2,Time," + "" + DateTime.Now + "");////11:19:30 AM  formaatissa. nää pitäs eritellä tosta koko datetime hässäkästä.
                csv.AppendLine("3,Econ Filter File," + "" + Model.RaefEconFilterFile + "");
                csv.AppendLine("4,Working Directory," + Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", Model.SelectedTract, Model.RaefExtensionFolder).Replace("\\", "/"));
                csv.AppendLine("5,Run Name," + "" + Model.RaefRunName + "");
                csv.AppendLine("6,Number of Depth Intervals," + "" + Model.RaefDepthIntervals + "");
                csv.AppendLine("7,Min1," + "" + Model.RaefMin1 + "");
                csv.AppendLine("8,Max1," + "" + Model.RaefMax1 + "");
                csv.AppendLine("9,Per1," + "" + Model.RaefFract1 + "");
                csv.AppendLine("10,Min2," + "" + Model.RaefMin2 + "");
                csv.AppendLine("11,Max2," + "" + Model.RaefMax2 + "");
                csv.AppendLine("12,Per2," + "" + Model.RaefFract2 + "");
                csv.AppendLine("13,Min3," + "" + Model.RaefMin3 + "");
                csv.AppendLine("14,Max3," + "" + Model.RaefMax3 + "");
                csv.AppendLine("15,Per3," + "" + Model.RaefFract3 + "");
                csv.AppendLine("16,Min4," + "" + Model.RaefMin4 + "");
                csv.AppendLine("17,Max4," + "" + Model.RaefMax4 + "");
                csv.AppendLine("18,Per4," + "" + Model.RaefFract4 + "");
                csv.AppendLine("19,Deposit Type," + "" + Model.RaefDepositType + "");
                csv.AppendLine("20,Mine Method," + "" + Model.RaefMineMethod + "");//Mine Method is based on depth to the top of the deposit, if depth >= 61m: Block Caving, if depth < 61m: Open Pit"
                csv.AppendLine("21,Mill Type 1 ," + "" + Model.RaefMillType1 + "");// 3 - Product Flotation"
                csv.AppendLine("22,Mill Type 2 ," + "" + Model.RaefMillType2 + ""); //NA
                csv.AppendLine("23,Days of Operation," + "" + Model.RaefDaysOfOperation + "");// "350"
                csv.AppendLine("24,Environment Choice 1 ," + "" + envChoice1 + "");//"Tailings Pond and Dam" //nämä booleista fixuiksi. converter? joo. hyi mutta joo.
                csv.AppendLine("25,Liner?," + "" + liner + ""); //"Liner"
                csv.AppendLine("26,MSC," + "" + Model.RaefMarshallSwiftCost + "");//"1.26"
                csv.AppendLine("27,Investment Rate of Return," + "" + Model.RaefInvestmentRateOfReturn + "");// "0.15"
                csv.AppendLine("28,Cap Cost Inflation Factor," + "" + Model.RaefCapitalCostInflationFactor + "");// "1"
                csv.AppendLine("29,Operating Cost Inflation Factor," + "" + Model.RaefOperatingCostInflationFactor + "");// "1"
                csv.AppendLine("30,Area," + "" + Model.RaefArea + "");// "1000000"
                csv.AppendLine("31,User Define Mill Name (if applicable)," + "" + Model.RaefMillName + "");// "NONE"
                csv.AppendLine("32,User Define: Mill Capital Cost Constant," + "" + Model.RaefMillCapitalConstant + "");// "0"
                csv.AppendLine("33,User Define: Mill Capital Cost Power log," + "" + Model.RaefMillCapitalLog + "");// "0"
                csv.AppendLine("34,User Define: Mill Operating Cost Constant," + "" + Model.RaefMillOperatingCostConstant + "");// "0"
                csv.AppendLine("35,User Define: Mill Operating Cost Power log," + "" + Model.RaefMillOperatingCostLog + "");// "0"
                csv.AppendLine("36,Custom_Mill_Option1," + "" + Model.RaefCustomMillOption1 + "");// "No set custom mill option for commodity #1"
                csv.AppendLine("37,Custom_Mill_Option2," + "" + Model.RaefCustomMillOption2 + "");// "No set custom mill option for commodity #2"
                csv.AppendLine("38,Custom_Mill_Option3," + "" + Model.RaefCustomMillOption3 + "");// "No set custom mill option for commodity #3"
                csv.AppendLine("39,Custom_Mill_Option4," + "" + Model.RaefCustomMillOption4 + "");// "No set custom mill option for commodity #4"
                csv.AppendLine("40,Custom_Mill_Option5," + "" + Model.RaefCustomMillOption5 + "");// "No set custom mill option for commodity #5"
                csv.AppendLine("41,Custom_Mill_Option6," + "" + Model.RaefCustomMillOption6 + "");// "No set custom mill option for commodity #6"
                int csvIndex = 42;
                //for (int i = 0; i < 4; i++)
                //{
                //    csv.AppendLine((csvIndex + "," + CVandMRRList[i * 4] + "," + CVandMRRList[i * 4 + 2]).Replace(" ", "").Replace("\"", ""));
                //    csvIndex++;
                //    csv.AppendLine((csvIndex + "," + CVandMRRList[i * 4 + 1] + "," + CVandMRRList[i * 4 + 3]).Replace(" ", "").Replace("\"", "").Replace("NULL", ""));
                //    csvIndex++;
                //    //CVandMRRList
                //}
                for (int i = 0; i < (CVandMRRList.Count / 4); i++)
                {
                    csv.AppendLine((csvIndex + "," + CVandMRRList[i * 4] + "," + CVandMRRList[i * 4 + 2]).Replace(" ", "").Replace("\"", ""));
                    csvIndex++;
                    csv.AppendLine((csvIndex + "," + CVandMRRList[i * 4 + 1] + "," + CVandMRRList[i * 4 + 3]).Replace(" ", "").Replace("\"", "").Replace("NULL", ""));
                    csvIndex++;
                    //CVandMRRList
                }
                //csv.AppendLine(",\"A\",\"B\"");
                //csv.AppendLine("1,\"Date\"," + "\"" + DateTime.Now + "\"");//\"Thu Dec 13 2018\" formaatissa, liekö väliä.
                //csv.AppendLine("2,\"Time\"," + "\"" + DateTime.Now + "\"");////\"11:19:30 AM \" formaatissa. nää pitäs eritellä tosta koko datetime hässäkästä.
                //csv.AppendLine("3,\"Econ Filter File\"," + "\"" + Model.RaefEconFilterFile + "\"");
                //csv.AppendLine("4,\"Working Directory\",");
                //csv.AppendLine("5,\"Run Name\"," + "\"" + Model.RaefRunName + "\"");
                //csv.AppendLine("6,\"Number of Depth Intervals\"," + "\"" + Model.RaefDepthIntervals + "\"");
                //csv.AppendLine("7,\"Min1\"," + "\"" + Model.RaefMin1 + "\"");
                //csv.AppendLine("8,\"Max1\"," + "\"" + Model.RaefMax1 + "\"");
                //csv.AppendLine("9,\"Per1\"," + "\"" + Model.RaefFract1 + "\"");
                //csv.AppendLine("10,\"Min2\"," + "\"" + Model.RaefMin2 + "\"");
                //csv.AppendLine("11,\"Max2\"," + "\"" + Model.RaefMax2 + "\"");
                //csv.AppendLine("12,\"Per2\"," + "\"" + Model.RaefFract2 + "\"");
                //csv.AppendLine("13,\"Min3\"," + "\"" + Model.RaefMin3 + "\"");
                //csv.AppendLine("14,\"Max3\"," + "\"" + Model.RaefMax3 + "\"");
                //csv.AppendLine("15,\"Per3\"," + "\"" + Model.RaefFract3 + "\"");
                //csv.AppendLine("16,\"Min4\"," + "\"" + Model.RaefMin4 + "\"");
                //csv.AppendLine("17,\"Max4\"," + "\"" + Model.RaefMax4 + "\"");
                //csv.AppendLine("18,\"Per4\"," + "\"" + Model.RaefFract4 + "\"");
                //csv.AppendLine("19,\"Deposit Type\"," + "\"" + Model.RaefDepositType + "\"");
                //csv.AppendLine("20,\"Mine Method\"," + "\"" + Model.RaefMineMethod + "\"");//Mine Method is based on depth to the top of the deposit, if depth >= 61m: Block Caving, if depth < 61m: Open Pit"
                //csv.AppendLine("21,\"Mill Type 1 \"," + "\"" + Model.RaefMillType1 + "\"");// 3 - Product Flotation"
                //csv.AppendLine("22,\"Mill Type 2 \"," + "\"" + Model.RaefMillType2 + "\""); //NA
                //csv.AppendLine("23,\"Days of Operation\"," + "\"" + Model.RaefDaysOfOperation + "\"");// "350"
                //csv.AppendLine("24,\"Environment Choice 1 \"," + "\"" + Model.RaefEnvChoice1 + "\"");//"Tailings Pond and Dam"
                //csv.AppendLine("25,\"Liner?\"," + "\"" + Model.RaefLiner + "\""); //"Liner"
                //csv.AppendLine("26,\"MSC\"," + "\"" + Model.RaefMarshallSwiftCost + "\"");//"1.26"
                //csv.AppendLine("27,\"Investment Rate of Return\"," + "\"" + Model.RaefInvestmentRateOfReturn + "\"");// "0.15"
                //csv.AppendLine("28,\"Cap Cost Inflation Factor\"," + "\"" + Model.RaefCapitalCostInflationFactor + "\"");// "1"
                //csv.AppendLine("29,\"Operating Cost Inflation Factor\"," + "\"" + Model.RaefOperatingCostInflationFactor + "\"");// "1"
                //csv.AppendLine("30,\"Area\","+"\""+Model.RaefArea + "\"");// "1000000"
                //csv.AppendLine("31,\"User Define Mill Name (if applicable)\"," + "\"" + Model.RaefMillName + "\"");// "NONE"
                //csv.AppendLine("32,\"User Define: Mill Capital Cost Constant\"," + "\"" + Model.RaefMillCapitalConstant + "\"");// "0"
                //csv.AppendLine("33,\"User Define: Mill Capital Cost Power log\"," + "\"" + Model.RaefMillCapitalLog + "\"");// "0"
                //csv.AppendLine("34,\"User Define: Mill Operating Cost Constant\"," + "\"" + Model.RaefMillOperatingCostConstant + "\"");// "0"
                //csv.AppendLine("35,\"User Define: Mill Operating Cost Power log\"," + "\"" + Model.RaefMillOperatingCostLog + "\"");// "0"
                //csv.AppendLine("36,\"Custom_Mill_Option1\"," + "\"" + Model.RaefCustomMillOption1 + "\"");// "No set custom mill option for commodity #1"
                //csv.AppendLine("37,\"Custom_Mill_Option2\"," + "\"" + Model.RaefCustomMillOption2 + "\"");// "No set custom mill option for commodity #2"
                //csv.AppendLine("38,\"Custom_Mill_Option3\"," + "\"" + Model.RaefCustomMillOption3 + "\"");// "No set custom mill option for commodity #3"
                //csv.AppendLine("39,\"Custom_Mill_Option4\"," + "\"" + Model.RaefCustomMillOption4 + "\"");// "No set custom mill option for commodity #4"
                //csv.AppendLine("40,\"Custom_Mill_Option5\"," + "\"" + Model.RaefCustomMillOption5 + "\"");// "No set custom mill option for commodity #5"
                //csv.AppendLine("41,\"Custom_Mill_Option6\"," + "\"" + Model.RaefCustomMillOption6 + "\"");// "No set custom mill option for commodity #6"
                ////foreach(string s in CVandMRRList)
                //{
                //    csv.AppendLine("41,\"Custom_Mill_Option6\"," + "\"" + Model.RaefCustomMillOption6 + "\"");
                //}
                string filePath = Path.Combine(settingsService.RootPath, "EconFilter", "RaefParams.csv");
                File.WriteAllText(filePath, csv.ToString());//Tästä kovakoodit pois! johonki result folderiin kirjota tuo mihink kuuluuki.
                return filePath;
                //csv.AppendLine("42,\"CV_Cu", "3813.958"
                //csv.AppendLine("43,\"MRR_Cu", "0.91"
                //csv.AppendLine("44,\"CV_Mo", "23567.174"
                //csv.AppendLine("45,\"MRR_Mo", "0.63"
                //csv.AppendLine("46,\"CV_Au", "16557636.25"
                //csv.AppendLine("47,\"MRR_Au", "0.76"
                //csv.AppendLine("48,\"CV_Ag", "257849.015"
                //csv.AppendLine("49,\"MRR_Ag", "0.8"

                //rownames(RS1) < -c("Date", "Time", "Econ Filter File", "Working Directory", "Run Name", "Number of Depth Intervals", "Min1", "Max1", "Per1", "Min2", "Max2", "Per2", "Min3", "Max3", "Per3", "Min4", "Max4", "Per4", "Deposit Type", "Mine Method", "Mill Type 1 ", "Mill Type 2 ", "Days of Operation", "Environment Choice 1 ", "Liner?", "MSC", "Investment Rate of Return", "Cap Cost Inflation Factor", "Operating Cost Inflation Factor", "Area", "User Define Mill Name (if applicable)", "User Define: Mill Capital Cost Constant", "User Define: Mill Capital Cost Power log", "User Define: Mill Operating Cost Constant", "User Define: Mill Operating Cost Power log", "Custom_Mill_Option1", "Custom_Mill_Option2", "Custom_Mill_Option3", "Custom_Mill_Option4", "Custom_Mill_Option5", "Custom_Mill_Option6")
            }catch(Exception ex) {
                //WHAT. mihin ne mun lisäämät poikkeukset on menny. no ok
                logger.Trace(ex, "Error in creating input file:");
                dialogService.ShowNotification("Failed to write input file. Check output for details.", "Error");
                //sais lopettaa tähän. muuta niin.
                return "";
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
    }
}


