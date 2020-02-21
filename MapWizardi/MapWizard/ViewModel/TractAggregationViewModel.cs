using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using MapWizard.Model;
using NLog;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using MapWizard.Tools.Settings;
using MapWizard.Service;
using System.Text;
using System.Threading.Tasks;
using MapWizard.Tools;
using System.Collections.ObjectModel;
using System.IO;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// This class contains properties that the TractAggregationView can data bind to.
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
    public class TractAggregationViewModel : ViewModelBase, INotifyPropertyChanged
    {
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private bool isBusy;
        private int runStatus;  // 0=error, 1=success, 2=not run yet.
        private string lastRunDate;
        private TractAggregationModel model;
        private TractAggregationResultModel result;
        private ObservableCollection<string> combineFilesList;

        /// <summary>
        /// Initializes a new instance of the TractAggregationViewModel class.
        /// </summary>
        /// <param name="logger">Logging for the MapWizard.</param>
        /// <param name="dialogService">Service for using dialogs and notifications.</param>
        /// <param name="settingsService">Service for using and editing settings.</param>
        public TractAggregationViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            combineFilesList = new ObservableCollection<string>();
            runStatus = 2;
            lastRunDate = "Last Run: Never";
            model = new TractAggregationModel
            {
                CorrelationMatrix = "Choose file",
                TestName = "",
                WorkingDir = "Choose folder",
                ProbDistFile = "Choose file"
            };
            result = new TractAggregationResultModel();
            SelectCorrelationMatrixCommand = new RelayCommand(SelectCorrelationMatrix, CanRunTool);
            SelectProbDistFileCommand = new RelayCommand(SelectProbDistFile, CanRunTool);
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            CombineDistFilesCommand = new RelayCommand(CombineDistFiles, CanRunTool);
            AddFilesToCombineListCommand = new RelayCommand(AddFilesToCombineList, CanRunTool);            
            if (Directory.Exists(Path.Combine(settingsService.RootPath, "AggResults")))
            {
                LoadResults();
            }
            var lastRunFile = Path.Combine(settingsService.RootPath, "AggResults", "tract_aggregation_last_run.lastrun");
            if (File.Exists(lastRunFile))
            {
                LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
            }
        }

        /// <summary>
        /// Select correlation matrix command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectCorrelationMatrixCommand { get; }

        /// <summary>
        /// Select propability distribution file command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectProbDistFileCommand { get; }

        /// <summary>
        /// Run tool command.
        /// </summary>
        /// @return Command.
        public RelayCommand RunToolCommand { get; }

        /// <summary>
        /// Add Files command.
        /// </summary>
        /// @return Command.
        public RelayCommand AddFilesToCombineListCommand { get; }

        /// <summary>
        /// Combine distribution Files command.
        /// </summary>
        /// @return Command.
        public RelayCommand CombineDistFilesCommand { get; }

        /// <summary>
        /// Method to open a dialog and save its result for loading the correlation matrix used by the R script.
        /// </summary>
        private void SelectCorrelationMatrix()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    Model.CorrelationMatrix = csvFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
        }

        /// <summary>
        /// Method to open a dialog and save its result for loading the probability distribution file used by the R script.
        /// </summary>
        private void SelectProbDistFile()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    model.ProbDistFile = csvFile.Replace("\\", "/");
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
        /// Method to open a dialog for loading separate input file(s) for creating the probability distribution file. 
        /// </summary>
        private void AddFilesToCombineList()
        {
            try
            {
                List<string> files = dialogService.OpenFilesDialog("", ".csv|*.csv;", true, true);
                if (!string.IsNullOrEmpty(files.ToString()))
                {
                    foreach (string s in files)
                    {
                        CombineFilesList.Add(s);
                    }
                }

            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
        }

        /// <summary>
        /// Function to combine the separate probability distributions to one file
        /// </summary>
        private void CombineDistFiles()
        {

            logger.Info("-->{0}", this.GetType().Name);
            // For now use nonsorted list (and listbox.) //Now the user needs a means to sort the files! you can just add them in the right order and that will do it, but....yeah.... also include means to remove files from list.
            try
            {
                var destFolder = Path.Combine(settingsService.RootPath, "AggTempFolder");
                var destFolderInfo = new DirectoryInfo(destFolder);
                if (!Directory.Exists(destFolder))
                {
                    Directory.CreateDirectory(destFolder);
                }
                else
                {
                    foreach (FileInfo f in destFolderInfo.GetFiles())
                        f.Delete();
                }
                FileInfo file;
                foreach (string s in CombineFilesList) 
                {
                    file = new FileInfo(s);
                    File.Copy(s, Path.Combine(destFolder, file.Name));
                }
                StringBuilder csv = new StringBuilder();
                int index = 1;
                foreach (FileInfo f in destFolderInfo.GetFiles())
                {
                    csv.Append("TN" + index + "," + f.Name + "\n");
                    index++;
                }
                var filePath = Path.Combine(destFolder, "ListFiles.csv");
                File.WriteAllText(filePath, csv.ToString());
                Model.ProbDistFile = Path.Combine(destFolder, "NewAggCProbsFile.csv");
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Preparation for combining files failed.");
            }
        }

        /// <summary>
        /// Run Tract Aggregation tool with user input. Calls TractAggregationTool class for functionality.
        /// </summary>
        private async void RunTool()
        {
            logger.Info("-->{0}", this.GetType().Name);
            try
            {
                string rootFolder = settingsService.RootPath;
                if (Model.CreateInputFile == true)
                {
                    CombineDistFiles();
                }
                TractAggregationInputParams inputParams = new TractAggregationInputParams
                {
                    CorrelationMatrix = model.CorrelationMatrix,
                    ProbDistFile = model.ProbDistFile,
                    WorkingDir = model.WorkingDir,
                    TestName = model.TestName,
                    CreateInputFile = model.CreateInputFile.ToString()
                };
                logger.Trace(
                  "GradeTonnageInputParams:\n" +
                  "\tCorrelationMatrix: '{0}'\n" +
                  "\tProbDistFile: '{1}'\n" +
                  "\tWorkingDir: '{2}'\n" +
                  "\tTestName: '{3}'\n",
                  inputParams.CorrelationMatrix,
                  inputParams.ProbDistFile,
                  inputParams.WorkingDir,
                  inputParams.TestName
                );
                IsBusy = true;

                var lastResult = Path.Combine(settingsService.RootPath, "AggResults", "AggEstSummary.csv");
                if (File.Exists(lastResult))
                {
                    File.Delete(lastResult);
                }
                await Task.Run(() =>
                {
                    TractAggregationTool tool = new TractAggregationTool();
                    TractAggregationResult tractAggregationResult = default(TractAggregationResult);
                    logger.Info("calling TractAggregationTool.Execute(inputParams)");
                    //tonnageResult = tool.Execute(inputParams) as GradeTonnageResult;
                    tractAggregationResult = tool.Execute(inputParams) as TractAggregationResult;
                    Result.TractAggregationSummary = tractAggregationResult.TractAggregationSummary;
                });
                string lastRunFile = Path.Combine(Path.Combine(settingsService.RootPath, "AggResults", "tract_aggregation_last_run.lastrun"));
                File.Create(lastRunFile);
                dialogService.ShowNotification("Tract Aggregation tool completed successfully", "Success");
                RunStatus = 1;
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
            }
            catch (Exception ex)
            {
                dialogService.ShowNotification("Run failed. Check output for details", "Error");
                RunStatus = 0;
                logger.Error(ex, "Failed to run R-script.");
            }
            finally { IsBusy = false; }
        }

        /// <summary>
        /// Method that loads tool results to Result model.
        /// </summary>
        private void LoadResults()
        {
            var projectFolder = Path.Combine(settingsService.RootPath, "AggResults");
            var EstSummaryCSV = Path.Combine(projectFolder, "AggEstSummary.csv");
            RunStatus = 1; //Set status to success: if file loading fails, it will be changed to error.
            try
            {
                // If result file exists.
                if (File.Exists(EstSummaryCSV)) 
                {
                    Result.TractAggregationSummary = File.ReadAllText(EstSummaryCSV); // Load file's contents to Result.
                }
                else
                {
                    Result.TractAggregationSummary = null;
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
        /// Collection containing a list of files for when probability distribution file is created from separate files.
        /// </summary>
        /// @return File list.
        public ObservableCollection<string> CombineFilesList
        {
            get
            {
                return combineFilesList;
            }
            set
            {
                if (value == combineFilesList) return;
                combineFilesList = value;
            }
        }

        /// <summary>
        /// TractAggregation Model.
        /// </summary>
        /// @return TractAggregationModel.
        public TractAggregationModel Model
        {
            get
            {
                return model;
            }
            set
            {
                model = value;
                RaisePropertyChanged("TractAggregationModel");
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
        /// Whether tool is busy or not.
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
        /// TractAggregation result model.
        /// </summary>
        /// @return TractAggregationResultModel.
        public TractAggregationResultModel Result
        {
            get
            {
                return result;
            }
            set
            {
                result = value;
                RaisePropertyChanged("TractAggregationResultModel");
            }
        }

        /// <summary>
        /// Date of last run.
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
        /// Check if tool can be executed (not busy.)
        /// </summary>
        /// <returns>@return Boolean representing the state.</returns>
        private bool CanRunTool()
        {
            return !IsBusy;
        }
    }
}
