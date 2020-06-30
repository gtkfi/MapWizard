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
    public class ReportingAssesmentViewModel : ViewModelBase, INotifyPropertyChanged
    {
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private ReportingAssesmentModel model;
        private ViewModelLocator viewModelLocator;

        /// <summary>
        /// Initialize new instance of ReportingViewModel class.
        /// </summary>
        /// <param name="logger">Logging for the MapWizard</param>
        /// <param name="dialogService">Service for using project's dialogs and notifications</param>
        /// <param name="settingsService">Service for using and editing project's settings</param>
        public ReportingAssesmentViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            viewModelLocator = new ViewModelLocator();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            GoToAssesmentReportCommand = new RelayCommand(GoToAssesmentReport, CanChangeView);
            CheckTractFilesCommand = new RelayCommand(CheckFiles, CanRunTool);
            FindTractsCommand = new RelayCommand(FindTractIDs, CanRunTool);
            FindCombinedTractsCommand = new RelayCommand(FindCombinedTracts, CanRunTool);
            SelectTractImageFileCommand = new RelayCommand(SelectTractImageFile, CanRunTool);
            ReportingAssesmentInputParams inputParams = new ReportingAssesmentInputParams();
            string outputFolder = Path.Combine(settingsService.RootPath, "Reporting");
            if (!Directory.Exists(outputFolder))
            {
                Directory.CreateDirectory(outputFolder);
            }
            string param_json = Path.Combine(outputFolder, "assesment_report_input_params.json");
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    Model = new ReportingAssesmentModel
                    {
                        AssesmentTitle = inputParams.AssesmentTitle,
                        SelectedTractCombination = inputParams.SelectedTractCombination,
                        Authors = inputParams.Authors,
                        Country = inputParams.Country,
                        DescModelPath = inputParams.DescModel,
                        DescModelName = inputParams.DescModelName,
                        GTModelPath = inputParams.GTModel,
                        GTModelName = inputParams.GTModelName,
                        RaefFilePath = inputParams.RaefFile,
                        RaefFileName = inputParams.RaefFileName,
                        AddDescriptive = Convert.ToBoolean(inputParams.AddDescriptive),
                        AddGradeTon = Convert.ToBoolean(inputParams.AddGradeTon),
                        AddRaef = Convert.ToBoolean(inputParams.AddRaef),
                        EnableDescCheck = Convert.ToBoolean(inputParams.EnableDescCheck),
                        EnableGTCheck = Convert.ToBoolean(inputParams.EnableGTCheck),
                        EnableRaefCheck = Convert.ToBoolean(inputParams.EnableRaefCheck),
                        TractImageFile = inputParams.TractImageFile,
                        AsDate = inputParams.AsDate,
                        AsDepth = inputParams.AsDepth,
                        AsLeader = inputParams.AsLeader,
                        AsTeamMembers = inputParams.AsTeamMembers,
                        IsUndiscDepDone = inputParams.IsUndiscDepDone,
                        IsRaefDone = inputParams.IsRaefDone,
                        IsScreenerDone = inputParams.IsScreenerDone
                    };
                    FindTractIDs();  // Gets the tractID names from PermissiveTractTool's Tracts folder.
                    CheckFiles();  // Check which of the needed files for creating a report exist.             
                    FindCombinedTracts();
                    // Check if the tool have ever been correctly ran before.
                    if (Model.SelectedTractCombination != null) // Check if the tool have ever been correctly ran before.
                    {
                        //viewModelLocator.ReportingViewModel.Model.RunStatus = 0;  Remove this?
                        string docOutputFile = Path.Combine(outputFolder, Model.SelectedTractCombination, "AssesmentReport" + Model.SelectedTractCombination + ".docx");
                        if (File.Exists(docOutputFile))// If reporting file exist then the tool have been ran.
                        {
                            viewModelLocator.ReportingViewModel.Model.RunStatus = 1;
                        }
                    }
                    SaveInputs();  // Save inputs to tract_report_input_params.json file. This might be not needed(?).                    
                }
                catch (Exception ex)
                {
                    // If something goes wrong then the tool will be initialized to have default parameters.
                    Model = new ReportingAssesmentModel();
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Reporting tool's Assesment report's inputs correctly. Inputs were initialized to default values.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Reporting tool's Assesment report's inputs correctly. Inputs were initialized to default values.", "Error");
                }
            }
            else
            {
                Model = new ReportingAssesmentModel();
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
                viewModelLocator.ReportingViewModel.Model.LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
            }
        }

        /// <summary>
        /// Run tool command.
        /// </summary>
        /// @return Command.
        public RelayCommand RunToolCommand { get; }

        /// <summary>
        /// Command for switching into Assesment Report.
        /// </summary>
        /// @return Command.
        public RelayCommand GoToAssesmentReportCommand { get; }

        /// <summary>
        /// Command for getting tract spesific result files.
        /// </summary>
        /// @return Command.
        public RelayCommand CheckTractFilesCommand { get; }

        /// <summary>
        /// Command for getting tracts.
        /// </summary>
        /// @return Command.
        public RelayCommand FindTractsCommand { get; }

        /// <summary>
        /// Command for getting combined tracts.
        /// </summary>
        /// @return Command.
        public RelayCommand FindCombinedTractsCommand { get; }

        /// <summary>
        /// Command for tract image file selection.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectTractImageFileCommand { get; }

        /// <summary>
        /// Model for TractAssesmentReport.
        /// </summary>
        /// <returns>ReportingAssesmentModel.</returns>
        public ReportingAssesmentModel Model
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
                Model.TractIDNames.Clear();
                Model.TractIDChoices.Clear();
                foreach (var item in Model.TractIDCollection)
                {
                    Model.TractIDNames.Add(item.TractName);
                    Model.TractIDChoices.Add(item.IsTractChosen.ToString());
                }
                // 1. Collect input parameters
                ReportingAssesmentInputParams input = new ReportingAssesmentInputParams
                {
                    AssesmentTitle = Model.AssesmentTitle,
                    //CombinedTracts = Model.CombinedTracts,
                    TractIDNames = Model.TractIDNames,
                    TractIDChoices = Model.TractIDChoices,
                    SelectedTractCombination = Model.SelectedTractCombination,
                    Authors = Model.Authors,
                    Country = Model.Country,
                    DepositType = Model.DepositType,
                    DescModel = Model.DescModelPath,
                    DescModelName = Model.DescModelName,
                    GTModel = Model.GTModelPath,
                    GTModelName = Model.GTModelName,
                    RaefFile = Model.RaefFilePath,
                    RaefFileName = Model.RaefFileName,
                    AddDescriptive = Model.AddDescriptive.ToString(),
                    AddGradeTon = Model.AddGradeTon.ToString(),
                    AddRaef = Model.AddRaef.ToString(),
                    EnableDescCheck = Model.EnableDescCheck.ToString(),
                    EnableGTCheck = Model.EnableGTCheck.ToString(),
                    EnableRaefCheck = Model.EnableRaefCheck.ToString(),
                    TractImageFile = Model.TractImageFile,
                    AsDate = Model.AsDate,
                    AsDepth = Model.AsDepth,
                    AsLeader = Model.AsLeader,
                    AsTeamMembers = Model.AsTeamMembers,
                    IsUndiscDepDone = Model.IsUndiscDepDone,
                    IsRaefDone = Model.IsRaefDone,
                    IsScreenerDone = Model.IsScreenerDone
                };
                // User can choose not to insert Descriptive model document into report.
                if (Model.AddDescriptive == false)
                {
                    input.DescModelName = "-";
                }
                // User can chose not to insert Grade Tonnage file into report.
                if (Model.AddGradeTon == false)
                {
                    input.GTModelName = "-";
                }
                // User can chose not to insert Raef file into report.
                if (Model.AddRaef == false)
                {
                    input.RaefFileName = "-";
                }
                //// User can chose not to insert Report document into report.
                //if (Model.AddReport == false)
                //{
                //    input.ReportDocumentName = "-";
                //}
                // 2. Execute tool
                ReportingAssesmentResult ddResult = default(ReportingAssesmentResult);
                Model.IsBusy = true;
                await Task.Run(() =>
                {
                    ReportingAssesmentTool tool = new ReportingAssesmentTool();
                    ddResult = tool.Execute(input) as ReportingAssesmentResult;
                });
                var lastRunFile = Path.Combine(settingsService.RootPath, "Reporting", "tract_report_last_run.lastrun");
                File.Create(lastRunFile).Close();
                dialogService.ShowNotification("Reporting tool completed successfully", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Assesment report in Reporting tool completed successfully.", "Success");
                viewModelLocator.ReportingViewModel.Model.LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                viewModelLocator.ReportingViewModel.Model.RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to build documentation file");
                dialogService.ShowNotification("Run failed. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Assesment report in Reporting tool run failed. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                viewModelLocator.ReportingViewModel.Model.RunStatus = 0;
            }
            finally
            {
                Model.IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Save inputs so that the program remembers them if program is closed
        /// </summary>
        public void SaveInputs()
        {
            ReportingAssesmentInputParams input = new ReportingAssesmentInputParams
            {
                AssesmentTitle = Model.AssesmentTitle,
                //CombinedTracts = Model.CombinedTracts,
                SelectedTractCombination = Model.SelectedTractCombination,
                Authors = Model.Authors,
                Country = Model.Country,
                DepositType = Model.DepositType,
                DescModel = Model.DescModelPath,
                DescModelName = Model.DescModelName,
                GTModel = Model.GTModelPath,
                GTModelName = Model.GTModelName,
                RaefFile = Model.RaefFilePath,
                RaefFileName = Model.RaefFileName,
                AddDescriptive = Model.AddDescriptive.ToString(),
                AddGradeTon = Model.AddGradeTon.ToString(),
                AddRaef = Model.AddRaef.ToString(),
                EnableDescCheck = Model.EnableDescCheck.ToString(),
                EnableGTCheck = Model.EnableGTCheck.ToString(),
                EnableRaefCheck = Model.EnableRaefCheck.ToString(),
                TractImageFile = Model.TractImageFile,
                AsDate = Model.AsDate,
                AsDepth = Model.AsDepth,
                AsLeader = Model.AsLeader,
                AsTeamMembers = Model.AsTeamMembers,
                IsRaefDone = Model.IsRaefDone,
                IsScreenerDone = Model.IsScreenerDone,
                IsUndiscDepDone = Model.IsUndiscDepDone
            };
            string outputFolder = Path.Combine(input.Env.RootPath, "Reporting");
            if (!Directory.Exists(outputFolder))
            {
                Directory.CreateDirectory(outputFolder);
            }
            input.Save(Path.Combine(outputFolder, "assesment_report_input_params.json"));
        }

        /// <summary>
        /// Switch to Assesment Report.
        /// </summary>
        private void GoToAssesmentReport()
        {
            viewModelLocator.ReportingViewModel.ActiveView = "AssesmentReport";
        }

        /// <summary>
        /// Get TractIDs.
        /// </summary>
        public void FindTractIDs()
        {
            Model.TractIDCollection = new ObservableCollection<ReportingAssesmentModel>();
            Model.TractIDCollection.Clear();
            Model.TractIDNames = new ObservableCollection<string>();
            Model.TractIDNames.Clear();
            string tractRootPath = Path.Combine(settingsService.RootPath, "TractDelineation", "Tracts");
            if (Directory.Exists(tractRootPath))
            {
                DirectoryInfo di = new DirectoryInfo(tractRootPath);
                foreach (DirectoryInfo dir in di.GetDirectories())
                {
                    string tractReport = Path.Combine(settingsService.RootPath, "Reporting", dir.Name, "TractReport" + dir.Name + ".docx");
                    if (!dir.Name.StartsWith("AGG") && File.Exists(tractReport))
                    {
                        ReportingAssesmentModel item = new ReportingAssesmentModel
                        {
                            TractName = dir.Name,
                            IsTractChosen = false
                        };
                        Model.TractIDCollection.Add(item);  // Get TractID by getting the name of the directory.
                        Model.TractIDNames.Add(dir.Name);
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
            // Check if Raef file exist.
            if (Model.SelectedTractCombination != null)
            {
                if (Directory.Exists(Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", Model.SelectedTractCombination, "SelectedResult")))
                {
                    bool EF01_File_Exists = false;
                    bool EF04_File_Exists = false;
                    DirectoryInfo di = new DirectoryInfo(Path.Combine(settingsService.RootPath, "EconFilter", "RAEF", Model.SelectedTractCombination, "SelectedResult"));
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
                        Model.EnableRaefCheck = true;
                        Model.IsRaefDone = "Yes";
                    }
                    else
                    {
                        //Model.RaefFilePath = "-";
                        //Model.RaefFileName = "-";
                        Model.AddRaef = false;
                        Model.EnableRaefCheck = false;  // Makes sure that the file that doesn't exist cannot be added to document. 
                        Model.IsRaefDone = "No";
                    }
                }
            }
            Model.IsUndiscDepDone = "No";  // If files don't exist then value will be 'No'.
            if (Model.SelectedTractCombination != null)
            {
                string undiscResultFolder = Path.Combine(settingsService.RootPath, "UndiscDep", Model.SelectedTractCombination, "SelectedResult");
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
            }
        }

        /// <summary>
        /// Gets combined tracts.
        /// </summary>
        public void FindCombinedTracts()
        {
            Model.CombinedTracts = new ObservableCollection<string>();
            Model.CombinedTracts.Clear();
            string tractFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Tracts");
            if (Directory.Exists(tractFolder))
            {
                DirectoryInfo di = new DirectoryInfo(tractFolder);
                foreach (DirectoryInfo directory in di.GetDirectories())
                {
                    // This doesn't work if tract folder name contains 'AGG'. Better solution?
                    if (directory.Name.StartsWith("AGG"))
                    {
                        //directory contains csv
                        if (File.Exists(Path.Combine(directory.FullName, "TractsAggregated.csv")))
                        {
                            Model.CombinedTracts.Add(directory.Name);
                        }
                    }
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
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to show OpenFileDialog, file might not be valid", "Error");
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
