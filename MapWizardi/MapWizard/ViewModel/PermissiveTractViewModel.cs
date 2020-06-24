using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using MapWizard.Model;
using MapWizard.Service;
using MapWizard.Tools;
using MapWizard.Tools.Settings;
using NLog;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// This class contains properties that the PermissiveTractView can data bind to.
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

    public class PermissiveTractViewModel : ViewModelBase, INotifyPropertyChanged
    {
        private readonly ILogger logger;
        private readonly ISettingsService settingsService;
        private readonly IDialogService dialogService;
        ViewModelLocator viewModelLocator;
        private PermissiveTractModel model;
        private PermissiveTractResultModel result;
        private bool isBusy;
        public event PropertyChangedEventHandler PropertyChanged;
        private string lastRunDate;
        private int runStatus; //0= error, 1=success, 2=not run yet
        private int tabIndex;
        private string projectFolder;
        private string delineationFolder;
        private string classificationFolder;
        private string finalRasterFolder;
        private string evidenceDataFolder;
        private string fileFolder;
        private string selectedBoundary = "";
        private string selectedClassificationRaster = "";
        private string delineationCleanFile;
        private bool _showAcceptButton;
        private bool _showGenTracts;
        private bool _showSaveTract;
        private bool _showClassRasters;
        private string delineationSummaryStatistics = "";
        private string delineationCumulativeDistribution = "";
        private string _permissiveTractInputShape;
        private string boundaryValue;
        private bool fuzzyFromClassification = false;
        private bool wofeFromClassification = false;

        public bool ShowButton
        {
            get { return _showAcceptButton; }
            set
            {
                _showAcceptButton = value;
                OnPropertyChanged("ShowButton");
            }
        }

        public bool ShowGenTracts
        {
            get { return _showGenTracts; }
            set
            {
                _showGenTracts = value;
                OnPropertyChanged("ShowGenTracts");
            }
        }

        public bool ShowSaveTract
        {
            get { return _showSaveTract; }
            set
            {
                _showSaveTract = value;
                OnPropertyChanged("ShowSaveTract");
            }
        }

        public bool ShowClassRasters
        {
            get { return _showClassRasters; }
            set
            {
                _showClassRasters = value;
                OnPropertyChanged("ShowClassRasters");
            }
        }


        /// <summary>
        /// Initializes a new instance of the PermissiveTract class.
        /// </summary>
        public PermissiveTractViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            lastRunDate = "Last Run: Never";
            runStatus = 2;

            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            RunFuzzyCommand = new RelayCommand(RunFuzzy, CanRunTool);
            RunWofeCommand = new RelayCommand(RunWofeProcess, CanRunTool);
            GenerateTractsCommand = new RelayCommand(GenerateTracts, CanRunTool);
            CalculateTresholdCommand = new RelayCommand(CalculateTreshold, CanRunTool);
            ClassificationCommand = new RelayCommand(Classificate, CanRunTool);
            SelectFilesCommand = new RelayCommand(SelectFiles, CanRunTool);
            SelectRastersCommand = new RelayCommand(SelectRasters, CanRunTool);
            SelectFolderCommand = new RelayCommand(SelectFolder, CanRunTool);
            SaveFileCommand = new RelayCommand(SaveFile, CanRunTool);
            SaveTractPolygonCommand = new RelayCommand(SaveTract, CanRunTool);
            SaveFinalTractCommand = new RelayCommand(SaveFinalTract, CanRunTool);
            ShowResultsCommand = new RelayCommand(ShowResults, CanRunTool);
            ShowBoundariesCommand = new RelayCommand(ShowBoundaries, CanRunTool);
            SelectEvidenceFilesCommand = new RelayCommand(SelectEvidenceFiles, CanRunTool);
            SelectPRCommand = new RelayCommand(SelectPRFile, CanRunTool);
            SelectDRCommand = new RelayCommand(SelectDRFile, CanRunTool);
            SelectTPCommand = new RelayCommand(SelectTPFile, CanRunTool);
            SelectMaskCommand = new RelayCommand(SelectMaskFile, CanRunTool);
            SelectEvidenceLayerFileCommand = new RelayCommand(SelectEvidenceLayerFile, CanRunTool);
            AcceptSelectedBoundaryCommand = new RelayCommand(AcceptSelectedBoundary, CanRunTool);
            AcceptSelectedRasterCommand = new RelayCommand(AcceptSelectedRaster, CanRunTool);
            PathToTractPolygonCommand = new RelayCommand(PathToTractPolygon, CanRunTool);
            ClassificationFuzzyCommand = new RelayCommand(ClassificationFuzzy, CanRunTool);
            DelineationFuzzyCommand = new RelayCommand(DelineationFuzzy, CanRunTool);
            ClassificationWofeCommand = new RelayCommand(ClassificationWofe, CanRunTool);
            DelineationWofeCommand = new RelayCommand(DelineationWofe, CanRunTool);
            DeleteBoundariesCommand = new RelayCommand(DeleteBoundaries, CanRunTool);
            TractChangedCmd = new RelayCommand(TractChanged, CanRunTool);


            viewModelLocator = new ViewModelLocator();
            result = new PermissiveTractResultModel();

            PermissiveTractInputParams inputParams = new PermissiveTractInputParams();

            //folders:
            string PermissiveTractProject = settingsService.Data.RootFolderPath + @"\TractDelineation\";
            projectFolder = Path.Combine(settingsService.RootPath, "TractDelineation");
            evidenceDataFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Delineation", "Fuzzy", "EvidenceData");
            //prospRastersFolder = Path.Combine(settings.RootPath, "TractDelineation", "ProspRaster");
            delineationFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Delineation");
            classificationFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Classification");
            finalRasterFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Delineation", "DelineationRasters");

            if (!Directory.Exists(@PermissiveTractProject))
            {
                Directory.CreateDirectory(@PermissiveTractProject);
            }

            if (!Directory.Exists(@finalRasterFolder))
            {
                Directory.CreateDirectory(@finalRasterFolder);
            }

            if (!Directory.Exists(evidenceDataFolder))
            {
                Directory.CreateDirectory(evidenceDataFolder);
            }

            string param_json = projectFolder + "\\permissive_tract_input_params.json";
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    model = new PermissiveTractModel
                    {
                        EnvPath = inputParams.EnvPath,
                        InRasterList = inputParams.InRasterList,
                        OutRaster = inputParams.OutRaster,
                        MethodId = inputParams.MethodId,
                        EvidenceRasterlist = inputParams.EvidenceRasterList,
                        UnitArea = inputParams.UnitArea,
                        MaskRaster = inputParams.MaskRaster,
                        WorkSpace = inputParams.WorkSpace,
                        FuzzyOverlayType = inputParams.FuzzyOverlayType,
                        WofEWeightsType = inputParams.WofEWeightsType,
                        FuzzyOutputFile = inputParams.FuzzyOutputFileName,
                        FuzzyGammaValue = inputParams.FuzzyGammaValue,
                        LastFuzzyRound = inputParams.LastFuzzyRound,
                        ProspectivityRaster = inputParams.ProspectivityRasterFile,
                        TractBoundaryValues = inputParams.BoundaryValues,
                        TractBoundaryRasterlist = null,
                        EvidenceLayerFile = inputParams.EvidenceLayerFile,
                        DelID = inputParams.DelID,
                        DelineationRaster = inputParams.DelineationRaster,
                        MinMaxValues = inputParams.MinMaxValues,
                        NumbOfProsClasses = inputParams.NumberOfProspectivityClasses,
                        TresholdValues = inputParams.TresholdValues,
                        ClassificationId = inputParams.ClassificationId,
                        TrainingPoints = inputParams.TrainingPoints,
                        Arcsdm = inputParams.ArcSdm,
                        ConfidenceLevel = inputParams.ConfidenceLevel
                    };
                    FindTractIDs();  // Gets the tractID names from PermissiveTractTool's Delineation folder.

                }
                catch (Exception ex)
                {
                    model = new PermissiveTractModel
                    {
                        EnvPath = @PermissiveTractProject,
                        InRasterList = { },
                        OutRaster = @PermissiveTractProject,
                        MethodId = "fuzzy",
                        TractBoundaryRasterlist = null
                    };
                    FindTractIDs();  // Gets the tractID names from PermissiveTractTool's Delineation folder.
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Permissive Tract tool's inputs correctly. Inputs were initialized to default values.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Permissive Tract tool's inputs correctly. Inputs were initialized to default values.", "Error");
                }
            }
            else
            {
                model = new PermissiveTractModel
                {
                    EnvPath = @PermissiveTractProject,
                    InRasterList = { },
                    OutRaster = @PermissiveTractProject,
                    MethodId = "fuzzy",
                    LastFuzzyRound = "False",
                    TractBoundaryRasterlist = null
                };
            }

            ShowButton = false;
            ShowGenTracts = false;
            ShowClassRasters = false;
            ShowSaveTract = false;

            upDateTractBoundaryList();
        }

        /// <summary>
        /// Run tool command.
        /// </summary>
        public RelayCommand RunToolCommand { get; }
        /// <summary>
        /// Run fuzzy -tool command.
        /// </summary>
        public RelayCommand RunFuzzyCommand { get; }
        /// <summary>
        /// Run wofe command.
        /// </summary>
        public RelayCommand RunWofeCommand { get; }
        /// <summary>
        /// Select files in filesystem command.
        /// </summary>
        public RelayCommand SelectFilesCommand { get; }
        /// <summary>
        /// Select rasters for fuzzy in filesystem command.
        /// </summary>
        public RelayCommand SelectRastersCommand { get; }
        /// <summary>
        /// Select evidence files in filesystem command.
        /// </summary>
        public RelayCommand SelectEvidenceFilesCommand { get; }
        /// <summary>
        /// Select folder command.
        /// </summary>
        public RelayCommand SelectFolderCommand { get; }
        /// <summary>
        /// Save file command.
        /// </summary>
        public RelayCommand SaveFileCommand { get; }
        /// <summary>
        /// Save tract polygon file command.
        /// </summary>
        public RelayCommand SaveTractPolygonCommand { get; }
        /// <summary>
        /// Save final tract files command.
        /// </summary>
        public RelayCommand SaveFinalTractCommand { get; }
        /// <summary>
        /// Show results folder.
        /// </summary>
        public RelayCommand ShowResultsCommand { get; }
        /// <summary>
        /// Show boundaries folder.
        /// </summary>
        public RelayCommand ShowBoundariesCommand { get; }
        /// <summary>
        /// Select prospectivity raster command
        /// </summary>
        public RelayCommand SelectPRCommand { get; }
        /// <summary>
        /// Select delineation raster command
        /// </summary>
        public RelayCommand SelectDRCommand { get; }
        /// <summary>
        /// Select training point file command
        /// </summary>
        public RelayCommand SelectTPCommand { get; }
        /// <summary>
        /// Select mask file command
        /// </summary>
        public RelayCommand SelectMaskCommand { get; }
        /// <summary>
        /// Select tract polygon
        /// </summary>
        public RelayCommand PathToTractPolygonCommand { get; }
        /// <summary>
        /// Create raster with Fussy when in Classification  
        /// </summary>
        public RelayCommand ClassificationFuzzyCommand { get; }
        /// <summary>
        /// Create raster with Fussy when in delination  
        /// </summary>
        public RelayCommand DelineationFuzzyCommand { get; }
        /// <summary>
        /// Create raster with Wofe when in classification  
        /// </summary>
        public RelayCommand ClassificationWofeCommand { get; }
        /// <summary>
        /// Create raster with Wofe when in delination  
        /// </summary>
        public RelayCommand DelineationWofeCommand { get; }
        /// <summary>
        /// Select evidence layer file command
        /// </summary>
        public RelayCommand SelectEvidenceLayerFileCommand { get; }
        /// <summary>
        /// Accept boudary command
        /// </summary>
        public RelayCommand AcceptSelectedBoundaryCommand { get; }
        /// <summary>
        /// Accept selected classification raster command
        /// </summary>
        public RelayCommand AcceptSelectedRasterCommand { get; }
        /// <summary>
        /// Gnerate tracts command
        /// </summary>
        public RelayCommand GenerateTractsCommand { get; }
        /// <summary>
        /// Calculate treshold values for clasification process
        /// </summary>
        public RelayCommand CalculateTresholdCommand { get; }
        /// <summary>
        /// Execute classification process
        /// </summary>
        public RelayCommand ClassificationCommand { get; }
        /// <summary>
        /// Delete generated boundary files
        /// </summary>
        public RelayCommand DeleteBoundariesCommand { get; }
        /// <summary>
        /// Tract changed in classification process
        /// </summary>
        public RelayCommand TractChangedCmd { get; }
        /// <summary>
        /// 
        /// </summary>
        public ObservableCollection<string> PdfTypes { get; } = new ObservableCollection<string>() { "normal", "kde" };
        /// <summary>
        /// 
        /// </summary>
        public ObservableCollection<string> Truncated { get; } = new ObservableCollection<string>() { "FALSE", "TRUE" };
        /// <summary>
        /// AND —The minimum of the fuzzy memberships from the input fuzzy rasters.
        /// OR —The maximum of the fuzzy memberships from the input rasters.
        /// PRODUCT —A decreasive function.Use this when the combination of multiple evidence is less important or smaller than any of the inputs alone.
        /// SUM —An increasive function.Use this when the combination of multiple evidence is more important or larger than any of the inputs alone.
        /// GAMMA —The algebraic product of the fuzzy Sum and fuzzy Product, both raised to the power of gamma.
        /// </summary>
        public ObservableCollection<string> FuzzyOverlayTypeIDs { get; } = new ObservableCollection<string>() { "AND", "OR", "PRODUCT", "SUM", "GAMMA" };
        /// <summary>
        /// 
        /// </summary>
        public ObservableCollection<string> WofEWeightTypeIDs { get; } = new ObservableCollection<string>() { "Descending", "Ascending", "Categorial", "Unique" };
        /// <summary>
        /// 
        /// </summary>
        public ObservableCollection<ImageSource> BoundariesImages
        {
            get
            {
                var results = new ObservableCollection<ImageSource>();
                try
                {
                    results.Add(LoadImage("C:\\Temp\\result_plot.jpeg"));
                    results.Add(LoadImage("C:\\Temp\\plot.jpeg"));
                }
                catch (Exception ex)
                {
                    logger.Error(ex, "Failed to load result images");
                    dialogService.ShowNotification("Failed to load result images", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Failed to load result images in Permissive Tract tool.", "Error");
                }
                return results;
            }
        }


        public static ImageSource LoadImage(string fileName)
        {
            var image = new BitmapImage();

            using (var stream = new FileStream(fileName, FileMode.Open))
            {
                image.BeginInit();
                image.CacheOption = BitmapCacheOption.OnLoad;
                image.StreamSource = stream;
                image.EndInit();
            }

            return image;
        }

        /// <summary>
        /// 
        /// </summary>
        public PermissiveTractModel Model
        {
            get
            {
                return model;
            }
            set
            {
                model = value;
                RaisePropertyChanged("PermissiveTractModel");
            }
        }
        /// <summary>
        /// 
        /// </summary>
        public PermissiveTractResultModel Result
        {
            get
            {
                return result;
            }
            set
            {
                result = value;
                RaisePropertyChanged("PermissiveTractResultModel");
            }
        }
        /// <summary>
        /// Flag indicating if something if processed.
        /// </summary>
        public bool IsBusy
        {
            get { return isBusy; }
            set
            {
                if (isBusy == value) return;
                isBusy = value;
                RaisePropertyChanged(() => IsBusy);
                OnPropertyChanged();
                RunToolCommand.RaiseCanExecuteChanged();
                RunFuzzyCommand.RaiseCanExecuteChanged();
                RunWofeCommand.RaiseCanExecuteChanged();
                GenerateTractsCommand.RaiseCanExecuteChanged();
                CalculateTresholdCommand.RaiseCanExecuteChanged();
                ClassificationCommand.RaiseCanExecuteChanged();
                SelectFilesCommand.RaiseCanExecuteChanged();
                SelectRastersCommand.RaiseCanExecuteChanged();
                SelectEvidenceFilesCommand.RaiseCanExecuteChanged();
                SelectFolderCommand.RaiseCanExecuteChanged();
                SaveFileCommand.RaiseCanExecuteChanged();
                ShowResultsCommand.RaiseCanExecuteChanged();
                ShowBoundariesCommand.RaiseCanExecuteChanged();
                AcceptSelectedRasterCommand.RaiseCanExecuteChanged();
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


        private void TractChanged()
        {
            //viewModelLocator.DepositDensityViewModel.Model.SelectedTract = Model.SelectedTract;
            
            string maskFile = Path.Combine(projectFolder,"Tracts", Model.SelectedTract, Model.SelectedTract+".shp");
            if (File.Exists(maskFile))
            {
                Model.MaskRaster = maskFile;
            } 
            
        }

        private async void AcceptSelectedBoundary()
        {
            string boundaryFile = selectedBoundary.ToString();
            if (boundaryFile == null || boundaryFile == "")
            {
                dialogService.ShowNotification("You must select boundary file!", "Error");
                return;
            }
            try
            {
                string tmpString = "DelineationRaster_";
                int start = boundaryFile.IndexOf(tmpString);
                start += tmpString.Length;
                tmpString = ".pdf";
                int end = boundaryFile.IndexOf(tmpString);
                boundaryValue = boundaryFile.Substring(start, end - start);
                string outputFolder = projectFolder + @"\Delineation\temp\" + model.DelID.ToString() + @"\";

                if (!Directory.Exists(@outputFolder))
                {
                    Directory.CreateDirectory(@outputFolder);
                }



                //Generate polygon
                try
                {
                    logger.Info("-- >{0}", this.GetType().Name);

                    string pythonPath = settingsService.PythonPath;// "C:\\Program Files\\ArcGIS\\Pro\\bin\\Python\\envs\\arcgispro-py3\\pythonw.exe";

                    var path = System.AppDomain.CurrentDomain.BaseDirectory;
                    var scriptPath = "scripts\\";
                    string method = "";
                    method = "delineation_polygon";
                    scriptPath += "";

                    PermissiveTractInputParams inputParams = new PermissiveTractInputParams
                    {
                        PythonPath = pythonPath,
                        ScriptPath = scriptPath,
                        EnvPath = model.EnvPath,
                        InRasterList = model.InRasterList,
                        OutRaster = model.OutRaster,
                        MethodId = method,
                        FuzzyOverlayType = model.FuzzyOverlayType,
                        FuzzyOutputFileName = model.FuzzyOutputFile,
                        FuzzyGammaValue = model.FuzzyGammaValue,
                        LastFuzzyRound = model.LastFuzzyRound,
                        ProspectivityRasterFile = model.ProspectivityRaster,
                        BoundaryValues = boundaryValue,
                        EvidenceLayerFile = model.EvidenceLayerFile,
                        DelID = model.DelID,
                        EvidenceRasterList = model.EvidenceRasterlist,
                        UnitArea = model.UnitArea,
                        MaskRaster = model.MaskRaster,
                        WorkSpace = model.WorkSpace,
                        WofEWeightsType = model.WofEWeightsType,
                        TrainingPoints = model.TrainingPoints
                    };

                    logger.Trace(
                         "PermissiveTractInputParams:\n" +
                         "\tPythonPath: '{0}'\n" +
                         "\tScriptPath: '{1}'\n" +
                         "\tEnvPath: '{2}'\n" +
                         "\tInRasterList: '{3}'\n" +
                         "\tOutRaster: '{4}'\n",
                         inputParams.PythonPath,
                         inputParams.ScriptPath,
                         inputParams.EnvPath,
                         inputParams.InRasterList,
                         inputParams.OutRaster
                     );

                    PermissiveTractResult permissiveTractResult = default(PermissiveTractResult);
                    IsBusy = true;

                    await Task.Run(() =>
                    {
                        PermissiveTractTool tool = new PermissiveTractTool();
                        logger.Info("calling PermissiveTractTool.Execute(inputParams)");
                        permissiveTractResult = tool.Execute(inputParams) as PermissiveTractResult;
                        logger.Trace("PermissiveTractResult:\n" +
                      "\tReturnValue: '{0}'\n",
                      permissiveTractResult.PermissiveTractResults,
                      permissiveTractResult.CalculateResponsesResult,
                      permissiveTractResult.CalculateWeightsResult
                    );
                        // 3. Publish results
                        logger.Trace("Publishing results");
                        Result.ReturnValue = permissiveTractResult.PermissiveTractResults + " " + permissiveTractResult.CalculateWeightsResult + " " + permissiveTractResult.CalculateResponsesResult;
                        //List<string> f = new List<string>(new string[] { "element1", "element2", "element3" });

                        if (inputParams.MethodId == "delineation")
                        {
                            upDateTractBoundaryList();
                            /*string[] f = Directory.GetFiles(Path.Combine(projectFolder, "Delineation", "temp"), "BoundariesOnEvidence*");
                            List<string> list = new List<string>(f);
                            model.TractBoundaryRasterlist = list;
                            ShowButton = true;
                            viewModelLocator.ReportingViewModel.FindTractIDs();*/
                        }

                    });

                    dialogService.ShowNotification("Delineation completed successfully.", "Success");
                    viewModelLocator.SettingsViewModel.WriteLogText("Delineation completed successfully in Permissive Tract tool.", "Success");
                    LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                    RunStatus = 1;

                }
                finally
                {
                    IsBusy = false;
                }


                //Copy Delineation raster
                string sourceFile = projectFolder + @"\Delineation\temp\DelineationRaster_" + boundaryValue + ".img";
                //string targetFile = projectFolder + @"\Delineation\DelineationRaster_" + model.DelID.ToString() + ".img";
                string targetFile = outputFolder + @"DelineationRaster_" + model.DelID.ToString() + ".img";
                File.Copy(sourceFile, targetFile, true);
                sourceFile = projectFolder + @"\Delineation\temp\DelineationRaster_" + boundaryValue + ".img.aux.xml";
                //targetFile = projectFolder + @"\Delineation\DelineationRaster_" + model.DelID.ToString() + ".img.aux.xml";
                targetFile = outputFolder + @"DelineationRaster_" + model.DelID.ToString() + ".img.aux.xml";
                File.Copy(sourceFile, targetFile, true);

                //Copy polygon layer
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + boundaryValue + ".shp";
                targetFile = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + ".shp";
                File.Copy(sourceFile, targetFile, true);
                _permissiveTractInputShape = targetFile;
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + boundaryValue + ".shx";
                targetFile = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + ".shx";
                File.Copy(sourceFile, targetFile, true);
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + boundaryValue + ".prj";
                targetFile = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + ".prj";
                File.Copy(sourceFile, targetFile, true);
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + boundaryValue + ".dbf";
                targetFile = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + ".dbf";
                File.Copy(sourceFile, targetFile, true);

                //Copy statistics
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + boundaryValue + ".shp_stats.txt";
                delineationSummaryStatistics = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + "_statistics.txt";
                File.Copy(sourceFile, delineationSummaryStatistics, true);

                //Copy cumulative distribution
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + boundaryValue + ".shp_dist.pdf";
                if (File.Exists(sourceFile))
                {
                    delineationCumulativeDistribution = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + "_distribution.pdf";
                    File.Copy(sourceFile, delineationCumulativeDistribution, true);
                }

                //Copy original area as pdf
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + boundaryValue + "_unCleaned_km2.pdf";
                if (File.Exists(sourceFile))
                {
                    targetFile = outputFolder + @"DelineationPolygons_" + boundaryValue + "_unCleaned_km2.pdf";
                    File.Copy(sourceFile, targetFile, true);
                }

                //Show statistics & cumulative distribution
                Process.Start(delineationSummaryStatistics);
                Process.Start(delineationCumulativeDistribution);

                ShowGenTracts = true;
                dialogService.ShowNotification("File copy completed.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("File copy completed in Permissive Tract tool.", "Success");

                showDelineationCleanedTracts(model.DelID);
            }
            catch (Exception ex)
            {
                //   result.Summary = ex.ToString();
                logger.Trace(ex, "File copy failed");
                dialogService.ShowNotification("File copy failed.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("File copy failed in Permissive Tract tool.", "Error");
            }
        }

        private void AcceptSelectedRaster()
        {
            try
            {
                string rasterFile = selectedClassificationRaster.ToString();
                string tmpString = ".pdf";
                int end = rasterFile.IndexOf(tmpString);
                string fName = rasterFile.Substring(0, end);

                isBusy = true;

                string targetFolder = projectFolder + @"\Tracts\" + Model.SelectedTract;
                if (!Directory.Exists(@targetFolder))
                {
                    Directory.CreateDirectory(@targetFolder);
                }

                string sourceFile = fName + ".img";
                string classFile = targetFolder + @"\" + Model.SelectedTract + "_CL" + Model.ClassificationId + ".img";

                bool copyFile = true;
                //Check if target file exists, ask user if replaced or renamed
                if (File.Exists(classFile))
                {
                    copyFile = dialogService.ConfirmationDialog("Tract already has classification with given Classification ID.\nReplace files (Ok), or change Classification ID (Cancel)?");
                }

                if (copyFile)
                {
                    File.Copy(sourceFile, classFile, true);
                    sourceFile = fName + ".img.aux.xml";
                    string targetFile = targetFolder + @"\" + Model.SelectedTract + "_CL" + Model.ClassificationId + ".img.aux.xml";
                    File.Copy(sourceFile, targetFile, true);
                    sourceFile = fName + ".pdf";
                    targetFile = targetFolder + @"\" + Model.SelectedTract + "_CL" + Model.ClassificationId + ".pdf";
                    File.Copy(sourceFile, targetFile, true);
                    Process.Start(targetFile);

                    GenerateClassificationExplanation(classFile);

                    //Copy possible raster explanation
                    string[] files = Directory.GetFiles(Path.GetDirectoryName(Model.DelineationRaster), "*Explanation.txt");
                    if (files.Length > 0)
                    {
                        string outputfolder = Path.Combine(projectFolder, "Tracts", Model.SelectedTract);
                        foreach (string f in files)
                        {
                            string filename = Path.GetFileName(f);
                            if (filename.Contains("Fuzzy"))
                            {
                                File.Copy(f, Path.Combine(outputfolder, "FuzzyCLRasterExplanation.txt"), true);
                            }
                            else if (filename.Contains("WofE"))
                            {
                                File.Copy(f, Path.Combine(outputfolder, "WofECLRasterExplanation.txt "), true);
                            }
                        }
                    }

                    DeleteTempClassificationFolder();

                    dialogService.ShowNotification("Classification done!", "Success");
                    viewModelLocator.SettingsViewModel.WriteLogText("Classification done in Permissive Tract tool.", "Success");
                }
            }
            catch (Exception ex)
            {
                //   result.Summary = ex.ToString();
                logger.Trace(ex, "File copy failed");
                dialogService.ShowNotification("Classification failed.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Classification failed in Permissive Tract tool.", "Error");
            }
            finally
            {
                IsBusy = false;
            }
        }


        private void DeleteTempClassificationFolder()
        {

            DirectoryInfo dir = new DirectoryInfo(Path.Combine(projectFolder, "Classification", "Temp"));

            foreach (FileInfo fi in dir.GetFiles())
            {
                fi.Delete();
            }

            List<string> list = new List<string>();
            model.ClassifiedRasterlist = list;

        }

        private void GenerateClassificationExplanation(string classResFile)
        {
            string outputFile = Path.Combine(projectFolder, "Tracts", Model.SelectedTract) + @"\ClassificationExplanation.txt";


            if (File.Exists(outputFile))
            {
                File.Delete(outputFile);
            }

            using (StreamWriter sw = File.AppendText(outputFile))
            {

                sw.WriteLine("Classification raster:");
                sw.WriteLine(Model.DelineationRaster);
                sw.WriteLine("");

                sw.WriteLine("Raster min and max values:");
                sw.WriteLine(Model.MinMaxValues);
                sw.WriteLine("");

                sw.WriteLine("Number of classes:");
                sw.WriteLine(Model.NumbOfProsClasses);
                sw.WriteLine("");

                sw.WriteLine("Class threshold values:");
                sw.WriteLine(Model.TresholdValues);
                sw.WriteLine("");

                sw.WriteLine("Classification ID:");
                sw.WriteLine(Model.ClassificationId);
                sw.WriteLine("");

                sw.WriteLine("Saved classification:");
                sw.WriteLine(classResFile);

            }
        }

        /// <summary>
        /// Calculate treshold values for raster  
        /// </summary>
        private async void CalculateTreshold()
        {
            logger.Info("-->{0}", this.GetType().Name);

            string pythonPath = settingsService.PythonPath;

            var path = System.AppDomain.CurrentDomain.BaseDirectory;
            var scriptPath = "scripts\\";

            if (!File.Exists(@pythonPath))
            {
                dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Run failed. The python path is not valid.", "Error");
            }

            string method = "calculatetreshold";
            PermissiveTractInputParams inputParams = new PermissiveTractInputParams
            {
                PythonPath = pythonPath,
                ScriptPath = scriptPath,
                EnvPath = model.EnvPath,
                InRasterList = model.InRasterList,
                OutRaster = model.OutRaster,
                MethodId = method,
                FuzzyOverlayType = model.FuzzyOverlayType,
                FuzzyOutputFileName = model.FuzzyOutputFile,
                FuzzyGammaValue = model.FuzzyGammaValue,
                LastFuzzyRound = model.LastFuzzyRound,
                ProspectivityRasterFile = model.ProspectivityRaster,
                BoundaryValues = model.TractBoundaryValues,
                EvidenceLayerFile = model.EvidenceLayerFile,
                DelID = model.DelID,
                MinArea = model.MinArea,
                TractPolygonFile = _permissiveTractInputShape,
                DelineationRaster = model.DelineationRaster,
                NumberOfProspectivityClasses = model.NumbOfProsClasses,
                MaskRaster = model.MaskRaster
            };

            logger.Trace(
                "PermissiveTractInputParams:\n" +
                "\tPythonPath: '{0}'\n" +
                "\tScriptPath: '{1}'\n" +
                "\tEnvPath: '{2}'\n" +
                "\tInRasterList: '{3}'\n" +
                "\tOutRaster: '{4}'\n",
                 inputParams.PythonPath,
                 inputParams.ScriptPath,
                 inputParams.EnvPath,
                 inputParams.InRasterList,
                 inputParams.OutRaster
             );

            PermissiveTractResult permissiveTractResult = default(PermissiveTractResult);
            IsBusy = true;
            try
            {
                await Task.Run(() =>
                {
                    PermissiveTractTool tool = new PermissiveTractTool();
                    logger.Info("calling PermissiveTractTool.Execute(inputParams)");
                    permissiveTractResult = tool.Execute(inputParams) as PermissiveTractResult;
                    Result.ReturnValue = permissiveTractResult.PermissiveTractResults + " " + permissiveTractResult.CalculateWeightsResult + " " + permissiveTractResult.CalculateResponsesResult;
                    model.TresholdValues = permissiveTractResult.TresholdValues;
                    model.MinMaxValues = permissiveTractResult.MinMaxValues;

                });
                dialogService.ShowNotification("Treshold calculation completed successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Treshold calculation completed successfully in Permissive Tract tool.", "Success");
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }

            catch (Exception ex)
            {
                RunStatus = 0;
                logger.Trace(ex, "Run failed");
                dialogService.ShowNotification("Run failed. Check output for details.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Run failed in Permissive Tract tool. Check output for details.", "Error");
            }
            finally
            {
                IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }



        /// <summary>
        /// Generate tracts, minimize polygon areas   
        /// </summary>
        private async void Classificate()
        {
            logger.Info("-->{0}", this.GetType().Name);
            string pythonPath = settingsService.PythonPath;
            var path = System.AppDomain.CurrentDomain.BaseDirectory;
            var scriptPath = "scripts\\";

            if (!File.Exists(@pythonPath))
            {
                dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Run failed. The python path is not valid.", "Error");
            }

            string method = "classification";

            PermissiveTractInputParams inputParams = new PermissiveTractInputParams
            {
                PythonPath = pythonPath,
                ScriptPath = scriptPath,
                EnvPath = model.EnvPath,
                InRasterList = model.InRasterList,
                OutRaster = model.OutRaster,
                MethodId = method,
                FuzzyOverlayType = model.FuzzyOverlayType,
                FuzzyOutputFileName = model.FuzzyOutputFile,
                FuzzyGammaValue = model.FuzzyGammaValue,
                LastFuzzyRound = model.LastFuzzyRound,
                ProspectivityRasterFile = model.ProspectivityRaster,
                BoundaryValues = model.TractBoundaryValues,
                EvidenceLayerFile = model.EvidenceLayerFile,
                DelID = model.DelID,
                MinArea = model.MinArea,
                TractPolygonFile = _permissiveTractInputShape,
                DelineationRaster = model.DelineationRaster,
                NumberOfProspectivityClasses = model.NumbOfProsClasses,
                MinMaxValues = model.MinMaxValues,
                TresholdValues = model.TresholdValues,
                ClassificationId = model.ClassificationId
            };


            PermissiveTractResult permissiveTractResult = default(PermissiveTractResult);
            IsBusy = true;
            try
            {
                await Task.Run(() =>
                {
                    PermissiveTractTool tool = new PermissiveTractTool();
                    logger.Info("calling PermissiveTractTool.Execute(inputParams)");
                    permissiveTractResult = tool.Execute(inputParams) as PermissiveTractResult;
                    Result.ReturnValue = permissiveTractResult.PermissiveTractResults + " " + permissiveTractResult.CalculateWeightsResult + " " + permissiveTractResult.CalculateResponsesResult;
                    //model.TresholdValues = permissiveTractResult.TresholdValues;
                    string[] f = Directory.GetFiles(Path.Combine(projectFolder, "Classification", "Temp"), "ClassificationRaster*.pdf");
                    List<string> list = new List<string>(f);
                    model.ClassifiedRasterlist = list;
                    //ShowButton = true;
                });
                ShowClassRasters = true;
                dialogService.ShowNotification("Classification completed successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Classification completed successfully in Permissive Tract tool.", "Success");
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }

            catch (Exception ex)
            {
                logger.Trace(ex, "Run failed");
                dialogService.ShowNotification("Run failed. Check output for details", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Run failed in Permissive Tract tool. Check output for details.", "Error");
                RunStatus = 0;
            }
            finally
            {
                IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Generate tracts, minimize polygon areas   
        /// </summary>
        private async void GenerateTracts()
        {
            logger.Info("-->{0}", this.GetType().Name);

            if (Model.MinArea == null || Model.MinArea == "")
            {
                dialogService.ShowNotification("Area cannot be null!", "Error");
                return;
            }

            string pythonPath = settingsService.PythonPath;
            var path = System.AppDomain.CurrentDomain.BaseDirectory;
            var scriptPath = "scripts\\";

            if (!File.Exists(@pythonPath))
            {
                dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Run failed. The python path is not valid.", "Error");
            }
            string method = "generatetracts";
            PermissiveTractInputParams inputParams = new PermissiveTractInputParams
            {
                PythonPath = pythonPath,
                ScriptPath = scriptPath,
                EnvPath = model.EnvPath,
                InRasterList = model.InRasterList,
                OutRaster = model.OutRaster,
                MethodId = method,
                FuzzyOverlayType = model.FuzzyOverlayType,
                FuzzyOutputFileName = model.FuzzyOutputFile,
                FuzzyGammaValue = model.FuzzyGammaValue,
                LastFuzzyRound = model.LastFuzzyRound,
                ProspectivityRasterFile = model.ProspectivityRaster,
                BoundaryValues = model.TractBoundaryValues,
                EvidenceLayerFile = model.EvidenceLayerFile,
                DelID = model.DelID,
                MinArea = model.MinArea,
                TractPolygonFile = _permissiveTractInputShape
            };


            PermissiveTractResult permissiveTractResult = default(PermissiveTractResult);
            IsBusy = true;
            try
            {
                await Task.Run(() =>
                {
                    PermissiveTractTool tool = new PermissiveTractTool();
                    logger.Info("calling PermissiveTractTool.Execute(inputParams)");
                    permissiveTractResult = tool.Execute(inputParams) as PermissiveTractResult;
                    logger.Trace("PermissiveTractResult:\n" +
                  "\tReturnValue: '{0}'\n",
                  permissiveTractResult.PermissiveTractResults,
                  permissiveTractResult.CalculateResponsesResult,
                  permissiveTractResult.CalculateWeightsResult
                );
                    // 3. Publish results
                    logger.Trace("Publishing results");
                    Result.ReturnValue = permissiveTractResult.PermissiveTractResults + " " + permissiveTractResult.CalculateWeightsResult + " " + permissiveTractResult.CalculateResponsesResult;
                    //List<string> f = new List<string>(new string[] { "element1", "element2", "element3" });

                    if (inputParams.MethodId == "delineation")
                    {
                        string[] f = Directory.GetFiles(projectFolder + @"Temp", "BoundariesOnEvidence*");
                        List<string> list = new List<string>(f);
                        model.TractBoundaryRasterlist = list;
                        ShowButton = true;
                    }
                    else if (inputParams.MethodId == "generatetracts")
                    {
                        showDelineationCleanedTracts(inputParams.DelID);
                        /*model.DelineationCleanFilelist = null;

                        string[] f = Directory.GetFiles(Path.Combine(projectFolder, "Delineation", "temp", inputParams.DelID),
                            "DelineationPolygons_*km2.pdf");
                        List<string> list = new List<string>(f);
                        model.DelineationCleanFilelist = list;

                        ShowSaveTract = true;*/

                    }

                });
                dialogService.ShowNotification("Tracts generated successfully", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Tracts generated successfully in Permissive Tract tool.", "Success");
                //ToolTipColor = "LimeGreen";
                //ToolTipSymbol = "";
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }

            catch (Exception ex)
            {
                logger.Trace(ex, "Run failed");
                dialogService.ShowNotification("Run failed. Check output for details", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Run failed in Permissive Tract tool. Check output for details", "Error");
                //ToolTipColor = "Red";
                //ToolTipSymbol = "";
                RunStatus = 0;
            }
            finally
            {
                IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        private void showDelineationCleanedTracts(string id)
        {
            model.DelineationCleanFilelist = null;

            string[] f = Directory.GetFiles(Path.Combine(projectFolder, "Delineation", "temp", id),
                "DelineationPolygons_*km2.pdf");
            List<string> list = new List<string>(f);
            model.DelineationCleanFilelist = list;

            ShowSaveTract = true;

        }


        private void GenerateDelineationExplanation(string area)
        {
            string outputFile = Path.Combine(projectFolder, "Tracts", "TR" + Model.DelID) + @"\DelineationExplanation.txt";


            if (File.Exists(outputFile))
            {
                File.Delete(outputFile);
            }

            using (StreamWriter sw = File.AppendText(outputFile))
            {

                sw.WriteLine("Delineation raster:");
                sw.WriteLine(Model.ProspectivityRaster);
                sw.WriteLine("");

                sw.WriteLine("Tract boundary values:");
                sw.WriteLine(Model.TractBoundaryValues);
                sw.WriteLine("");

                sw.WriteLine("Tract ID:");
                sw.WriteLine(Model.DelID);
                sw.WriteLine("");

                sw.WriteLine("Evidence raster file:");
                sw.WriteLine(Model.EvidenceLayerFile);
                sw.WriteLine("");

                sw.WriteLine("Selected tract boundary value:");
                sw.WriteLine(boundaryValue);
                sw.WriteLine("");

                sw.WriteLine("Minimum polygon area for tract cleaning (km2):");
                sw.WriteLine(area);
                sw.WriteLine("");

                sw.WriteLine("Saved tract:");
                sw.WriteLine("/TractDelineation/Tracts/TR" + Model.DelID + "/");



            }
        }


        /// <summary>
        /// Run the tool, Wofe -process with user input.
        /// </summary>
        private async void RunWofeProcess()
        {
            logger.Info("-->{0}", this.GetType().Name);

            string[] wt = Model.WofEWeightsType.Split(',');
            if (model.EvidenceRasterlist.Count == wt.Length)
            {

                string pythonPath = settingsService.PythonPath;// "C:\\Program Files\\ArcGIS\\Pro\\bin\\Python\\envs\\arcgispro-py3\\pythonw.exe";

                var path = System.AppDomain.CurrentDomain.BaseDirectory;
                var scriptPath = "scripts\\";

                if (!File.Exists(@pythonPath))
                {
                    dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
                }

                string method = "wofe";

                if (wofeFromClassification)
                {
                    method = "wofeClassification";
                }

                PermissiveTractInputParams inputParams = new PermissiveTractInputParams
                {
                    PythonPath = pythonPath,
                    ScriptPath = scriptPath,
                    EnvPath = model.EnvPath,
                    InRasterList = model.InRasterList,
                    OutRaster = model.OutRaster,
                    MethodId = method,
                    FuzzyOverlayType = model.FuzzyOverlayType,
                    FuzzyOutputFileName = model.FuzzyOutputFile,
                    FuzzyGammaValue = model.FuzzyGammaValue,
                    LastFuzzyRound = model.LastFuzzyRound,
                    ProspectivityRasterFile = model.ProspectivityRaster,
                    BoundaryValues = model.TractBoundaryValues,
                    EvidenceLayerFile = model.EvidenceLayerFile,
                    DelID = model.DelID,
                    EvidenceRasterList = model.EvidenceRasterlist,
                    UnitArea = model.UnitArea,
                    MaskRaster = model.MaskRaster,
                    WorkSpace = model.WorkSpace,
                    WofEWeightsType = model.WofEWeightsType,
                    TrainingPoints = model.TrainingPoints,
                    ArcSdm = model.Arcsdm,
                    ConfidenceLevel = model.ConfidenceLevel

                };

                logger.Trace(
                     "PermissiveTractInputParams:\n" +
                     "\tPythonPath: '{0}'\n" +
                     "\tScriptPath: '{1}'\n" +
                     "\tEnvPath: '{2}'\n" +
                     "\tInRasterList: '{3}'\n" +
                     "\tOutRaster: '{4}'\n",
                     inputParams.PythonPath,
                     inputParams.ScriptPath,
                     inputParams.EnvPath,
                     inputParams.InRasterList,
                     inputParams.OutRaster
                 );

                PermissiveTractResult permissiveTractResult = default(PermissiveTractResult);
                IsBusy = true;
                try
                {
                    await Task.Run(() =>
                    {
                        PermissiveTractTool tool = new PermissiveTractTool();
                        logger.Info("calling PermissiveTractTool.Execute(inputParams)");
                        permissiveTractResult = tool.Execute(inputParams) as PermissiveTractResult;
                        logger.Trace("PermissiveTractResult:\n" +
                      "\tReturnValue: '{0}'\n",
                      permissiveTractResult.PermissiveTractResults,
                      permissiveTractResult.CalculateResponsesResult,
                      permissiveTractResult.CalculateWeightsResult
                    );
                        // 3. Publish results
                        logger.Trace("Publishing results");
                        Result.ReturnValue = permissiveTractResult.PermissiveTractResults + " " + permissiveTractResult.CalculateWeightsResult + " " + permissiveTractResult.CalculateResponsesResult;
                        //List<string> f = new List<string>(new string[] { "element1", "element2", "element3" });

                    });
                    if (permissiveTractResult.CalculateWeightsResult != "ERROR")
                    {
                        //Copy final delineation rasters to correct folder 
                        string filePath = Path.Combine(delineationFolder, "WofE", "EvidenceData");
                        string destinationFolder = Path.Combine(finalRasterFolder, model.DelRasterFolderWofe);

                        if (wofeFromClassification)
                        {
                            filePath = Path.Combine(projectFolder, "Classification", "WofE", "EvidenceData");
                            destinationFolder = Path.Combine(projectFolder, "Classification", "ClassificationRasters", model.DelRasterFolderWofe);
                        }

                        if (!Directory.Exists(destinationFolder))
                        {
                            Directory.CreateDirectory(destinationFolder);
                        }

                        //propability raster file
                        string file = @"\W_pprb.img";
                        if (File.Exists(filePath + file) && File.Exists(destinationFolder + @"\" + file)) File.Delete(destinationFolder + @"\" + file);
                        File.Move(filePath + file, destinationFolder + @"\" + file);

                        //Update created raster to classification UI
                        if (wofeFromClassification)
                        {
                            model.DelineationRaster = destinationFolder + file;
                            wofeFromClassification = false;
                        }

                        file = @"\W_pprb.img.xml";
                        if (File.Exists(filePath + file) && File.Exists(destinationFolder + @"\" + file)) File.Delete(destinationFolder + @"\" + file);
                        File.Move(filePath + file, destinationFolder + @"\" + file);
                        file = @"\W_pprb.img.aux.xml";
                        if (File.Exists(filePath + file) && File.Exists(destinationFolder + @"\" + file)) File.Delete(destinationFolder + @"\" + file);
                        File.Move(filePath + file, destinationFolder + @"\" + file);

                        file = @"\W_conf.img";
                        if (File.Exists(filePath + file) && File.Exists(destinationFolder + @"\" + file)) File.Delete(destinationFolder + @"\" + file);
                        File.Move(filePath + file, destinationFolder + @"\" + file);
                        file = @"\W_conf.img.xml";
                        if (File.Exists(filePath + file) && File.Exists(destinationFolder + @"\" + file)) File.Delete(destinationFolder + @"\" + file);
                        File.Move(filePath + file, destinationFolder + @"\" + file);
                        file = @"\W_conf.img.aux.xml";
                        if (File.Exists(filePath + file) && File.Exists(destinationFolder + @"\" + file)) File.Delete(destinationFolder + @"\" + file);
                        File.Move(filePath + file, destinationFolder + @"\" + file);

                        file = @"\W_std.img";
                        if (File.Exists(filePath + file) && File.Exists(destinationFolder + @"\" + file)) File.Delete(destinationFolder + @"\" + file);
                        File.Move(filePath + file, destinationFolder + @"\" + file);
                        file = @"\W_std.img.xml";
                        if (File.Exists(filePath + file) && File.Exists(destinationFolder + @"\" + file)) File.Delete(destinationFolder + @"\" + file);
                        File.Move(filePath + file, destinationFolder + @"\" + file);
                        file = @"\W_std.img.aux.xml";
                        if (File.Exists(filePath + file) && File.Exists(destinationFolder + @"\" + file)) File.Delete(destinationFolder + @"\" + file);
                        File.Move(filePath + file, destinationFolder + @"\" + file);

                        updateWofeRasterExplanation(destinationFolder);

                        dialogService.ShowNotification("WofE completed successfully.", "Success");
                        viewModelLocator.SettingsViewModel.WriteLogText("WofE completed successfully in Permissice Tract tool.", "Success");
                        LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                        RunStatus = 1;

                    }
                    else
                    {
                        dialogService.ShowNotification("WofE Calculate weights failed. Improve dataset!", "Error");
                        viewModelLocator.SettingsViewModel.WriteLogText("WofE Calculate weights failed in Permissive Tract tool. Improve dataset!.", "Error");
                        logger.Trace("Run failed");
                        RunStatus = 0;
                    }

                }

                catch (Exception ex)
                {
                    logger.Trace(ex, "Run failed");
                    dialogService.ShowNotification("Run failed. Check output for details.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Run failed in Permissive Tract tool. Check output for details.", "Error");
                    RunStatus = 0;
                }
                finally
                {
                    IsBusy = false;
                }
            }
            else
            {
                dialogService.ShowNotification("Count mismatch! Evidence rasters count and weight types count does not match, check it!", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Count mismatch! Evidence rasters count and weight types count does not match, check it!.", "Error");
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        private void updateWofeRasterExplanation(string outputfolder)
        {

            if (!Directory.Exists(outputfolder))
            {
                Directory.CreateDirectory(outputfolder);
            }

            string outputFile = outputfolder + @"\WofERasterExplanation.txt";

            if (File.Exists(outputFile))
            {
                File.Delete(outputFile);

            }

            using (StreamWriter sw = File.AppendText(outputFile))
            {
                string rasters = "";

                foreach (string s in Model.EvidenceRasterlist)
                {
                    rasters += rasters == "" ? s : ", " + s;
                }

                sw.WriteLine("Rasters combined:");
                sw.WriteLine(rasters);
                sw.WriteLine("");
                sw.WriteLine("Explanations of rasters:");
                sw.WriteLine(model.ExplanationOfEvidenceRasters);
                sw.WriteLine("");
                sw.WriteLine("Types of weight tables:");
                sw.WriteLine(model.WofEWeightsType);
                sw.WriteLine("");
                sw.WriteLine("Unit area (km2):");
                sw.WriteLine(model.UnitArea);
                sw.WriteLine("");
                sw.WriteLine("Confidence level:");
                sw.WriteLine(model.ConfidenceLevel);
                sw.WriteLine("");
                sw.WriteLine("Mask polygon file:");
                sw.WriteLine(model.MaskRaster);
                sw.WriteLine("");
                sw.WriteLine("Explanation of mask polygon:");
                sw.WriteLine(model.ExplanationOfMaskPolygon);
                sw.WriteLine("");
                sw.WriteLine("Training points file:");
                sw.WriteLine(model.TrainingPoints);
                sw.WriteLine("");
                sw.WriteLine("Explanation of training points:");
                sw.WriteLine(model.ExplanationOfTrainingPoints);
                sw.WriteLine("");
                sw.WriteLine("Folder for saving delineation raster:");
                sw.WriteLine(outputfolder + @"\W_pprb.img");
                sw.WriteLine(outputfolder + @"\W_conf.img");
                sw.WriteLine(outputfolder + @"\W_std.img");

            }

        }

        private async void RunFuzzy()
        {
            try
            {
                logger.Info("-- >{0}", this.GetType().Name);
                updateFuzzyFolder();
                string pythonPath = settingsService.PythonPath;// "C:\\Program Files\\ArcGIS\\Pro\\bin\\Python\\envs\\arcgispro-py3\\pythonw.exe";

                var path = System.AppDomain.CurrentDomain.BaseDirectory;
                var scriptPath = "scripts\\";

                if (!File.Exists(@pythonPath))
                {
                    dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Run failed. The python path is not valid.", "Error");
                }

                string method = "";
                if (fuzzyFromClassification)
                {
                    method = "fuzzyClassification";
                }
                else
                {
                    method = "fuzzy";
                }
                scriptPath += "FuzzyOverlay.pyw";

                PermissiveTractInputParams inputParams = new PermissiveTractInputParams
                {
                    PythonPath = pythonPath,
                    ScriptPath = scriptPath,
                    EnvPath = model.EnvPath,
                    InRasterList = model.InRasterList,
                    OutRaster = model.OutRaster,
                    MethodId = method,
                    FuzzyOverlayType = model.FuzzyOverlayType,
                    FuzzyOutputFileName = model.FuzzyOutputFile,
                    FuzzyGammaValue = model.FuzzyGammaValue,
                    LastFuzzyRound = model.LastFuzzyRound,
                    ProspectivityRasterFile = model.ProspectivityRaster,
                    BoundaryValues = model.TractBoundaryValues,
                    EvidenceLayerFile = model.EvidenceLayerFile,
                    DelID = model.DelID,
                    EvidenceRasterList = model.EvidenceRasterlist,
                    UnitArea = model.UnitArea,
                    MaskRaster = model.MaskRaster,
                    WorkSpace = model.WorkSpace,
                    WofEWeightsType = model.WofEWeightsType,
                    TrainingPoints = model.TrainingPoints
                };

                logger.Trace(
                     "PermissiveTractInputParams:\n" +
                     "\tPythonPath: '{0}'\n" +
                     "\tScriptPath: '{1}'\n" +
                     "\tEnvPath: '{2}'\n" +
                     "\tInRasterList: '{3}'\n" +
                     "\tOutRaster: '{4}'\n",
                     inputParams.PythonPath,
                     inputParams.ScriptPath,
                     inputParams.EnvPath,
                     inputParams.InRasterList,
                     inputParams.OutRaster
                 );

                PermissiveTractResult permissiveTractResult = default(PermissiveTractResult);
                IsBusy = true;

                await Task.Run(() =>
                {
                    PermissiveTractTool tool = new PermissiveTractTool();
                    logger.Info("calling PermissiveTractTool.Execute(inputParams)");
                    permissiveTractResult = tool.Execute(inputParams) as PermissiveTractResult;
                    logger.Trace("PermissiveTractResult:\n" +
                  "\tReturnValue: '{0}'\n",
                  permissiveTractResult.PermissiveTractResults,
                  permissiveTractResult.CalculateResponsesResult,
                  permissiveTractResult.CalculateWeightsResult
                );
                    // 3. Publish results
                    logger.Trace("Publishing results");
                    Result.ReturnValue = permissiveTractResult.PermissiveTractResults + " " + permissiveTractResult.CalculateWeightsResult + " " + permissiveTractResult.CalculateResponsesResult;
                    //List<string> f = new List<string>(new string[] { "element1", "element2", "element3" });

                    if (inputParams.MethodId == "delineation")
                    {
                        string[] f = Directory.GetFiles(Path.Combine(projectFolder, "Delineation", "temp"), "BoundariesOnEvidence*");
                        List<string> list = new List<string>(f);
                        model.TractBoundaryRasterlist = list;
                        ShowButton = true;
                        viewModelLocator.ReportingViewModel.FindTractIDs();
                    }

                });

                updateFuzzyRasterExplanation();
                dialogService.ShowNotification("Fuzzy completed successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Fuzzy completed successfully in Permissive Tract tool.", "Success");
                model.ExplanationOfRasters = "";
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }

            catch (Exception ex)
            {
                logger.Trace(ex, "Run failed");
                dialogService.ShowNotification("Run failed. Check output for details.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Run failed in Permissive Tract tool. Check output for details.", "Error");
                RunStatus = 0;
            }
            finally
            {
                IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }


        /// <summary>
        /// Run the tool with user input.
        /// </summary>
        private async void RunTool()
        {
            try
            {
                logger.Info("-- >{0}", this.GetType().Name);

                string pythonPath = settingsService.PythonPath;// "C:\\Program Files\\ArcGIS\\Pro\\bin\\Python\\envs\\arcgispro-py3\\pythonw.exe";

                var path = System.AppDomain.CurrentDomain.BaseDirectory;
                var scriptPath = "scripts\\";

                if (!File.Exists(@pythonPath))
                {
                    dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
                }

                string method = "";
                method = "delineation";
                scriptPath += "";

                PermissiveTractInputParams inputParams = new PermissiveTractInputParams
                {
                    PythonPath = pythonPath,
                    ScriptPath = scriptPath,
                    EnvPath = model.EnvPath,
                    InRasterList = model.InRasterList,
                    OutRaster = model.OutRaster,
                    MethodId = method,
                    FuzzyOverlayType = model.FuzzyOverlayType,
                    FuzzyOutputFileName = model.FuzzyOutputFile,
                    FuzzyGammaValue = model.FuzzyGammaValue,
                    LastFuzzyRound = model.LastFuzzyRound,
                    ProspectivityRasterFile = model.ProspectivityRaster,
                    BoundaryValues = model.TractBoundaryValues,
                    EvidenceLayerFile = model.EvidenceLayerFile,
                    DelID = model.DelID,
                    EvidenceRasterList = model.EvidenceRasterlist,
                    UnitArea = model.UnitArea,
                    MaskRaster = model.MaskRaster,
                    WorkSpace = model.WorkSpace,
                    WofEWeightsType = model.WofEWeightsType,
                    TrainingPoints = model.TrainingPoints
                };

                logger.Trace(
                     "PermissiveTractInputParams:\n" +
                     "\tPythonPath: '{0}'\n" +
                     "\tScriptPath: '{1}'\n" +
                     "\tEnvPath: '{2}'\n" +
                     "\tInRasterList: '{3}'\n" +
                     "\tOutRaster: '{4}'\n",
                     inputParams.PythonPath,
                     inputParams.ScriptPath,
                     inputParams.EnvPath,
                     inputParams.InRasterList,
                     inputParams.OutRaster
                 );

                PermissiveTractResult permissiveTractResult = default(PermissiveTractResult);
                IsBusy = true;

                await Task.Run(() =>
                {
                    PermissiveTractTool tool = new PermissiveTractTool();
                    logger.Info("calling PermissiveTractTool.Execute(inputParams)");
                    permissiveTractResult = tool.Execute(inputParams) as PermissiveTractResult;
                    logger.Trace("PermissiveTractResult:\n" +
                  "\tReturnValue: '{0}'\n",
                  permissiveTractResult.PermissiveTractResults,
                  permissiveTractResult.CalculateResponsesResult,
                  permissiveTractResult.CalculateWeightsResult
                );
                    // 3. Publish results
                    logger.Trace("Publishing results");
                    Result.ReturnValue = permissiveTractResult.PermissiveTractResults + " " + permissiveTractResult.CalculateWeightsResult + " " + permissiveTractResult.CalculateResponsesResult;
                    //List<string> f = new List<string>(new string[] { "element1", "element2", "element3" });

                    if (inputParams.MethodId == "delineation")
                    {
                        upDateTractBoundaryList();
                        /*string[] f = Directory.GetFiles(Path.Combine(projectFolder, "Delineation", "temp"), "BoundariesOnEvidence*");
                        List<string> list = new List<string>(f);
                        model.TractBoundaryRasterlist = list;
                        ShowButton = true;
                        viewModelLocator.ReportingViewModel.FindTractIDs();*/
                    }

                });

                dialogService.ShowNotification("Delineation completed successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Delineation completed successfully in Permissive Tract tool.", "Success");
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }

            catch (Exception ex)
            {
                logger.Trace(ex, "Run failed");
                dialogService.ShowNotification("Run failed. Check output for details,", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Run failed in Permissive Tract tool. Check output for details,", "Error");
                RunStatus = 0;
            }
            finally
            {
                IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }


        private void upDateTractBoundaryList()
        {
            string boundariesDir = Path.Combine(projectFolder, "Delineation", "temp");

            if (Directory.Exists(boundariesDir))
            {

                //string[] f = Directory.GetFiles(boundariesDir, "BoundariesOnEvidence*");
                string[] f = Directory.GetFiles(boundariesDir, "DelineationRaster_*.pdf");
                if (f.Length > 0)
                {
                    List<string> list = new List<string>(f);
                    model.TractBoundaryRasterlist = list;
                    ShowButton = true;
                }
                else
                {
                    List<string> list = new List<string>();
                    model.TractBoundaryRasterlist = list;
                }

            }
            //updateTractIDsToModels();
        }


        /// <summary>
        /// Update Fuzzy raster explanation file
        /// </summary>
        private void updateFuzzyRasterExplanation()
        {
            string outputFile = evidenceDataFolder + @"\FuzzyRasterExplanation.txt";
            string round = "0";
            if (File.Exists(outputFile))
            {
                string[] lines = File.ReadAllLines(outputFile);

                for (int index = 0; index < lines.Length; index++)
                {
                    if (lines[index].Contains("Round ") && lines[index].StartsWith("Round ") && lines[index].Length < 9)
                    {
                        round = lines[index].Substring(5);
                    }
                }


            }

            int r = Convert.ToInt32(round) + 1;

            using (StreamWriter sw = File.AppendText(outputFile))
            {
                round = (model.LastFuzzyRound == "True") ? "Final round" : "Round " + r.ToString();
                sw.WriteLine(round);
                sw.WriteLine("");
                string rasters = "";
                foreach (string s in Model.InRasterList)
                {
                    rasters += rasters == "" ? s : ", " + s;
                }
                sw.WriteLine("Rasters combined:");
                sw.WriteLine(rasters);
                sw.WriteLine("");
                sw.WriteLine("Explanations of rasters:");
                sw.WriteLine(model.ExplanationOfRasters);
                sw.WriteLine("");
                sw.WriteLine("Fuzzy overlay type:");
                sw.WriteLine(model.FuzzyOverlayType);
                if (model.FuzzyGammaValue != null && model.FuzzyOverlayType == "GAMMA")
                {
                    sw.WriteLine("");
                    sw.WriteLine("Gamma value: ");
                    sw.WriteLine(model.FuzzyGammaValue);
                }
                sw.WriteLine("");
                sw.WriteLine("Output file:");
                sw.WriteLine(evidenceDataFolder + @"\" + model.FuzzyOutputFile + ".img");
                sw.WriteLine("");
            }

            if (model.LastFuzzyRound == "True")
            {
                if (!Directory.Exists(finalRasterFolder + @"\" + model.DelRasterFolder))
                {
                    Directory.CreateDirectory(finalRasterFolder + @"\" + model.DelRasterFolder);
                }

                if (File.Exists(outputFile))
                {

                    string destExplanation = finalRasterFolder + @"\" + model.DelRasterFolder + @"\" + Path.GetFileName(outputFile);

                    if (File.Exists(destExplanation))
                    {
                        File.Delete(destExplanation);
                    }


                    File.Move(outputFile, destExplanation);
                }

                string sourceFile = evidenceDataFolder + @"\" + model.FuzzyOutputFile + ".img";
                string destFile = finalRasterFolder + @"\" + model.DelRasterFolder + @"\" + model.FuzzyOutputFile + ".img";

                if (File.Exists(sourceFile))
                {
                    if (File.Exists(destFile))
                    {
                        File.Delete(destFile);
                    }
                    File.Move(sourceFile, destFile);
                }

                if (fuzzyFromClassification && model.LastFuzzyRound == "True")
                {
                    model.DelineationRaster = destFile;
                    fuzzyFromClassification = false;
                }
            }

        }
        /// <summary>
        /// Updates folder for fuzzy outputfiles, depending if classification or delineation process is used
        /// </summary>
        private void updateFuzzyFolder()
        {
            if (fuzzyFromClassification)
            {
                evidenceDataFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Classification", "Fuzzy", "EvidenceData");
                delineationFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Classification");
                finalRasterFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Classification", "ClassificationRasters");

                if (!Directory.Exists(@evidenceDataFolder))
                {
                    Directory.CreateDirectory(@evidenceDataFolder);
                }

                if (!Directory.Exists(@delineationFolder))
                {
                    Directory.CreateDirectory(@delineationFolder);
                }

                if (!Directory.Exists(@finalRasterFolder))
                {
                    Directory.CreateDirectory(@finalRasterFolder);
                }

            }
            else
            {
                evidenceDataFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Delineation", "Fuzzy", "EvidenceData");
                delineationFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Delineation");
                finalRasterFolder = Path.Combine(settingsService.RootPath, "TractDelineation", "Delineation", "DelineationRasters");

                if (!Directory.Exists(@evidenceDataFolder))
                {
                    Directory.CreateDirectory(@evidenceDataFolder);
                }

                if (!Directory.Exists(@delineationFolder))
                {
                    Directory.CreateDirectory(@delineationFolder);
                }

                if (!Directory.Exists(@finalRasterFolder))
                {
                    Directory.CreateDirectory(@finalRasterFolder);
                }
            }
        }

        /// <summary>
        /// Select files from filesystem.
        /// </summary>
        private void SelectFiles()
        {
            try
            {
                updateFuzzyFolder();
                List<string> files = dialogService.OpenFilesDialog("", "All files (*.*)|*.*", true, true, settingsService.RootPath);

                if (!string.IsNullOrEmpty(files.ToString()))
                {
                    // model.InRasterList = files;
                    foreach (string f in files)
                    {
                        string filename = Path.GetFileName(f);
                        File.Copy(f, evidenceDataFolder + @"\" + filename, true);
                    }

                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFilesDialog");
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Select files from filesystem.
        /// </summary>
        private void SelectRasters()
        {

            try
            {
                updateFuzzyFolder();
                List<string> files = dialogService.OpenFilesDialog(evidenceDataFolder, "All files (*.*)|*.*", true, true, settingsService.RootPath);

                if (!string.IsNullOrEmpty(files.ToString()))
                {
                    model.InRasterList = files;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Select files for prospectivity raster from filesystem.
        /// </summary>
        private void SelectPRFile()
        {
            try
            {
                string prfile = dialogService.OpenFileDialog(delineationFolder, "All files (*.*)|*.*", true, true, settingsService.RootPath);

                if (!string.IsNullOrEmpty(prfile.ToString()))
                {
                    model.ProspectivityRaster = prfile;

                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Select file for delineation raster from filesystem.
        /// </summary>
        private void SelectDRFile()
        {
            try
            {
                string drfile = dialogService.OpenFileDialog(projectFolder + @"\Delineation", "Raster files (*.img)|*.img", true, true, settingsService.RootPath);

                if (!string.IsNullOrEmpty(drfile.ToString()))
                {
                    string destFolder = Path.Combine(projectFolder, "Classification", "ClassificationRasters");
                    if (!Directory.Exists(destFolder))
                    {
                        Directory.CreateDirectory(destFolder);
                    }

                    string destFile = Path.Combine(destFolder, Path.GetFileName(drfile));
                    File.Copy(drfile, destFile, true);

                    model.DelineationRaster = destFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Select file for training points
        /// </summary>
        private void SelectTPFile()
        {
            try
            {
                string tpfile = dialogService.OpenFileDialog(fileFolder, "Shape file (*.shp)|*.shp", true, true, settingsService.RootPath);

                if (!string.IsNullOrEmpty(tpfile.ToString()))
                {
                    model.TrainingPoints = tpfile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Select file for mask
        /// </summary>
        private void SelectMaskFile()
        {
            try
            {
                string maskfile = dialogService.OpenFileDialog(fileFolder, "Shape file (*.shp)|*.shp", true, true, settingsService.RootPath);

                if (!string.IsNullOrEmpty(maskfile.ToString()))
                {
                    model.MaskRaster = maskfile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Select file for track polygon
        /// </summary>
        private void PathToTractPolygon()
        {
            try
            {
                string polygonFile = dialogService.OpenFileDialog(fileFolder, "Shape file (*.shp)|*.shp", true, true, settingsService.RootPath);

                if (!string.IsNullOrEmpty(polygonFile.ToString()))
                {
                    model.PathToTractPolygon = polygonFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
            finally
            {
            }
        }


        private void ClassificationFuzzy()
        {
            fuzzyFromClassification = true;
        }

        private void DelineationFuzzy()
        {
            fuzzyFromClassification = false;
        }

        private void ClassificationWofe()
        {
            wofeFromClassification = true;
        }

        private void DelineationWofe()
        {
            wofeFromClassification = false;
        }

        /// <summary>
        /// Select evidence files from filesystem.
        /// </summary>
        private void SelectEvidenceFiles()
        {
            try
            {

                List<string> files = dialogService.OpenFilesDialog(evidenceDataFolder, "All files (*.*)|*.*", true, true, settingsService.RootPath);

                /* if (!string.IsNullOrEmpty(files.ToString()))
                 {
                     model.EvidenceRasterlist = files;
                     fileFolder = Path.GetDirectoryName(files[0]);
                 }*/

                //List<string> files = dialogService.OpenFilesDialog(evidenceDataFolder, "All files (*.*)|*.*", true, true, settingsService.RootPath);
                List<string> evidencefiles = new List<string>();

                if (!string.IsNullOrEmpty(files.ToString()))
                {
                    fileFolder = Path.GetDirectoryName(files[0]);

                    string filePath = "";
                    if (wofeFromClassification)
                    {
                        filePath = Path.Combine(classificationFolder, "WofE", "EvidenceData");
                    }
                    else
                    {
                        filePath = Path.Combine(delineationFolder, "WofE", "EvidenceData");
                    }




                    if (!Directory.Exists(filePath))
                    {
                        Directory.CreateDirectory(filePath);
                    }

                    foreach (string file in files)
                    {
                        FileInfo mFile = new FileInfo(file);
                        string targetFile = Path.Combine(filePath, mFile.Name);
                        File.Copy(file, targetFile, true);
                        evidencefiles.Add(targetFile);

                        string tmpFile = file + ".aux.xml";
                        targetFile = Path.Combine(filePath, mFile.Name + ".aux.xml");
                        if (File.Exists(tmpFile))
                        {
                            File.Copy(tmpFile, targetFile, true);
                        }

                        tmpFile = file + ".vat.cpg";
                        targetFile = Path.Combine(filePath, mFile.Name + ".vat.cpg");
                        if (File.Exists(tmpFile))
                        {
                            File.Copy(tmpFile, targetFile, true);
                        }

                        tmpFile = file + ".vat.dbf";
                        targetFile = Path.Combine(filePath, mFile.Name + ".vat.dbf");
                        if (File.Exists(tmpFile))
                        {
                            File.Copy(tmpFile, targetFile, true);
                        }

                        tmpFile = Path.Combine(mFile.DirectoryName, Path.GetFileNameWithoutExtension(file) + ".rrd");
                        targetFile = Path.Combine(filePath, Path.GetFileNameWithoutExtension(file) + ".rrd");
                        if (File.Exists(tmpFile))
                        {
                            File.Copy(tmpFile, targetFile, true);
                        }
                    }
                    model.EvidenceRasterlist = evidencefiles;
                }

            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFilesDialog");
                dialogService.ShowNotification("Failed to select input files.", "Error");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Select evidence layer file for Delineation process
        /// </summary>
        private void SelectEvidenceLayerFile()
        {
            try
            {
                string f = dialogService.OpenFileDialog("", "All files (*.*)|*.*", true, true, settingsService.RootPath);

                if (!string.IsNullOrEmpty(f.ToString()))
                {
                    model.EvidenceLayerFile = f;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
            finally
            {
            }
        }


        /// <summary>
        /// Select folder from filesystem.
        /// </summary>
        private void SelectFolder()
        {
            try
            {
                using (var fbd = new FolderBrowserDialog())
                {
                    DialogResult result = fbd.ShowDialog();

                    if (result == DialogResult.OK && !string.IsNullOrWhiteSpace(fbd.SelectedPath))
                    {
                        model.EnvPath = fbd.SelectedPath;
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show FolderBrowserDialog");
                dialogService.ShowNotification("Failed to select input folder.", "Error");
            }
            finally
            {
            }
        }
        /// <summary>
        /// Save file to filesystem.
        /// </summary>
        private void SaveFile()
        {
            try
            {
                Microsoft.Win32.SaveFileDialog dlg = new Microsoft.Win32.SaveFileDialog();
                dlg.FileName = "";
                //dlg.DefaultExt = ".txt";
                dlg.Filter = "All files (*.*)|*.*";

                Nullable<bool> result = dlg.ShowDialog();

                if (result == true)
                {
                    model.OutRaster = dlg.FileName;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show SaveDileDialog");
                dialogService.ShowNotification("Failed to save file.", "Error");
            }
            finally
            {
            }
        }
        /// <summary>
        /// Save tract polygon to filesystem.
        /// </summary>
        private void SaveTract()
        {
            try
            {
                string tractFolder = Path.Combine(projectFolder, "Tracts", "TR" + model.IdOfTract);

                if (!Directory.Exists(tractFolder))
                {
                    Directory.CreateDirectory(tractFolder);
                }

                //Copy tract polygonfile to destination
                string filename = Path.GetFileName(model.PathToTractPolygon);
                File.Copy(model.PathToTractPolygon, tractFolder + @"\" + "TR" + model.IdOfTract + ".shp", true);

                string path = tractFolder + "/TractExplanation.txt";
                File.WriteAllText(path, model.ExplanationOfTract);

                updateTractIDsToModels();
                dialogService.ShowNotification("Tract saved!", "Success");

            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to copy tract polygon.");
                dialogService.ShowNotification("Failed to save tract.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to save tract in Permissive Tract tool.", "Error");
            }
            finally
            {
            }
        }
        /// <summary>
        /// Save final tract files to filesystem.
        /// </summary>
        private void SaveFinalTract()
        {
            string cleanFile = DelineationCleanFile;
            if (cleanFile == null || cleanFile == "")
            {
                dialogService.ShowNotification("You must select cleaned polygon!", "Error");
                return;
            }
            try
            {
                int start = cleanFile.LastIndexOf("_");
                int end = cleanFile.LastIndexOf("km2");
                string area = cleanFile.Substring(start + 1, end - start - 1);

                string tractFolder = Path.Combine(projectFolder, "Tracts", "TR" + Model.DelID);

                if (!Directory.Exists(tractFolder))
                {
                    Directory.CreateDirectory(tractFolder);
                }

                string sourceFolder = Path.Combine(projectFolder, "Delineation", "temp", Model.DelID);

                //Copy delineation raster
                FileInfo mF = new FileInfo(sourceFolder + @"\DelineationRaster_" + Model.DelID + ".img");
                mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".img", true);
                mF = new FileInfo(sourceFolder + @"\DelineationRaster_" + Model.DelID + ".img.aux.xml");
                mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".img.aux.xml", true);

                //Copy delineation polygon
                if (area != "")
                {
                    mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + "_" + area + "km2.shp");
                    mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".shp", true);
                    mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + "_" + area + "km2.shx");
                    mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".shx", true);
                    mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + "_" + area + "km2.prj");
                    mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".prj", true);
                    mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + "_" + area + "km2.dbf");
                    mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".dbf", true);
                    mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + "_" + area + "km2.pdf");
                    mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".pdf", true);
                }
                else
                {
                    mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + ".shp");
                    mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".shp", true);
                    mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + ".shx");
                    mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".shx", true);
                    mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + ".prj");
                    mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".prj", true);
                    mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + ".dbf");
                    mF.CopyTo(tractFolder + "\\TR" + Model.DelID + ".dbf", true);
                }

                //other files
                mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + "_distribution.pdf");
                mF.CopyTo(tractFolder + @"\DelineationPolygons_" + Model.DelID + "_distribution.pdf", true);
                mF = new FileInfo(sourceFolder + @"\DelineationPolygons_" + Model.DelID + "_statistics.txt");
                mF.CopyTo(tractFolder + @"\DelineationPolygons_" + Model.DelID + "_statistics.txt", true);
                mF = new FileInfo(sourceFolder + @"\DelineationSummary" + Model.DelID + ".txt");
                mF.CopyTo(tractFolder + @"\DelineationSummary" + Model.DelID + ".txt", true);
                mF = new FileInfo(sourceFolder + @"\TractAreaCdf" + Model.DelID + ".pdf");
                mF.CopyTo(tractFolder + @"\TractAreaCdf" + Model.DelID + ".pdf", true);

                //Copy delineation raster info file
                int li = Model.ProspectivityRaster.LastIndexOf("\\");
                string prosRasFolder = Model.ProspectivityRaster.Substring(0, li);
                //Copy tract files to destination
                List<String> rasterFiles = Directory
                   .GetFiles(prosRasFolder, "*Explanation.txt", SearchOption.TopDirectoryOnly).ToList();
                foreach (string file in rasterFiles)
                {
                    FileInfo mFile = new FileInfo(file);
                    mFile.CopyTo(tractFolder + "\\" + mFile.Name, true);
                }

                //Delete other temp files
                /*List<String> tmpFiles = Directory
                  .GetFiles(sourceFolder, "*.*", SearchOption.TopDirectoryOnly).ToList();
                foreach (string file in tmpFiles)
                {
                    FileInfo mFile = new FileInfo(file);
                    mFile.Delete();
                }*/

                Directory.Delete(sourceFolder, true);


                GenerateDelineationExplanation(area);

                updateTractIDsToModels();
                dialogService.ShowNotification("Tract saved!", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Tract saved in Permissive Tract tool.", "Success");
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to copy tract files.");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to copy tract files in Permissive Tract tool.", "Error");
                return;
            }
            finally
            {
            }
        }

        private void updateTractIDsToModels()
        {
            FindTractIDs();
            viewModelLocator.EconomicFilterViewModel.FindTractIDs();
            viewModelLocator.DepositDensityViewModel.FindTractIDs();
            viewModelLocator.UndiscoveredDepositsViewModel.FindTractIDs();
            viewModelLocator.MonteCarloSimulationViewModel.FindTractIDs();
            viewModelLocator.ReportingViewModel.FindTractIDs();
            viewModelLocator.ReportingAssesmentViewModel.FindTractIDs();
        }

        /// <summary>
        /// Show PermissiveTract results folder.
        /// </summary>
        public void ShowResults()
        {



            try
            {
                Process.Start(Path.Combine(projectFolder, "Tracts"));
                /*if (tabIndex == 0)
                {
                    try
                    {
                        Process.Start(projectFolder + "\\ProspRaster");
                    }
                    catch (Exception ex)
                    {
                        logger.Trace(ex + "Failed to show OutRaster:");
                    }
                }
                else if (tabIndex == 1)
                {
                    try
                    {
                        Process.Start(projectFolder + "\\Delineation");
                    }
                    catch (Exception ex)
                    {
                        logger.Trace(ex + "Failed to show Project Raster");
                    }

                }
                else if (tabIndex == 2)
                {
                    try
                    {
                        Process.Start(projectFolder + "\\Classification");
                    }
                    catch (Exception ex)
                    {
                        logger.Trace(ex + "Failed to show Project Raster");
                    }

                }*/
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to open results folder.");
                dialogService.ShowNotification("Failed to open results folder.", "Error");
            }
        }

        /// <summary>
        /// Show Boudary images folder.
        /// </summary>
        public void ShowBoundaries()
        {
            try
            {
                Process.Start(projectFolder + @"\Temp");
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to open results folder.");
                dialogService.ShowNotification("Failed to open boundaries folder.", "Error");
            }
        }

        /// <summary>
        /// Check if tool can be executed. (Is not busy.)
        /// </summary>
        /// <returns>Boolean indicating if the tool can be executed.</returns>
        private bool CanRunTool()
        {
            return !IsBusy;
        }

        public string LastRunDate
        {
            get { return lastRunDate; }
            set
            {
                if (value == lastRunDate) return;
                lastRunDate = value;
                OnPropertyChanged();
            }
        }

        public int RunStatus
        {
            get { return runStatus; }
            set
            {
                if (value == runStatus) return;
                runStatus = value;
                OnPropertyChanged();
            }
        }

        public int TabIndex
        {
            get { return tabIndex; }
            set
            {
                if (value == tabIndex) return;
                tabIndex = value;
                OnPropertyChanged();
            }
        }

        public string SelectedBoundary
        {
            get { return selectedBoundary; }
            set
            {
                if (value == selectedBoundary) return;
                selectedBoundary = value;
                OnPropertyChanged();
            }
        }

        public string DelineationCleanFile
        {
            get { return delineationCleanFile; }
            set
            {
                if (value == delineationCleanFile) return;
                delineationCleanFile = value;
                OnPropertyChanged();
            }
        }

        public string SelectedClassificationRaster
        {
            get { return selectedClassificationRaster; }
            set
            {
                if (value == selectedClassificationRaster) return;
                selectedClassificationRaster = value;
                OnPropertyChanged();
            }
        }

        protected virtual void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null) handler(this, new PropertyChangedEventArgs(propertyName));
        }

        private void DeleteBoundaries()
        {
            if (dialogService.ConfirmationDialog("Delete all boundary files?"))
            {
                deleteBoundaryList();
            }
            else
            {  }
        }

        private void deleteBoundaryList()
        {
            string boundariesDir = Path.Combine(projectFolder, "Delineation", "temp");

            if (Directory.Exists(boundariesDir))
            {

                //string[] f = Directory.GetFiles(boundariesDir, "BoundariesOnEvidence*");
                string[] files = Directory.GetFiles(boundariesDir, "*.*");

                if (files.Length > 0)
                {

                    foreach (string filePath in files)
                        File.Delete(filePath);
                    ShowButton = false;

                    upDateTractBoundaryList();
                }
            }
            updateTractIDsToModels();
        }
    }
}

