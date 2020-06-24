using System;
using System.Threading.Tasks;
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
using System.Diagnostics;
using System.Text;

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
            OpenGradePlotCommand = new RelayCommand(OpenGradePlot, CanRunTool);
            OpenTonnagePlotCommand = new RelayCommand(OpenTonnagePlot, CanRunTool);
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
                catch (Exception ex)
                {
                    Model = new GradeTonnageModel();
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Grade Tonnage tool's inputs correctly.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Grade Tonnage tool's inputs correctly.", "Error");
                }
            }
            else
            {
                Model = new GradeTonnageModel();
            }
            if (Directory.GetFiles(selectedProjectFolder).Length != 0)
            {
                LoadResults();
            }
            FindModelnames(projectFolder);
            var lastRunFile = Path.Combine(projectFolder, "GradeTonnage_last_run.lastrun");
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
        /// Open grade plot command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenGradePlotCommand { get; }

        /// <summary>
        /// Open tonnage plot command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenTonnagePlotCommand { get; }

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
        /// Run GradeTonnage with user input.
        /// </summary>
        private async void RunTool()
        {
            logger.Info("-->{0}", this.GetType().Name);
            // 1. Collect input parameters
            string rootFolder = settingsService.RootPath;
            if (Model.UseModelName == false)
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
            Model.IsBusy = true;
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
                if (!Model.ModelNames.Contains(modelFolder))
                {
                    Model.ModelNames.Add(modelFolder);
                }
                string lastRunFile = Path.Combine(Path.Combine(inputParams.Env.RootPath, "GTModel", "GradeTonnage_last_run.lastrun"));
                File.Create(lastRunFile).Close();
                dialogService.ShowNotification("GradeTonnageTool completed successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("GradeTonnageTool completed successfully", "Success");
                Model.LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                Model.RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to execute REngine() script");
                dialogService.ShowNotification("Run failed. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Grade Tonnage tool run failed. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                Model.RunStatus = 0;
            }
            finally
            {
                Model.IsBusy = false;
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
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true, settingsService.RootPath);
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
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
            finally
            {
                Model.SelectedIndex = 0;  // This is used to disable inputs depending on input type.
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
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true, settingsService.RootPath);
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
                Model.SelectedIndex = 1;  // These are used to disable inputs depending on input type.
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
                    if (!Model.ModelNames.Contains(gtRootPath))
                        Model.ModelNames.Add(gtRootPath);
                }
                Model.SelectedIndex = 2; // This is used to disable input controls on GradeTonnageInputView, depending on input type.         
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show FolderBrowserDialog");
                dialogService.ShowNotification("Error in folder selection.", "Error");
            }
        }

        /// <summary>
        /// Open grade image.
        /// </summary>
        private void OpenGradePlot()
        {
            try
            {
                bool openFile = dialogService.MessageBoxDialog();
                if (openFile == true)
                {
                    if (File.Exists(Result.GradePlot))
                    {
                        Process.Start(Result.GradePlot);
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
        /// Open tonnage image.
        /// </summary>
        private void OpenTonnagePlot()
        {
            try
            {
                bool openFile = dialogService.MessageBoxDialog();
                if (openFile == true)
                {
                    if (File.Exists(Result.TonnagePlot))
                    {
                        Process.Start(Result.TonnagePlot);
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
        /// Select certain result.
        /// </summary>
        private void SelectResult()
        {
            if (Model.ModelNames.Count <= 0 || Model.DepositModelsExtension.Length == 0)
            {
                dialogService.ShowNotification("Either the model was not selected or it was not given a name. ", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Either the model was not selected or it was not given a name.", "Error");
                return;
            }
            try
            {
                var modelDirPath = Model.ModelNames[Model.SelectedModelIndex];
                var modelDirInfo = new DirectoryInfo(Model.ModelNames[Model.SelectedModelIndex]);
                var selectedProjectFolder = Path.Combine(settingsService.RootPath, "GTModel", "SelectedResult");
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
                // Deletes all files and directories before adding new files.
                foreach (FileInfo file in dir.GetFiles())
                {
                    file.Delete();
                }
                foreach (DirectoryInfo direk in dir.GetDirectories())
                {
                    direk.Delete(true);
                }
                // Get files from selected model root folder and add them into SelectedResult folder.
                foreach (FileInfo file2 in modelDirInfo.GetFiles()) 
                {
                    var destPath = Path.Combine(selectedProjectFolder, file2.Name);
                    var sourcePath = Path.Combine(modelDirPath, file2.Name);
                    if (File.Exists(destPath))
                    {
                        File.Delete(destPath);
                    }
                    File.Copy(sourcePath, destPath);
                    if (Model.SaveToDepositModels == true)
                    {
                        var depositPath = Path.Combine(settingsService.DepositModelsPath, "DepositModels", "GradeTonnage", Model.DepositModelsExtension);
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
                string modelNameFile = Path.Combine(selectedProjectFolder, "GTModelName.txt");
                File.Create(modelNameFile).Close();
                using (StreamWriter writeStream = new StreamWriter(new FileStream(modelNameFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default))
                {
                    writeStream.Write(Model.DepositModelsExtension);
                }
                // Get parameters of the selected project.
                GradeTonnageInputParams inputParams = new GradeTonnageInputParams();
                string param_json = Path.Combine(selectedProjectFolder, "GradeTonnage_input_params.json");
                // Check if result files were moved into SelectedResult folder.
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
                // Update info to the Reporting tool.
                if((File.Exists(Path.Combine(selectedProjectFolder, "grade_summary.txt")) && File.Exists(Path.Combine(selectedProjectFolder, "grade_plot.jpeg")))
                    || (File.Exists(Path.Combine(selectedProjectFolder, "tonnage_summary.txt")) && File.Exists(Path.Combine(selectedProjectFolder, "tonnage_plot.jpeg"))))
                {
                    viewModelLocator.ReportingViewModel.Model.GTModelPath = selectedProjectFolder;
                    viewModelLocator.ReportingViewModel.Model.GTModelName = Model.DepositModelsExtension;
                    viewModelLocator.ReportingViewModel.SaveInputs();
                    viewModelLocator.ReportingAssesmentViewModel.Model.GTModelPath = selectedProjectFolder;
                    viewModelLocator.ReportingAssesmentViewModel.Model.GTModelName = Model.DepositModelsExtension;
                    viewModelLocator.ReportingAssesmentViewModel.SaveInputs();
                }
                Model.DepositModelsExtension = "";
                Model.SaveToDepositModels = false;
                dialogService.ShowNotification("Model selected successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Grade Tonnage model selected successfully.", "Success");
            }
            catch (Exception ex)
            {
                // TAGGED: Initialize new model?
                logger.Trace(ex, "Error in Model Selection");
                dialogService.ShowNotification("Failed to select model.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to select model in Grade Tonnage tool.", "Error");
            }
            var metroWindow = (Application.Current.MainWindow as MetroWindow);
            var dialog = metroWindow.GetCurrentDialogAsync<BaseMetroDialog>();
            metroWindow.HideMetroDialogAsync(dialog.Result);
            LoadResults();
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
                            Model.ModelNames.Add(model.FullName);
                        }
                    }
                }
            }
            foreach (FileInfo file in projectFolderInfo.GetFiles())  // Search from main folder.
            {
                if (file.Name == "GradeTonnage_input_params.json")
                {
                    Model.ModelNames.Add(projectFolderInfo.FullName);
                }
            }
        }

        /// <summary>
        /// Check if tool can be executed (not busy.)
        /// </summary>
        /// @return Boolean representing the state.
        private bool CanRunTool()
        {
            return !Model.IsBusy;
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
        /// Method to create bitmap from image. Prevents file locks from binding in XAML.
        /// </summary>
        /// <param name="source">Path for bitmap.</param>
        /// <returns>Bitmap.</returns>
        private ImageSource BitmapFromUri(string source)
        {
            if (source == null)
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
            Model.RunStatus = 1;  // Set status to error if any of the files is not found.
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
                        Model.RunStatus = 0;
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
                        Model.RunStatus = 0;
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
                        Model.RunStatus = 0;
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
                        Model.RunStatus = 0;
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
                        Model.RunStatus = 0;
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
                        Model.RunStatus = 0;
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex + " Could not load results files");
                dialogService.ShowNotification("Failed to load Grade Tonnage tool's result files.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to load Grade Tonnage tool's result files.", "Error");
            }
        }
    }
}

