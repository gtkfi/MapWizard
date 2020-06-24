using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using MapWizard.Model;
using MapWizard.Service;
using MapWizard.Tools;
using MapWizard.Tools.Settings;
using NLog;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Threading.Tasks;
using Xceed.Words.NET;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// This class contains properties that the ReportingView can data bind to.
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
    public class ReportingViewModel : ViewModelBase, INotifyPropertyChanged
    {
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private string activeView;
        private ReportingModel model;
        private ViewModelLocator viewModelLocator;


        /// <summary>
        /// Initialize new instance of ReportingViewModel class.
        /// </summary>
        /// <param name="logger">Logging for the MapWizard</param>
        /// <param name="dialogService">Service for using project's dialogs and notifications</param>
        /// <param name="settingsService">Service for using and editing project's settings</param>
        public ReportingViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            viewModelLocator = new ViewModelLocator();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            GoToTractReportCommand = new RelayCommand(GoToTractReport, CanChangeView);
            GoToReportSelectionCommand = new RelayCommand(GoToReportSelection, CanChangeView);
            CheckTractFilesCommand = new RelayCommand(CheckFiles, CanRunTool);
            FindTractsCommand = new RelayCommand(FindTractIDs, CanRunTool);
            SelectTractImageFileCommand = new RelayCommand(SelectTractImageFile, CanRunTool);
            SelectKnownDepositsFileCommand = new RelayCommand(SelectKnownDepositsFile, CanRunTool);
            SelectProspectsOccurencesFileCommand = new RelayCommand(SelectProspectsOccurencesFile, CanRunTool);
            SelectExplorationFileCommand = new RelayCommand(SelectExplorationFile, CanRunTool);
            SelectSourcesFileCommand = new RelayCommand(SelectSourcesFile, CanRunTool);
            SelectReferencesFileCommand = new RelayCommand(SelectReferencesFile, CanRunTool);
            ReportingInputParams inputParams = new ReportingInputParams();
            string outputFolder = Path.Combine(settingsService.RootPath, "Reporting");
            if (!Directory.Exists(outputFolder))
            {
                Directory.CreateDirectory(outputFolder);
            }
            string param_json = Path.Combine(outputFolder, "tract_report_input_params.json");
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    Model = new ReportingModel
                    {
                        TractImageFile = inputParams.TractImageFile,
                        KnownDepositsFile = inputParams.KnownDepositsFile,
                        ProspectsOccurencesFile = inputParams.ProspectsOccurencesFile,
                        ExplorationFile = inputParams.ExplorationFile,
                        SourcesFile = inputParams.SourcesFile,
                        ReferencesFile = inputParams.ReferencesFile,
                        SelectedTract = inputParams.SelectedTract,
                        Authors = inputParams.Authors,
                        Country = inputParams.Country,
                        DescModelPath = inputParams.DescModel,
                        DescModelName = inputParams.DescModelName,
                        GTModelPath = inputParams.GTModel,
                        GTModelName = inputParams.GTModelName,
                        AddDescriptive = Convert.ToBoolean(inputParams.AddDescriptive),
                        AddGradeTon = Convert.ToBoolean(inputParams.AddGradeTon),
                        EnableDescCheck = Convert.ToBoolean(inputParams.EnableDescCheck),
                        EnableGTCheck = Convert.ToBoolean(inputParams.EnableGTCheck),
                        AsDate = inputParams.AsDate,
                        AsDepth = inputParams.AsDepth,
                        AsLeader = inputParams.AsLeader,
                        AsTeamMembers = inputParams.AsTeamMembers,
                        IsRaefDone = inputParams.IsRaefDone,
                        IsScreenerDone = inputParams.IsScreenerDone,
                        IsUndiscDepDone = inputParams.IsUndiscDepDone
                    };
                    FindTractIDs();  // Gets the tractID names from PermissiveTractTool's Tracts folder.
                    CheckFiles();  // Check which of the needed files for creating a report exist.                                       
                    if (Model.SelectedTract != null) // Check if the tool have ever been correctly ran before.
                    {
                        //Model.RunStatus = 0; Remove this?
                        string docOutputFile = Path.Combine(outputFolder, Model.SelectedTract, "TractReport" + Model.SelectedTract + ".docx");
                        if (File.Exists(docOutputFile))// If reporting file exist then the tool have been ran.
                        {
                            Model.RunStatus = 1;
                        }
                    }
                    SaveInputs();  // Save inputs to tract_report_input_params.json file. This might be not needed(?).
                }
                catch (Exception ex)
                {
                    // If something goes wrong then the tool will be initialized to have default parameters.
                    Model = new ReportingModel();
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Reporting tool's inputs correctly. Inputs were initialized to default values.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Reporting tool's inputs correctly. Inputs were initialized to default values.", "Error");
                }
            }
            else
            {
                Model = new ReportingModel();
                FindTractIDs(); // Gets the tractID names from PermissiveTractTool's Trats folder.
            }
            // Check if the DepositType have been given correctly for the project.
            if (settingsService.Data.DepositType != null)
            {
                Model.DepositType = settingsService.Data.DepositType;
            }
            var lastRunFile = Path.Combine(settingsService.RootPath, "Reporting", "tract_report_last_run.lastrun");
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
        /// Command for switching into Tract Report.
        /// </summary>
        /// @return Command.
        public RelayCommand GoToTractReportCommand { get; }

        /// <summary>
        /// Command for switching into ReportingSelectionView.
        /// </summary>
        /// @return Command.
        public RelayCommand GoToReportSelectionCommand { get; }

        /// <summary>
        /// Command for getting trsct specific files.
        /// </summary>
        /// @return Command.
        public RelayCommand CheckTractFilesCommand { get; }

        /// <summary>
        /// Command for getting tracts.
        /// </summary>
        /// @return Command.
        public RelayCommand FindTractsCommand { get; }

        /// <summary>
        /// Command for tract image file selection.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectTractImageFileCommand { get; }

        /// <summary>
        /// Command for known deposits file selection.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectKnownDepositsFileCommand { get; }

        /// <summary>
        /// Command for prospects and occurences file selection.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectProspectsOccurencesFileCommand { get; }

        /// <summary>
        /// Command for exploration file selection.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectExplorationFileCommand { get; }

        /// <summary>
        /// Command for sources file selection.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectSourcesFileCommand { get; }

        /// <summary>
        /// Command for references file selection.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectReferencesFileCommand { get; }

        /// <summary>
        /// Command for clearing all tract report fields.
        /// </summary>
        /// @return Command.
        public RelayCommand ClearAllFieldsCommand { get; }

        /// <summary>
        /// Switch to Tract Report.
        /// </summary>
        /// <returns>ActiveView.</returns>
        public string ActiveView
        {
            get { return activeView; }
            set
            {
                if (value == activeView) return;
                activeView = value;
                RaisePropertyChanged("ActiveView");
            }
        }

        /// <summary>
        /// Model for TractReport.
        /// </summary>
        /// <returns>ReportingModel.</returns>
        public ReportingModel Model
        {
            get
            {
                return model;
            }
            set
            {
                model = value;
                RaisePropertyChanged("Model");
            }
        }

        /// <summary>
        /// Run tool with user input.
        /// </summary>
        private async void RunTool()
        {
            try
            {
                logger.Info("-->{0}", this.GetType().Name);
                // 1. Collect input parameters
                ReportingInputParams input = new ReportingInputParams
                {
                    TractIDNames = Model.TractIDNames,
                    SelectedTract = Model.SelectedTract,
                    Authors = Model.Authors,
                    Country = Model.Country,
                    DepositType = Model.DepositType,
                    DescModel = Model.DescModelPath,
                    DescModelName = Model.DescModelName,
                    GTModel = Model.GTModelPath,
                    GTModelName = Model.GTModelName,
                    AddDescriptive = Model.AddDescriptive.ToString(),
                    AddGradeTon = Model.AddGradeTon.ToString(),
                    EnableDescCheck = Model.EnableDescCheck.ToString(),
                    EnableGTCheck = Model.EnableGTCheck.ToString(),
                    TractImageFile = Model.TractImageFile,
                    KnownDepositsFile = Model.KnownDepositsFile,
                    ProspectsOccurencesFile = Model.ProspectsOccurencesFile,
                    ExplorationFile = Model.ExplorationFile,
                    SourcesFile = Model.SourcesFile,
                    ReferencesFile = Model.ReferencesFile,
                    AsDate = Model.AsDate,
                    AsDepth = Model.AsDepth,
                    AsLeader = Model.AsLeader,
                    AsTeamMembers = Model.AsTeamMembers,
                    IsUndiscDepDone = Model.IsUndiscDepDone,
                    IsRaefDone = Model.IsRaefDone,
                    IsScreenerDone = Model.IsScreenerDone
                };
                // User can chöose not to insert Descriptive model document into report.
                if (Model.AddDescriptive == false)
                {
                    input.DescModelName = "-";
                }
                // User can chöose not to insert Grade Tonnage file into report.
                if (Model.AddGradeTon == false)
                {
                    input.GTModelName = "-";
                }
                // 2. Execute tool
                ReportingResult ddResult = default(ReportingResult);
                Model.IsBusy = true;
                await Task.Run(() =>
                {
                    ReportingTool tool = new ReportingTool();
                    logger.Info("calling ReportingTool.Execute(inputParams)");
                    ddResult = tool.Execute(input) as ReportingResult;
                    logger.Trace("ReportingResult:\n" +
              "\tOutputFile: '{0}'",
              ddResult.OutputDocument);
                });
                var lastRunFile = Path.Combine(settingsService.RootPath, "Reporting", "tract_report_last_run.lastrun");
                File.Create(lastRunFile).Close();
                dialogService.ShowNotification("Reporting tool completed successfully", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Reporting tool completed successfully.", "Success");
                Model.LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                Model.RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to build documentation file");
                dialogService.ShowNotification("Run failed. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Reporting tool run failed. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                Model.RunStatus = 0;
            }
            finally
            {
                Model.IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Switch to Tract Report.
        /// </summary>
        private void GoToTractReport()
        {
            ActiveView = "TractReport";
        }

        /// <summary>
        /// Switch to Report Selection.
        /// </summary>
        private void GoToReportSelection()
        {
            ActiveView = "ReportSelection";
        }

        /// <summary>
        /// Save inputs so that the program remembers them if program is closed
        /// </summary>
        public void SaveInputs()
        {
            ReportingInputParams input = new ReportingInputParams
            {
                TractIDNames = Model.TractIDNames,
                SelectedTract = Model.SelectedTract,
                Authors = Model.Authors,
                Country = Model.Country,
                DepositType = Model.DepositType,
                DescModel = Model.DescModelPath,
                DescModelName = Model.DescModelName,
                GTModel = Model.GTModelPath,
                GTModelName = Model.GTModelName,
                AddDescriptive = Model.AddDescriptive.ToString(),
                AddGradeTon = Model.AddGradeTon.ToString(),
                EnableDescCheck = Model.EnableDescCheck.ToString(),
                EnableGTCheck = Model.EnableGTCheck.ToString(),
                TractImageFile = Model.TractImageFile,
                KnownDepositsFile = Model.KnownDepositsFile,
                ProspectsOccurencesFile = Model.ProspectsOccurencesFile,
                ExplorationFile = Model.ExplorationFile,
                SourcesFile = Model.SourcesFile,
                ReferencesFile = Model.ReferencesFile,
                AsDate = Model.AsDate,
                AsDepth = Model.AsDepth,
                AsLeader = Model.AsLeader,
                AsTeamMembers = Model.AsTeamMembers,
                IsUndiscDepDone = Model.IsUndiscDepDone,
                IsRaefDone = Model.IsRaefDone,
                IsScreenerDone = Model.IsScreenerDone
            };
            string outputFolder = Path.Combine(input.Env.RootPath, "Reporting");
            if (!Directory.Exists(outputFolder))
            {
                Directory.CreateDirectory(outputFolder);
            }
            input.Save(Path.Combine(outputFolder, "tract_report_input_params.json"));
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
                    if (!dir.Name.StartsWith("AGG"))
                    {
                        Model.TractIDNames.Add(dir.Name);  // Get TractID by getting the name of the directory.
                    }
                }
            }
            else
            {
                Directory.CreateDirectory(Path.Combine(settingsService.RootPath, "TractDelineation", "Tracts"));
            }
        }

        /// <summary>
        /// Check files.
        /// </summary>
        public void CheckFiles()
        {
            //string descResult = Path.Combine(settingsService.RootPath, "DescModel", "SelectedResult", Path.GetFileName(model.DescModelPath));
            string descResult = Path.Combine(settingsService.RootPath, "DescModel", "SelectedResult", "DescModelName.txt");
            string[] fileName = null;
            // Checks if the result file for Descriptive model tool exists.
            if (File.Exists(descResult))
            {
                fileName = File.ReadAllText(descResult).Split(',');
            }
            if (fileName != null && fileName.Length == 2)
            {
                Model.DescModelName = fileName[0];
                Model.DescModelPath = fileName[1];
                Model.EnableDescCheck = true;
            }
            else
            {
                Model.DescModelPath = "-";
                Model.DescModelName = "-";
                Model.AddDescriptive = false;
                Model.EnableDescCheck = false;  // Makes sure that the file that doesn't exist cannot be added to document.
            }
            // Checks if the result file for Grade Tonnage tool exists.
            string gtResult = Path.Combine(settingsService.RootPath, "DescModel", "SelectedResult", "GTModelName.txt");
            var gtResultFolder = Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult"); // if (File.Exists(gtResult) && Model.GTModelName != "-")
            if (File.Exists(gtResult))
            {
                Model.GTModelPath = gtResultFolder;
                Model.GTModelName = File.ReadAllText(gtResult);
            }
            if ((File.Exists(Path.Combine(gtResultFolder, "grade_summary.txt")) && File.Exists(Path.Combine(gtResultFolder, "grade_plot.jpeg")))
                 || (File.Exists(Path.Combine(gtResultFolder, "tonnage_summary.txt")) && File.Exists(Path.Combine(gtResultFolder, "tonnage_plot.jpeg"))))
            {
                Model.EnableGTCheck = true;
            }
            else
            {
                Model.GTModelPath = "-";
                Model.GTModelName = "-";
                Model.AddGradeTon = false;
                Model.EnableGTCheck = false;  // Makes sure that the file that doesn't exist cannot be added to document. 
            }
            if (Model.GTModelName == "-")  // This is to make sure that information has been received correctly.
            {
                Model.GTModelPath = "-";
                Model.GTModelName = "-";
                Model.AddGradeTon = false;
                Model.EnableGTCheck = false;  // Makes sure that the file that doesn't exist cannot be added to document. 
            }
            if (Model.SelectedTract != null)
            {
                Model.IsUndiscDepDone = "No";  // If files don't exist then value will be 'No'.
                string undiscResultFolder = Path.Combine(settingsService.RootPath, "UndiscDep", Model.SelectedTract, "SelectedResult");
                string summary = Path.Combine(undiscResultFolder, "summary.txt");
                string plot = Path.Combine(undiscResultFolder, "plot.jpeg");
                string estRationale = Path.Combine(undiscResultFolder, "EstRationale.txt");
                if (File.Exists(summary) && File.Exists(plot) && File.Exists(estRationale))
                {
                    if (File.Exists(Path.Combine(undiscResultFolder, "nDepEst.csv")))
                    {
                        Model.IsUndiscDepDone = "Yes (NegativeBinomial)";
                    }
                    else if (File.Exists(Path.Combine(undiscResultFolder, "nDepEstMiddle.csv")))
                    {
                        Model.IsUndiscDepDone = "Yes (MARK3)";
                    }
                    else if (File.Exists(Path.Combine(undiscResultFolder, "nDepEstCustom.csv")))
                    {
                        Model.IsUndiscDepDone = "Yes (Custom)";
                    }
                }
                Model.IsRaefDone = "No";  // If files don't exist then value will be 'No'.
                string raefResultFolder = Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", Model.SelectedTract, "SelectedResult");
                if (Directory.Exists(raefResultFolder))
                {
                    bool EF01_File_Exists = false;
                    bool EF04_File_Exists = false;
                    DirectoryInfo di = new DirectoryInfo(raefResultFolder);
                    foreach (FileInfo file in di.GetFiles())
                    {
                        if (file.Name.Contains("EF_01_Parameters_"))
                        {
                            EF01_File_Exists = true;
                        }
                        if (file.Name.Contains("EF_04_Contained_Stats_"))
                        {
                            EF04_File_Exists = true;
                        }
                    }
                    // If both files exist, then Raef have been ran. If not 'IsRaefDone' gets a value 'No'.
                    if (EF01_File_Exists == true && EF04_File_Exists == true)
                    {
                        Model.IsRaefDone = "Yes";
                    }
                }
            }
        }

        /// <summary>
        /// Check if the file is valid.
        /// </summary>
        /// <param name="textFile">TextFile for validation.</param>
        private void IsFileValid(string textFile)
        {
            using (var outputDocument = DocX.Create(""))
            {
                using (var inputDocument = DocX.Load(textFile))
                {
                    outputDocument.InsertDocument(inputDocument, true);
                }
            }
        }

        /// <summary>
        /// Select image from filesystem.
        /// </summary>
        private void SelectTractImageFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "JPG|*.jpg;*.jpeg|PNG|*.png|TIFF|*.tif;*.tiff", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(textFile))
                {
                    Model.TractImageFile = textFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to select file.");
                dialogService.ShowNotification("Failed to select file, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectKnownDepositsFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(textFile))
                {
                    IsFileValid(textFile);
                    Model.KnownDepositsFile = textFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to select file.");
                dialogService.ShowNotification("Failed to select file, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectProspectsOccurencesFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(textFile))
                {
                    IsFileValid(textFile);
                    Model.ProspectsOccurencesFile = textFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to select file.");
                dialogService.ShowNotification("Failed to select file, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectExplorationFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(textFile))
                {
                    IsFileValid(textFile);
                    Model.ExplorationFile = textFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to select file.");
                dialogService.ShowNotification("Failed to select file, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectSourcesFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(textFile))
                {
                    IsFileValid(textFile);
                    Model.SourcesFile = textFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to select file.");
                dialogService.ShowNotification("Failed to select file, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectReferencesFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(textFile))
                {
                    using (var document = DocX.Load(textFile))
                    {
                        IsFileValid(textFile);
                        Model.ReferencesFile = textFile;
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to select file.");
                dialogService.ShowNotification("Failed to select file, file might not be valid", "Error");
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
        /// Method for assessing whether the user is allowed to change the view.
        /// </summary>
        /// <returns>Boolean representing the state.</returns>
        private bool CanChangeView()
        {
            return !Model.IsBusy;
        }
    }
}
