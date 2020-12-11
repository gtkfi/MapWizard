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
using System.IO;
using System.Collections.ObjectModel;
using System.Linq;

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
        private TractAggregationModel model;
        private TractAggregationResultModel result;
        private ViewModelLocator viewModelLocator;

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
            viewModelLocator = new ViewModelLocator();
            model = new TractAggregationModel();
            result = new TractAggregationResultModel();
            SelectCorrelationMatrixCommand = new RelayCommand(SelectCorrelationMatrix, CanRunTool);
            SelectProbDistFileCommand = new RelayCommand(SelectProbDistFile, CanRunTool);
            FindTractsCommand = new RelayCommand(FindTractIDs, CanRunTool);
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            CombineDistFilesCommand = new RelayCommand(CombineDistFiles, CanRunTool);
            AddFilesToCombineListCommand = new RelayCommand(AddFilesToCombineList, CanRunTool);
            CombineTractsCommand = new RelayCommand(CombineTracts, CanRunTool);
            TractAggregationInputParams inputParams = new TractAggregationInputParams();
            string projectFolder = Path.Combine(settingsService.RootPath, "TractAggregation");
            if (!Directory.Exists(projectFolder))
            {
                Directory.CreateDirectory(projectFolder);
            }
            string param_json = Path.Combine(projectFolder, "tract_aggregation_input_params.json");
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    Model = new TractAggregationModel
                    {
                        CorrelationMatrix = inputParams.CorrelationMatrix,
                        ProbDistFile = inputParams.ProbDistFile,
                        WorkingDir = inputParams.WorkingDir,
                        TestName = inputParams.TestName,
                        CreateInputFile = bool.Parse(inputParams.CreateInputFile),
                        TractCombinationName = inputParams.TractCombinationName
                    };
                }
                catch (Exception ex)
                {
                    Model = new TractAggregationModel();
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Tract Aggregation tool's inputs correctly. Inputs were initialized to default values.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Tract Aggregation tool's inputs correctly. Inputs were initialized to default values.", "Error");
                }
            }
            else
            {
                Model = new TractAggregationModel();
            }
            FindTractIDs();
            if (Directory.Exists(Path.Combine(settingsService.RootPath, "TractAggregation", "AggResults")))
            {
                LoadResults();
            }
            var lastRunFile = Path.Combine(settingsService.RootPath, "TractAggregation", "tract_aggregation_last_run.lastrun");
            if (File.Exists(lastRunFile))
            {
                Model.LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
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
        /// Combine tracts to dictionary command.
        /// </summary>
        /// @return Command.
        public RelayCommand CombineTractsCommand { get; }

        /// <summary>
        /// Find TractIDs command.
        /// </summary>
        /// @return Command.
        public RelayCommand FindTractIDsAndOpenMenuCommand { get; }

        /// <summary>
        /// Method to open a dialog and save its result for loading the correlation matrix used by the R script.
        /// </summary>
        private void SelectCorrelationMatrix()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    Model.CorrelationMatrix = csvFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file", "Error");
            }
        }

        /// <summary>
        /// Method to open a dialog and save its result for loading the probability distribution file used by the R script.
        /// </summary>
        private void SelectProbDistFile()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    model.ProbDistFile = csvFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file", "Error");
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
                List<string> files = dialogService.OpenFilesDialog("", ".csv|*.csv;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(files.ToString()))
                {
                    foreach (string s in files)
                    {
                        Model.CombineFilesList.Add(s);
                    }
                }

            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file", "Error");
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
                foreach (string s in Model.CombineFilesList)
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
                viewModelLocator.SettingsViewModel.WriteLogText("Preparation for combining files was success in Tract Aggregation tool.", "Success");
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Preparation for combining files failed.");
                dialogService.ShowNotification("Preparation for combining files failed.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Preparation for combining files failed in Tract Aggregation tool.", "Error");
            }
        }

        /// <summary>
        /// Combine tracts to dictionary.
        /// </summary>
        private void CombineTracts()
        {
            logger.Info("-->{0}", this.GetType().Name);
            Model.TractPairRow.Clear();
            // Collection of rows that contain columns of tracts.
            Model.TractPairRow = new ObservableCollection<TractAggregationDataModel>();
            try
            {
                if (Model.TractIDCollection.Count > 1)
                {
                    TractAggregationDataModel row;
                    TractAggregationDataModel column;
                    foreach (var item in Model.TractIDCollection)
                    {
                        // Enumerator makes sure that tract pair will not be added twice.
                        using (IEnumerator<TractAggregationDataModel> tractIDEnumerator = Model.TractIDCollection.GetEnumerator())
                        {
                            while (tractIDEnumerator.Current != item)
                            {
                                tractIDEnumerator.MoveNext();
                            }
                            if (item.ChooseTract == true)
                            {                               
                                row = new TractAggregationDataModel();  // New row where columns will be added
                                row.TractPairColumn = new ObservableCollection<TractAggregationDataModel>();
                                string tractName = tractIDEnumerator.Current.TractName;
                                // Adds the first index.
                                if (tractIDEnumerator.Current.ChooseTract == true)
                                {                                   
                                    column = new TractAggregationDataModel();  // New column where tract pair information will be added.
                                    column.TractPairColumn.Clear();
                                    //column.TractName = item.TractName + " - " + tractIDEnumerator.Current.TractName;
                                    column.TractName = "";
                                    column.IsVisible = true;
                                    if (item.TractName == tractIDEnumerator.Current.TractName)
                                    {
                                        column.TractText = "1";
                                    }
                                    else
                                    {
                                        column.IsCorrelated = true;
                                    }
                                    row.TractPairColumn.Add(column);
                                }
                                // Adds other indexes.
                                while (tractIDEnumerator.MoveNext() != false)
                                {
                                    if (tractIDEnumerator.Current.ChooseTract == true)
                                    {                 
                                        TractAggregationDataModel newColumn = new TractAggregationDataModel();  // New column where tract pair information will be added.
                                        //newColumn.TractName = item.TractName + " - " + tractIDEnumerator.Current.TractName;
                                        newColumn.TractName = "";
                                        newColumn.IsVisible = true;
                                        if (item.TractName == tractIDEnumerator.Current.TractName)
                                        {
                                            newColumn.TractText = "1";
                                        }
                                        else
                                        {
                                            newColumn.IsCorrelated = true;
                                        }
                                        row.TractPairColumn.Add(newColumn);
                                    }
                                }                               
                                column = new TractAggregationDataModel();  // New column where tract pair information will be added.
                                column.TractName = tractName;
                                column.IsTitle = true;  // This column is used as a title for the row where it is located.
                                column.IsVisible = true; 
                                row.TractPairColumn.Add(column);
                                // Reverses the order so the matrix can turned upside down.
                                for (int i = 0; i < row.TractPairColumn.Count; i++)
                                {
                                    row.TractPairColumn.Move(row.TractPairColumn.Count - 1, i);
                                }
                                Model.TractPairRow.Add(row);
                            }
                        }
                    }
                    row = new TractAggregationDataModel();
                    Model.TractPairRow.Add(row);
                    for (int i = 0; i < Model.TractPairRow.Count; i++)
                    {
                        Model.TractPairRow.Move(Model.TractPairRow.Count - 1, i);
                    }
                    column = new TractAggregationDataModel();
                    //column.TractName = "test";
                    column.IsVisible = false;  // Makes the first column from first row hidden.
                    Model.TractPairRow[0].TractPairColumn.Add(column);
                    var reversedTractCollection = new ObservableCollection<TractAggregationDataModel>(Model.TractIDCollection.Reverse());
                    // Sets the column title by putting column names for the first row.
                    foreach (var item in reversedTractCollection)
                    {
                        if (item.ChooseTract == true)
                        {
                            column = new TractAggregationDataModel();
                            column.TractName = item.TractName;
                            column.IsTitle = true;
                            column.IsVisible = true; // Makes the other columns visible.
                            Model.TractPairRow[0].TractPairColumn.Add(column);
                        }
                    }
                }
                else
                {
                    dialogService.ShowNotification("Choose more than one tract.", "Error");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to create matrice of tract pairs.");
                dialogService.ShowNotification("Failed to create matrice of tract pairs.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to create matrice of tract pairs.", "Error");
            }
        }

        private string CreateCorrelationMatrix()
        {

            var csv = new StringBuilder();
            var thisRow="";
            TractAggregationDataModel tr;
            TractAggregationDataModel tc;
            for (int i=0;i<Model.TractPairRow.Count; i++)
            {
                tr = Model.TractPairRow[i];

                //this loop has to be made dumber to produce the empty commas in the end.
                for (int j = 0; j < Model.TractPairRow.Count; j++)
                {
                    if(tr.TractPairColumn.Count >j) { 
                        tc = tr.TractPairColumn[j];
                        if (tc.IsTitle == true)
                        {
                            thisRow = thisRow + (thisRow == "" ? (thisRow = tc.TractName) : (thisRow = (tc.TractName)));
                        }
                        else if (tc.TractText != null)
                        {
                            thisRow += (tc.TractText).Replace(",", ".");
                        }
                    }
                    thisRow += ",";
                }                           
                thisRow = thisRow.Remove(thisRow.Length - 1, 1);

                csv.AppendLine(thisRow);          
                thisRow = "";

            }
        
            //kato et se errori kans heittää täällä exceptionin. ja että tulee kunnon virheviestit. ei niin että menee ajoon asti ja ajossa tulee joku kryptinen "input file not found" herja
            string filePath = Path.Combine(settingsService.RootPath, "TractAggregation","CorrelationMatrix.csv");
            File.WriteAllText(filePath, csv.ToString());

            return filePath;                          
        }
        /// <summary>
        /// Get TractIDs.
        /// </summary>
        public string CombineTractPMFs()
        {

            var pmfString = "";
            var tractCsvPath = "";
            StringBuilder csv = new StringBuilder();
            csv.Append("TractID,NDeposits,RelProbs\r\n");
            foreach (TractAggregationDataModel tr in Model.TractPairRow)
            {
                if (tr.TractPairColumn[0].TractName != null)
                {
                    tractCsvPath = Path.Combine(settingsService.RootPath, "UndiscDep", tr.TractPairColumn[0].TractName, "SelectedResult", "TractPmf.csv");//tractId, "SelectedResult"

                    if (File.Exists(tractCsvPath))
                    {

                        pmfString = File.ReadAllText(tractCsvPath);
                        int indexToCutFrom = pmfString.IndexOf("\r\n");
                        pmfString = pmfString.Substring(indexToCutFrom + 2, pmfString.Length - indexToCutFrom - 2);
                        csv.Append(pmfString);
                    }
                }
                
            }
            string filePath = Path.Combine(settingsService.RootPath, "TractAggregation", "CorrespondingEstimates.csv");
            File.WriteAllText(filePath, csv.ToString());
            return filePath;

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
                
                if (Model.UseInputParams == true)
                {
                    Model.CorrelationMatrix=CreateCorrelationMatrix();//ilimota jos ei oo selectedresulttia
                    Model.ProbDistFile=CombineTractPMFs(); //nyt tosiaan toimii vaan selectedresulteille. is this OK?
                }
                else if (Model.CreateInputFile == true)
                {
                    CombineDistFiles();
                }
                TractAggregationInputParams inputParams = new TractAggregationInputParams
                {
                    CorrelationMatrix = Model.CorrelationMatrix,
                    ProbDistFile = Model.ProbDistFile,
                    WorkingDir = Model.WorkingDir,
                    TestName = Model.TestName,
                    CreateInputFile = Model.CreateInputFile.ToString(),
                    TractCombinationName = Model.TractCombinationName
                };
                logger.Trace(
                  "TractAggregationInputParams:\n" +
                  "\tCorrelationMatrix: '{0}'\n" +
                  "\tProbDistFile: '{1}'\n" +
                  "\tWorkingDir: '{2}'\n" +
                  "\tTestName: '{3}'\n",
                  inputParams.CorrelationMatrix,
                  inputParams.ProbDistFile,
                  inputParams.WorkingDir,
                  inputParams.TestName,
                  inputParams.TractCombinationName
                );
                Model.IsBusy = true;

                var lastResult = Path.Combine(settingsService.RootPath, "TractAggregation", "AggResults","AGG"+Model.TractCombinationName, "AggEstSummary.csv");
                if (File.Exists(lastResult))
                {
                    File.Delete(lastResult);
                }
                await Task.Run(() =>
                {
                    TractAggregationTool tool = new TractAggregationTool();
                    TractAggregationResult tractAggregationResult = default(TractAggregationResult);
                    logger.Info("calling TractAggregationTool.Execute(inputParams)");
                    tractAggregationResult = tool.Execute(inputParams) as TractAggregationResult;
                    Result.TractAggregationSummary = tractAggregationResult.TractAggregationSummary;
                });
                string lastRunFile = Path.Combine(Path.Combine(settingsService.RootPath, "TractAggregation", "tract_aggregation_last_run.lastrun"));
                File.Create(lastRunFile).Close();
                dialogService.ShowNotification("Tract Aggregation tool completed successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Tract Aggregation tool completed successfully.", "Success");
                Model.RunStatus = 1;
                Model.LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                //tänne se tractsaggregated.csv:n kirjotus, koska se on kaikille run typeille.
                Directory.CreateDirectory(Path.Combine(settingsService.RootPath, "TractDelineation", "Tracts", "AGG"+Model.TractCombinationName));
                var filePath = Path.Combine(Path.Combine(settingsService.RootPath, "TractDelineation", "Tracts", "AGG" + Model.TractCombinationName,"TractsAggregated.csv"));
                using (StreamReader sr = new StreamReader(Path.Combine(Path.Combine(settingsService.RootPath, "TractAggregation", "AggResults", "AGG" + Model.TractCombinationName, "TractCorrelations.csv"))))
                {
                  
                    var headers=sr.ReadLine();//elik tästä pitäs tulla full pathit eikä pelkät otsikot.
                    if (headers[0] == ',')
                        headers = headers.Substring(1);
                    var headerArray = headers.Split(',');
                    for(int i=0;i<headerArray.Length; i++)
                        headerArray[i]= Path.Combine(settingsService.RootPath, "TractDelineation", "Tracts", headerArray[i]);
                    var combinedHeaderArray = string.Join(",", headerArray);
                    File.WriteAllText(filePath, combinedHeaderArray);
                }              
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to run R-script.");
                dialogService.ShowNotification("Run failed. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Tract Aggregation tool run failed. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                Model.RunStatus = 0;
            }
            finally { Model.IsBusy = false; }
        }

        /// <summary>
        /// Method that loads tool results to Result model.
        /// </summary>
        private void LoadResults()
        {
            if (Model.TractCombinationName != null)
            {
                var projectFolder = Path.Combine(settingsService.RootPath, "TractAggregation", "AggResults", "AGG" + Model.TractCombinationName);
                var EstSummaryCSV = Path.Combine(projectFolder, "AggEstSummary.csv");
                Model.RunStatus = 1; //Set status to success: if file loading fails, it will be changed to error.
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
                        Model.RunStatus = 0;
                    }
                }
                catch (Exception ex)
                {
                    logger.Error(ex + " Could not load results files.");
                    dialogService.ShowNotification("Could not load results files.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Could not load results files in Tract Aggregation tool.", "Error");
                    Model.RunStatus = 0;
                }
            }
        }

        /// <summary>
        /// Get TractIDs.
        /// </summary>
        public void FindTractIDs()
        {
            Model.TractIDCollection.Clear();
            Model.TractIDCollection = new ObservableCollection<TractAggregationDataModel>();
            string tractRootPath = Path.Combine(settingsService.RootPath, "TractDelineation", "Tracts");
            if (Directory.Exists(tractRootPath))
            {
                DirectoryInfo di = new DirectoryInfo(tractRootPath);
                foreach (DirectoryInfo dir in di.GetDirectories())
                {
                    if (!dir.Name.StartsWith("AGG"))
                    {
                        string tractCsvPath = Path.Combine(settingsService.RootPath, "UndiscDep", dir.Name, "SelectedResult", "TractPmf.csv");
                        if (!dir.GetFiles().Any(f => f.Name == "TractsAggregated.csv") && File.Exists(tractCsvPath))
                        {
                            TractAggregationDataModel item = new TractAggregationDataModel
                            {
                                TractName = dir.Name,
                                ChooseTract = false
                            };
                            Model.TractIDCollection.Add(item);  // Get TractID by getting the name of the directory.                      
                        }
                    }
                }
            }
            else
            {
                Directory.CreateDirectory(Path.Combine(settingsService.RootPath, "TractDelineation", "Tracts"));
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
        /// Check if tool can be executed (not busy.)
        /// </summary>
        /// <returns>@return Boolean representing the state.</returns>
        private bool CanRunTool()
        {
            return !Model.IsBusy;
        }
    }
}
