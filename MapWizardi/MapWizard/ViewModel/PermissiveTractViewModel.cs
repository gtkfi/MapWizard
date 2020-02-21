using System;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using MapWizard.Model;
using MapWizard.Tools;
using NLog;
using MapWizard.Service;
using MapWizard.Tools.Settings;
using System.Windows.Forms;
using System.Collections.Generic;
using System.IO;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.ComponentModel;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;

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
        private readonly ISettingsService settings;
        private readonly IDialogService dialogService;
        ViewModelLocator viewModelLocator;
        private PermissiveTractModel model;
        private PermissiveTractResultModel result;
        private bool isBusy;
        public event PropertyChangedEventHandler PropertyChanged;
        private string lastRunDate;
        private int runStatus; //0= error, 1=success, 2=not run yet
        private int tabIndex;
        private string projectFolder;//"c:\\temp\\mapWizard\\PermissiveTract\\";
        private string prospRastersFolder;// = "c:\\temp\\mapWizard\\PermissiveTract\\prospRasters\\";
        private string evidenceDataFolder;
        private string fileFolder;
        private string selectedBoundary = "";
        private string selectedClassificationRaster = "";

        private bool _showAcceptButton;
        private bool _showGenTracts;
        private bool _showClassRasters;

        private string delineationSummaryStatistics = "";
        private string delineationCumulativeDistribution = "";

        private string _permissiveTractInputShape;

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
        public PermissiveTractViewModel(ILogger logger, IDialogService dialogService, ISettingsService settings)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settings = settings;
            lastRunDate = "Last Run: Never";
            runStatus = 2;

            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            RunWofeCommand = new RelayCommand(RunWofeProcess, CanRunTool);
            GenerateTractsCommand = new RelayCommand(GenerateTracts, CanRunTool);
            CalculateTresholdCommand = new RelayCommand(CalculateTreshold, CanRunTool);
            ClassificationCommand = new RelayCommand(Classificate, CanRunTool);
            SelectFilesCommand = new RelayCommand(SelectFiles, CanRunTool);
            SelectRastersCommand = new RelayCommand(SelectRasters, CanRunTool);
            SelectFolderCommand = new RelayCommand(SelectFolder, CanRunTool);
            SaveFileCommand = new RelayCommand(SaveFile, CanRunTool);
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

            viewModelLocator = new ViewModelLocator();
            result = new PermissiveTractResultModel();

            PermissiveTractInputParams inputParams = new PermissiveTractInputParams();

            //folders:
            string PermissiveTractProject = settings.Data.RootFolderPath + @"\TractDelineation\";
            projectFolder = Path.Combine(settings.RootPath, "TractDelineation");
            evidenceDataFolder = Path.Combine(settings.RootPath, "TractDelineation", "ProspRaster", "Fuzzy", "EvidenceData");
            prospRastersFolder = Path.Combine(settings.RootPath, "TractDelineation", "ProspRaster");

            if (!Directory.Exists(@PermissiveTractProject))
            {
                Directory.CreateDirectory(@PermissiveTractProject);
            }

            if (!Directory.Exists(@prospRastersFolder))
            {
                Directory.CreateDirectory(@prospRastersFolder);
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
                        PythonPath = inputParams.PythonPath,
                        ScriptPath = inputParams.ScriptPath,
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
                }
                catch (Exception ex)
                {
                    model = new PermissiveTractModel
                    {
                        PythonPath = inputParams.PythonPath,
                        ScriptPath = inputParams.ScriptPath,
                        EnvPath = @PermissiveTractProject,
                        InRasterList = { },
                        OutRaster = @PermissiveTractProject,
                        MethodId = "fuzzy",
                        TractBoundaryRasterlist = null
                    };
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Permissive Tract tool's inputs correctly.", "Error");
                }
            }
            else
            {
                model = new PermissiveTractModel
                {
                    PythonPath = inputParams.PythonPath,
                    ScriptPath = inputParams.ScriptPath,
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
        }
        /// <summary>
        /// Run tool command.
        /// </summary>
        public RelayCommand RunToolCommand { get; }
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


        public ObservableCollection<string> WofEWeightTypeIDs { get; } = new ObservableCollection<string>() { "Descending", "Ascending", "Categorial", "Unique" };

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



        private void AcceptSelectedBoundary()
        {
            try
            {
                string boundaryFile = selectedBoundary.ToString();
                string tmpString = "BoundariesOnEvidence_";
                int start = boundaryFile.IndexOf(tmpString);
                start += tmpString.Length;
                tmpString = ".pdf";
                int end = boundaryFile.IndexOf(tmpString);
                string limit = boundaryFile.Substring(start, end - start);
                string outputFolder = projectFolder + @"\Delineation\" + model.DelID.ToString() + @"\";

                if (!Directory.Exists(@outputFolder))
                {
                    Directory.CreateDirectory(@outputFolder);
                }


                //Copy Delineation raster
                string sourceFile = projectFolder + @"\Delineation\temp\DelineationRaster_" + limit + ".img";
                //string targetFile = projectFolder + @"\Delineation\DelineationRaster_" + model.DelID.ToString() + ".img";
                string targetFile = outputFolder + @"DelineationRaster_" + model.DelID.ToString() + ".img";
                File.Copy(sourceFile, targetFile, true);
                sourceFile = projectFolder + @"\Delineation\temp\DelineationRaster_" + limit + ".img.aux.xml";
                //targetFile = projectFolder + @"\Delineation\DelineationRaster_" + model.DelID.ToString() + ".img.aux.xml";
                targetFile = outputFolder + @"DelineationRaster_" + model.DelID.ToString() + ".img.aux.xml";
                File.Copy(sourceFile, targetFile, true);

                //Copy polygon layer
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + limit + ".shp";
                targetFile = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + ".shp";
                File.Copy(sourceFile, targetFile, true);
                _permissiveTractInputShape = targetFile;
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + limit + ".shx";
                targetFile = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + ".shx";
                File.Copy(sourceFile, targetFile, true);
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + limit + ".prj";
                targetFile = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + ".prj";
                File.Copy(sourceFile, targetFile, true);
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + limit + ".dbf";
                targetFile = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + ".dbf";
                File.Copy(sourceFile, targetFile, true);

                //Copy statistics
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + limit + ".shp_stats.txt";
                delineationSummaryStatistics = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + "_statistics.txt";
                File.Copy(sourceFile, delineationSummaryStatistics, true);

                //Copy cumulative distribution
                sourceFile = projectFolder + @"\Delineation\temp\DelineationPolygons_" + limit + ".shp_dist.pdf";
                delineationCumulativeDistribution = outputFolder + @"DelineationPolygons_" + model.DelID.ToString() + "_distribution.pdf";
                File.Copy(sourceFile, delineationCumulativeDistribution, true);

                //Show statistics & cumulative distribution
                Process.Start(delineationSummaryStatistics);
                Process.Start(delineationCumulativeDistribution);

                ShowGenTracts = true;
                dialogService.ShowNotification("File copy completed.", "Success");
            }
            catch (Exception ex)
            {
                //   result.Summary = ex.ToString();
                dialogService.ShowNotification("File copy failed.", "Error");
                logger.Trace(ex, "File copy failed");
            }
        }

        private void AcceptSelectedRaster()
        {
            try
            {
                string rasterFile = selectedClassificationRaster.ToString();
                string tmpString = "ProspectivityRaster";
                int start = rasterFile.IndexOf(tmpString);
                start += tmpString.Length;
                tmpString = ".img";
                int end = rasterFile.IndexOf(tmpString);
                string limit = rasterFile.Substring(start, end - start);
                isBusy = true;

                string targetFolder = projectFolder + @"\Classification\" + model.DelID;
                if (!Directory.Exists(@targetFolder))
                {
                    Directory.CreateDirectory(@targetFolder);
                }
                //Copy Classification raster
                string sourceFile = projectFolder + @"\Classification\Temp\ProspectivityRaster" + limit + ".img";
                string targetFile = targetFolder + @"\ProspectivityRaster" + limit + ".img";
                File.Copy(sourceFile, targetFile, true);
                sourceFile = projectFolder + @"\Classification\Temp\ProspectivityRaster" + limit + ".img.aux.xml";
                targetFile = targetFolder + @"\ProspectivityRaster" + limit + ".img.aux.xml";
                File.Copy(sourceFile, targetFile, true);
                sourceFile = projectFolder + @"\Classification\Temp\ProspectivityRaster" + limit + ".pdf";
                targetFile = targetFolder + @"\ProspectivityRaster" + limit + ".pdf";
                File.Copy(sourceFile, targetFile, true);
                Process.Start(targetFile);
                dialogService.ShowNotification("File copy completed.", "Success");
            }
            catch (Exception ex)
            {
                //   result.Summary = ex.ToString();
                dialogService.ShowNotification("File copy failed.", "Error");
                logger.Trace(ex, "File copy failed");
            }
            finally
            {
                IsBusy = false;
            }
        }

        /// <summary>
        /// Calculate treshold values for raster  
        /// </summary>
        private async void CalculateTreshold()
        {
            logger.Info("-->{0}", this.GetType().Name);

            string pythonPath = settings.PythonPath;

            var path = System.AppDomain.CurrentDomain.BaseDirectory;
            var scriptPath = "scripts\\";

            if (!File.Exists(@pythonPath))
            {
                dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
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
                NumberOfProspectivityClasses = model.NumbOfProsClasses
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
                dialogService.ShowNotification("Treshold calculation completed successfully", "Success");
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }

            catch (Exception ex)
            {
                dialogService.ShowNotification("Run failed. Check output for details", "Error");
                logger.Trace(ex, "Run failed");
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
        private async void Classificate()
        {
            logger.Info("-->{0}", this.GetType().Name);
            string pythonPath = settings.PythonPath;
            var path = System.AppDomain.CurrentDomain.BaseDirectory;
            var scriptPath = "scripts\\";

            if (!File.Exists(@pythonPath))
            {
                dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
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
                    string[] f = Directory.GetFiles(Path.Combine(projectFolder, "Classification", "Temp"), "ProspectivityRaster*.img");
                    List<string> list = new List<string>(f);
                    model.ClassifiedRasterlist = list;
                    //ShowButton = true;
                });
                ShowClassRasters = true;
                dialogService.ShowNotification("Classification completed successfully", "Success");
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }

            catch (Exception ex)
            {
                dialogService.ShowNotification("Run failed. Check output for details", "Error");
                logger.Trace(ex, "Run failed");
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

            string pythonPath = settings.PythonPath;
            var path = System.AppDomain.CurrentDomain.BaseDirectory;
            var scriptPath = "scripts\\";

            if (!File.Exists(@pythonPath))
            {
                dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
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

                });
                dialogService.ShowNotification("Tracts generated successfully", "Success");
                //ToolTipColor = "LimeGreen";
                //ToolTipSymbol = "";
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }

            catch (Exception ex)
            {
                dialogService.ShowNotification("Run failed. Check output for details", "Error");
                logger.Trace(ex, "Run failed");
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

        /// <summary>
        /// Run the tool, Wofe -process with user input.
        /// </summary>
        private async void RunWofeProcess()
        {
            logger.Info("-->{0}", this.GetType().Name);


            string[] wt = Model.WofEWeightsType.Split(',');
            if (model.EvidenceRasterlist.Count == wt.Length)
            {

                string pythonPath = settings.PythonPath;// "C:\\Program Files\\ArcGIS\\Pro\\bin\\Python\\envs\\arcgispro-py3\\pythonw.exe";

                var path = System.AppDomain.CurrentDomain.BaseDirectory;
                var scriptPath = "scripts\\";

                if (!File.Exists(@pythonPath))
                {
                    dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
                }

                string method = "wofe";

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
                        //Copy final prospectivityraster to prospRastersFolder 
                        string filePath = Path.Combine(projectFolder, "ProspRaster", "WofE", "EvidenceData");
                        string file = @"\W_pprb.img";
                        File.Copy(filePath + file, prospRastersFolder + @"\" + file, true);
                        file = @"\W_pprb.img.xml";
                        File.Copy(filePath + file, prospRastersFolder + @"\" + file, true);
                        file = @"\W_pprb.img.aux.xml";
                        File.Copy(filePath + file, prospRastersFolder + @"\" + file, true);

                        dialogService.ShowNotification("WofE completed successfully", "Success");
                        LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                        RunStatus = 1;
                    }
                    else
                    {
                        dialogService.ShowNotification("WofE Calculate weights failed. Improve dataset!", "Error");
                        logger.Trace("Run failed");
                        RunStatus = 0;
                    }


                }

                catch (Exception ex)
                {
                    dialogService.ShowNotification("Run failed. Check output for details", "Error");
                    logger.Trace(ex, "Run failed");
                    RunStatus = 0;
                }
                finally
                {
                    IsBusy = false;
                }
            }
            else
            {
                MessageBox.Show("Evidence rasters count and weight types count does not match, check it!", "Count mismatch!");
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
                logger.Info("-->{0}", this.GetType().Name);

                string pythonPath = settings.PythonPath;// "C:\\Program Files\\ArcGIS\\Pro\\bin\\Python\\envs\\arcgispro-py3\\pythonw.exe";

                var path = System.AppDomain.CurrentDomain.BaseDirectory;
                var scriptPath = "scripts\\";

                if (!File.Exists(@pythonPath))
                {
                    dialogService.ShowNotification("Run failed. The python path is not valid.", "Error");
                }

                string method = "";

                if (tabIndex == 0)
                {
                    method = "fuzzy";
                    scriptPath += "FuzzyOverlay.pyw";
                }
                else
                {
                    method = "delineation";
                    scriptPath += "";
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
                if (tabIndex == 0)
                {
                    dialogService.ShowNotification("Fuzzy completed successfully", "Success");
                }
                else
                {
                    dialogService.ShowNotification("Delineation completed successfully", "Success");
                }

                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }

            catch (Exception ex)
            {
                dialogService.ShowNotification("Run failed. Check output for details", "Error");
                logger.Trace(ex, "Run failed");
                RunStatus = 0;
            }
            finally
            {
                IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Select files from filesystem.
        /// </summary>
        private void SelectFiles()
        {
            try
            {
                List<string> files = dialogService.OpenFilesDialog("", "All files (*.*)|*.*", true, true);

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
                List<string> files = dialogService.OpenFilesDialog(evidenceDataFolder, "All files (*.*)|*.*", true, true);

                if (!string.IsNullOrEmpty(files.ToString()))
                {
                    model.InRasterList = files;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show SelectRastersDialog");
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
                string prfile = dialogService.OpenFileDialog(prospRastersFolder, "All files (*.*)|*.*", true, true);

                if (!string.IsNullOrEmpty(prfile.ToString()))
                {
                    model.ProspectivityRaster = prfile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show SelectRastersDialog");
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
                string drfile = dialogService.OpenFileDialog(projectFolder + @"\Delineation", "Raster files (*.img)|*.img", true, true);

                if (!string.IsNullOrEmpty(drfile.ToString()))
                {
                    model.DelineationRaster = drfile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show SelectRasterDialog");
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
                string tpfile = dialogService.OpenFileDialog(fileFolder, "Shape file (*.shp)|*.shp", true, true);

                if (!string.IsNullOrEmpty(tpfile.ToString()))
                {
                    model.TrainingPoints = tpfile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show Select file Dialog");
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
                string maskfile = dialogService.OpenFileDialog(fileFolder, "Shape file (*.shp)|*.shp", true, true);

                if (!string.IsNullOrEmpty(maskfile.ToString()))
                {
                    model.MaskRaster = maskfile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show Select file Dialog");
            }
            finally
            {
            }
        }

        /// <summary>
        /// Select evedence files from filesystem.
        /// </summary>
        private void SelectEvidenceFiles()
        {
            try
            {
                List<string> files = dialogService.OpenFilesDialog(evidenceDataFolder, "All files (*.*)|*.*", true, true);

                if (!string.IsNullOrEmpty(files.ToString()))
                {
                    model.EvidenceRasterlist = files;
                    fileFolder = Path.GetDirectoryName(files[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFilesDialog");
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
                string f = dialogService.OpenFileDialog("", "All files (*.*)|*.*", true, true);

                if (!string.IsNullOrEmpty(f.ToString()))
                {
                    model.EvidenceLayerFile = f;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFilesDialog");
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
                logger.Error(ex, "Failed to show OpenFileDialog");
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
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
            finally
            {
            }
        }
        /// <summary>
        /// Show PermissiveTract results folder.
        /// </summary>
        public void ShowResults()
        {

            try
            {
                if (tabIndex == 0)
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

                }
            }
            catch (Exception ex)
            {
                dialogService.ShowNotification("Failed to open results folder.", "Error");
                logger.Error(ex, "Failed to open results folder.");
            }
        }

        /// <summary>
        /// Show Boudary images folder.
        /// </summary>
        public void ShowBoundaries()
        {
            MessageBox.Show(selectedBoundary);
            try
            {
                Process.Start(projectFolder + @"\Temp");
            }
            catch (Exception ex)
            {
                dialogService.ShowNotification("Failed to open boundaries folder.", "Error");
                logger.Error(ex, "Failed to open results folder.");
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
    }
}

