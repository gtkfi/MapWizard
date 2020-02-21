using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using MapWizard.Model;
using MapWizard.Service;
using MapWizard.Tools;
using MapWizard.Tools.Settings;
using NLog;
using System;
using System.Collections.Generic;
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
        private bool isBusy;
        private string lastRunDate;
        private int runStatus;

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
            lastRunDate = "Last Run: Never";
            runStatus = 2;
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            GoToTractReportCommand = new RelayCommand(GoToTractReport, CanChangeView);
            GoToReportSelectionCommand = new RelayCommand(GoToReportSelection, CanChangeView);
            SelectTractImageFileCommand = new RelayCommand(SelectTractImageFile, CanRunTool);
            SelectTractCriteriaFileCommand = new RelayCommand(SelectTractCriteriaFile, CanRunTool);
            SelectKnownDepositsFileCommand = new RelayCommand(SelectKnownDepositsFile, CanRunTool);
            SelectProspectsOccurencesFileCommand = new RelayCommand(SelectProspectsOccurencesFile, CanRunTool);
            SelectExplorationFileCommand = new RelayCommand(SelectExplorationFile, CanRunTool);
            SelectSourcesFileCommand = new RelayCommand(SelectSourcesFile, CanRunTool);
            SelectReferencesFileCommand = new RelayCommand(SelectReferencesFile, CanRunTool);
            ReportingInputParams inputParams = new ReportingInputParams();
            string outputFolder = Path.Combine(settingsService.RootPath, "TractReport");
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
                        TractCriteriaFile = inputParams.TractCriteriaFile,
                        TractImageFile = inputParams.TractImageFile,
                        KnownDepositsFile = inputParams.KnownDepositsFile,
                        ProspectsOccurencesFile = inputParams.ProspectsOccurencesFile,
                        ExplorationFile = inputParams.ExplorationFile,
                        SourcesFile = inputParams.SourcesFile,
                        ReferencesFile = inputParams.ReferencesFile,
                        SelectedTractIndex = inputParams.SelectedTractIndex,
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
                    FindTractIDs();  // Gets the tractID names from PermissiveTractTool's Delineation folder.
                    CheckFiles();  // Check which of the needed files for creating a report exist.                   
                    RunStatus = 0;
                    DirectoryInfo dir = new DirectoryInfo(outputFolder);
                    // Check if the tool have ever been correctly ran before.
                    foreach (FileInfo file in dir.GetFiles())
                    {
                        if (file.Name.Contains("TractReport") && file.Name.Contains("docx"))  // If reporting file exist then the tool have been ran.
                        {
                            RunStatus = 1;
                        }
                    }
                    SaveInputs();  // Save inputs to tract_report_input_params.json file. This might be not needed(?).
                }
                catch (Exception ex)
                {
                    // If something goes wrong then the tool will be initialized to have default parameters.
                    Model = new ReportingModel
                    {
                        TractIDNames = new ObservableCollection<string>(),
                        TractCriteriaFile = "Choose Word file",
                        TractImageFile = "Choose image file",
                        KnownDepositsFile = "Choose Word file",
                        ProspectsOccurencesFile = "Choose Word file",
                        ExplorationFile = "Choose Word file",
                        SourcesFile = "Choose Word file",
                        ReferencesFile = "Choose Word file",
                        DescModelPath = "-",
                        DescModelName = "-",
                        GTModelPath = "-",
                        GTModelName = "-",
                        AddDescriptive = false,
                        AddGradeTon = false,
                        EnableDescCheck = false,
                        EnableGTCheck = false,
                        IsRaefDone = "No",
                        IsScreenerDone = "No",
                        IsUndiscDepDone = "No"
                    };
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Reporting tool's inputs correctly.", "Error");
                }
            }
            else
            {
                Model = new ReportingModel
                {
                    TractIDNames = new ObservableCollection<string>(),
                    TractCriteriaFile = "Choose Word file",
                    TractImageFile = "Choose image file",
                    KnownDepositsFile = "Choose Word file",
                    ProspectsOccurencesFile = "Choose Word file",
                    ExplorationFile = "Choose Word file",
                    SourcesFile = "Choose Word file",
                    ReferencesFile = "Choose Word file",
                    DescModelPath = "-",
                    DescModelName = "-",
                    GTModelPath = "-",
                    GTModelName = "-",
                    AddDescriptive = false,
                    AddGradeTon = false,
                    EnableDescCheck = false,
                    EnableGTCheck = false,
                    IsRaefDone = "No",
                    IsScreenerDone = "No",
                    IsUndiscDepDone = "No"
                };
                FindTractIDs(); // Gets the tractID names from PermissiveTractTool's Delineation folder.
            }
            // Check if the DepositType have been given correctly for the project.
            if (settingsService.Data.DepositType != null)
            {
                Model.DepositType = settingsService.Data.DepositType;
            }
            else
            {
                Model.DepositType = "-";
            }
            var lastRunFile = Path.Combine(settingsService.RootPath, "TractReport", "tract_report_last_run.lastrun");
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
        /// Command for tract criteria file selection.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectTractCriteriaFileCommand { get; }

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
        /// Switch to Tract Report or Summary Report.
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
        /// <returns>TractReportModel.</returns>
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
        /// Name of the selected Descriptive model.
        /// </summary>
        /// <returns>Descriptive model's name.</returns>
        public string DescModelName
        {
            get
            {
                return Model.DescModelName;
            }
            set
            {
                Model.DescModelName = value;
                RaisePropertyChanged("DescModelName");
                Model.EnableDescCheck = true;
            }
        }

        /// <summary>
        /// Name of the selected Grade-Tonnage model.
        /// </summary>
        /// <returns>Grade-Tonnage model's name.</returns>
        public string GTModelName
        {
            get
            {
                return Model.GTModelName;
            }
            set
            {
                Model.GTModelName = value;
                RaisePropertyChanged("GTModelName");
                Model.EnableGTCheck = true;
            }
        }

        /// <summary>
        /// Descriptive model path.
        /// </summary>
        /// <returns>Path to Descrptive model.</returns>
        public string DescModelPath
        {
            get
            {
                return Model.DescModelPath;
            }
            set
            {
                Model.DescModelPath = value;
                RaisePropertyChanged("DescModel");
            }
        }
        /// <summary>
        /// Grade-Tonnage model path.
        /// </summary>
        /// <returns>Path to Grade-Tonnage model.</returns>
        public string GTModelPath
        {
            get
            {
                return Model.GTModelPath;
            }
            set
            {
                Model.GTModelPath = value;
                RaisePropertyChanged("GTModel");
            }
        }

        /// <summary>
        /// Defines if all the files for the report are in SelectResult folder.
        /// </summary>
        /// <returns>Yes or No string.</returns>
        public string IsUndiscDepDone
        {
            get
            {
                return Model.IsUndiscDepDone;
            }
            set
            {
                Model.IsUndiscDepDone = value;
                RaisePropertyChanged("IsUndiscDepDone");
            }
        }

        /// <summary>
        /// Defines if all the files for the report are in SelectResult folder.
        /// </summary>
        /// <returns>Yes or No string.</returns>
        public string IsRaefDone
        {
            get
            {
                return Model.IsRaefDone;
            }
            set
            {
                Model.IsRaefDone = value;
                RaisePropertyChanged("IsRaefDone");
            }
        }

        /// <summary>
        /// Defines if all the files for the report are in SelectResult folder.
        /// </summary>
        /// <returns>Yes or No string.</returns>
        public string IsScreenerDone
        {
            get
            {
                return Model.IsScreenerDone;
            }
            set
            {
                Model.IsScreenerDone = value;
                RaisePropertyChanged("IsScreenerDone");
            }
        }

        /// <summary>
        /// Deposit type.
        /// </summary>
        /// <returns>Project's DepositType.</returns>
        public string DepositType
        {
            get
            {
                return Model.DepositType;
            }
            set
            {
                Model.DepositType = value;
                RaisePropertyChanged("DepositType");
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
                    SelectedTractIndex = Model.SelectedTractIndex,
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
                    TractCriteriaFile = Model.TractCriteriaFile,
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
                IsBusy = true;
                await Task.Run(() =>
                {
                    ReportingTool tool = new ReportingTool();
                    ddResult = tool.Execute(input) as ReportingResult;
                });
                var lastRunFile = Path.Combine(settingsService.RootPath, "TractReport", "tract_report_last_run.lastrun");
                File.Create(lastRunFile);
                dialogService.ShowNotification("Reporting tool completed successfully", "Success");
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to build documentation file");
                dialogService.ShowNotification("Run failed. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                RunStatus = 0;
            }
            finally
            {
                IsBusy = false;
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
                AsDate = Model.AsDate,
                AsDepth = Model.AsDepth,
                AsLeader = Model.AsLeader,
                AsTeamMembers = Model.AsTeamMembers,
                TractCriteriaFile = Model.TractCriteriaFile,
                TractImageFile = Model.TractImageFile,
                KnownDepositsFile = Model.KnownDepositsFile,
                ProspectsOccurencesFile = Model.ProspectsOccurencesFile,
                ExplorationFile = Model.ExplorationFile,
                SourcesFile = Model.SourcesFile,
                ReferencesFile = Model.ReferencesFile,
                IsUndiscDepDone = Model.IsUndiscDepDone,
                IsRaefDone = Model.IsRaefDone,
                IsScreenerDone = Model.IsScreenerDone
            };
            string outputFolder = Path.Combine(input.Env.RootPath, "TractReport");
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
            string tractRootPath = Path.Combine(settingsService.RootPath, "TractDelineation", "Delineation");
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
                Directory.CreateDirectory(Path.Combine(settingsService.RootPath, "TractDelineation", "Delineation"));
            }
        }

        /// <summary>
        /// Check files.
        /// </summary>
        public void CheckFiles()
        {
            string descResult = Path.Combine(settingsService.RootPath, "DescModel", "SelectedResult", Path.GetFileName(model.DescModelPath));
            // Checks if the result file for Descriptive model tool exists.
            if (!File.Exists(descResult))
            {
                Model.DescModelPath = "-";
                Model.DescModelName = "-";
                Model.AddDescriptive = false;
                Model.EnableDescCheck = false;  // Makes sure that the file that doesn't exist cannot be added to document.
            }
            string gtResult = Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult", "GradeTonnage_input_params.json");
            // Checks if the result file for Grade Tonnage tool exists.
            if (!File.Exists(gtResult))
            {
                Model.GTModelPath = "-";
                Model.GTModelName = "-";
                Model.AddGradeTon = false;
                Model.EnableGTCheck = false;  // Makes sure that the file that doesn't exist cannot be added to document. 
            }
            // The following if conditions are not good ways to check the existence of the files. nDepEst -files and other files in the folder need beter names for this.
            if (File.Exists(Path.Combine(settingsService.RootPath, "UndiscDep", "SelectedResult", "nDepEst.csv")))
            {
                Model.IsUndiscDepDone = "Yes (NegativeBinomial)";
            }
            else if (File.Exists(Path.Combine(settingsService.RootPath, "UndiscDep", "SelectedResult", "nDepEstMiddle.csv")))
            {
                Model.IsUndiscDepDone = "Yes (MARK3)";
            }
            else if (File.Exists(Path.Combine(settingsService.RootPath, "UndiscDep", "SelectedResult", "nDepEstCustom.csv")))
            {
                Model.IsUndiscDepDone = "Yes (Custom)";
            }
            else
            {
                Model.IsUndiscDepDone = "No";
            }
            Model.IsRaefDone = "No";   //         
            if (Directory.Exists(Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", "SelectedResult")))
            {
                bool EF01_File_Exists = false;
                bool EF04_File_Exists = false;
                DirectoryInfo di = new DirectoryInfo(Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", "SelectedResult"));
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

        /// <summary>
        /// Check if the file is valid.
        /// </summary>
        /// <param name="textFile">TextFile for validation.</param>
        /// <returns>Boolean representing the file's validation.</returns>
        private bool IsFileValid(string textFile)
        {
            var outputDocument = DocX.Create("");
            var document = DocX.Load(textFile);
            List<Table> tableList = document.Tables;
            // If all tables can be inserted to test file correctly then it means that the file is valid.
            foreach (var table in tableList)
            {
                outputDocument.InsertTable(table);
            }
            // Textfiles without tables wont't be accepted.
            if (tableList.Count == 0)
            {
                dialogService.ShowNotification("File was not valid", "Error");
                return false;
            }
            return true;
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectTractCriteriaFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true);
                if (!string.IsNullOrEmpty(textFile))
                {
                    var document = DocX.Load(textFile);
                    string documentText = document.Text;
                    Model.TractCriteriaFile = textFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to show OpenFileDialog, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select image from filesystem.
        /// </summary>
        private void SelectTractImageFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "JPG|*.jpg;*.jpeg|PNG|*.png|TIFF|*.tif;*.tiff", true, true);
                if (!string.IsNullOrEmpty(textFile))
                {
                    Model.TractImageFile = textFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to show OpenFileDialog, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectKnownDepositsFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true);
                if (!string.IsNullOrEmpty(textFile))
                {
                    IsFileValid(textFile);
                    bool validation = IsFileValid(textFile);
                    if (validation == true)  // TAGGED: == false?
                    {
                        Model.KnownDepositsFile = textFile;
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to show OpenFileDialog, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectProspectsOccurencesFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true);
                if (!string.IsNullOrEmpty(textFile))
                {
                    IsFileValid(textFile);
                    bool validation = IsFileValid(textFile);
                    if (validation == true)
                    {
                        Model.ProspectsOccurencesFile = textFile;
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to show OpenFileDialog, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectExplorationFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true);
                if (!string.IsNullOrEmpty(textFile))
                {
                    bool validation = IsFileValid(textFile);
                    if (validation == true)
                    {
                        Model.ExplorationFile = textFile;
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to show OpenFileDialog, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectSourcesFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true);
                if (!string.IsNullOrEmpty(textFile))
                {
                    bool validation = IsFileValid(textFile);
                    if (validation == true)
                    {
                        Model.SourcesFile = textFile;
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to show OpenFileDialog, file might not be valid", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectReferencesFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true);
                if (!string.IsNullOrEmpty(textFile))
                {
                    var document = DocX.Load(textFile); 
                    string documentText = document.Text;
                    if (documentText != "")
                    {
                        Model.ReferencesFile = textFile;
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog, file might not be valid");
                dialogService.ShowNotification("Failed to show OpenFileDialog, file might not be valid", "Error");
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
                RaisePropertyChanged();
                RunToolCommand.RaiseCanExecuteChanged();
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
        /// Method for assessing whether the user is allowed to change the view.
        /// </summary>
        /// <returns>Boolean representing the state.</returns>
        private bool CanChangeView()
        {
            return !IsBusy;
        }

        /// <summary>
        /// Status for the tool that shows if the tool ran correctly last time.
        /// </summary>
        /// <returns>Integer representing the status.</returns>
        public int RunStatus
        {
            get { return runStatus; }
            set
            {
                if (value == runStatus) return;
                runStatus = value;
                RaisePropertyChanged();
            }
        }

        /// <summary>
        /// Gets the last run time of the tool.
        /// </summary>
        /// <returns>Date and time of the last run.</returns>
        public string LastRunDate
        {
            get { return lastRunDate; }
            set
            {
                if (value == lastRunDate) return;
                lastRunDate = value;
                RaisePropertyChanged();
            }
        }
    }
}
