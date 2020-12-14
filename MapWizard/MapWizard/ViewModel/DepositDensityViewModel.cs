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
using System.ComponentModel;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Diagnostics;
using System.Windows;

namespace MapWizard.ViewModel
{

    /// <summary>
    /// This class contains properties that the DepositDensityView can data bind to.
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
    public class DepositDensityViewModel : ViewModelBase, INotifyPropertyChanged
    {
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private DepositDensityModel model;
        private DepositDensityResultModel result;
        private ViewModelLocator viewModelLocator;

        /// <summary>
        /// Initialize new instance of DepositDensityViewModel class.
        /// </summary>
        /// <param name="logger">Logging for the MapWizard.</param>
        /// <param name="dialogService">Service for using dialogs and notifications.</param>
        /// <param name="settingsService">Service for using and editing settings.</param>
        public DepositDensityViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            result = new DepositDensityResultModel();
            viewModelLocator = new ViewModelLocator();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            OpenDepositDenPlotCommand = new RelayCommand(OpenDepositDenPlotFile, CanRunTool);
            TractChangedDeposit = new RelayCommand(TractChanged, CanRunTool);
            DepositDensityInputParams inputParams = new DepositDensityInputParams();
            string outputFolder = Path.Combine(settingsService.RootPath, "UndiscDep");
            if (!Directory.Exists(outputFolder))
            {
                Directory.CreateDirectory(outputFolder);
            }
            string param_json = Path.Combine(outputFolder, "deposit_density_input_params.json");
            if (File.Exists(param_json))
            {
                try
                {
                    inputParams.Load(param_json);
                    Model = new DepositDensityModel
                    {
                        N10 = inputParams.N10,
                        N50 = inputParams.N50,
                        N90 = inputParams.N90,
                        Note = inputParams.Note,
                        CSVPath = inputParams.CSVPath,
                        MedianTonnage = Convert.ToDouble(inputParams.MedianTonnage),
                        AreaOfPermissiveTract = Convert.ToDouble(inputParams.AreaOfTrack),
                        NumbOfKnownDeposits = Convert.ToInt32(inputParams.NumbOfKnownDeposits),
                        ExistingDepositDensityModelID = inputParams.ExistingDepositDensityModelID,
                        SelectedTract = inputParams.TractId
                    };
                    FindTractIDs();
                    if (Directory.GetFiles(outputFolder).Length != 0)
                    {
                        LoadResults();
                    }
                }
                catch (Exception ex)
                {
                    Model = new DepositDensityModel();
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Deposit Density tool's inputs correctly. Inputs were initialized to default values.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Deposit Density tool's inputs correctly. Inputs were initialized to default values.", "Error");
                }
            }
            else
            {
                Model = new DepositDensityModel();
                FindTractIDs();
            }
        }

        /// <summary>
        /// Model collection.
        /// </summary>
        /// @return ID collection.
        public ObservableCollection<string> ModelIds { get; } = new ObservableCollection<string>() { "General", "PorCu", "VMS", "PodiformCr" };

        /// <summary>
        /// Run tool command.
        /// </summary>
        /// @return Command.
        public RelayCommand RunToolCommand { get; }

        /// <summary>
        /// Open Deposit Density plot command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenDepositDenPlotCommand { get; }

        /// <summary>
        /// Tract changed.
        /// </summary>
        /// @return Command.
        public RelayCommand TractChangedDeposit { get; }

        /// <summary>
        /// Deposit Density model.
        /// </summary>
        /// @return Model.
        public DepositDensityModel Model
        {
            get
            {
                return model;
            }
            set
            {
                model = value;
                RaisePropertyChanged("DepositDensityModel");
            }
        }

        /// <summary>
        /// Deposit Density result model.
        /// </summary>
        /// @return Result model.
        public DepositDensityResultModel Result
        {
            get
            {
                return result;
            }
            set
            {
                result = value;
                RaisePropertyChanged("DepositDensityResultModel");
            }
        }

        private void TractChanged()
        {
            viewModelLocator.UndiscoveredDepositsViewModel.Model.SelectedTract = Model.SelectedTract;
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
        /// Run tool with user input.
        /// </summary>
        private async void RunTool()
        {
            logger.Info("-->{0}", this.GetType().Name);
            // 1. Collect input parameters.
            DepositDensityInputParams input = new DepositDensityInputParams
            {
                DepositTypeId = "xxx",
                MedianTonnage = Model.MedianTonnage.ToString(),
                AreaOfTrack = Model.AreaOfPermissiveTract.ToString(),
                NumbOfKnownDeposits = Model.NumbOfKnownDeposits.ToString(),
                ExistingDepositDensityModelID = Model.ExistingDepositDensityModelID,
                CSVPath = Model.CSVPath,
                TractId = Model.SelectedTract
            };
            // 2. Execute tool.
            DepositDensityResult ddResult = default(DepositDensityResult);
            Model.IsBusy = true;

            try
            {

                await Task.Run(() =>
                {
                    DepositDensityTool tool = new DepositDensityTool();
                    ddResult = tool.Execute(input) as DepositDensityResult;
                    Result.N10 = ddResult.N10;
                    Result.N50 = ddResult.N50;
                    Result.N90 = ddResult.N90;
                    Result.PlotImagePath = ddResult.PlotImagePath;
                    Result.PlotImageBitMap = BitmapFromUri(ddResult.PlotImagePath);
                    Result.Model = Model.ExistingDepositDensityModelID;
                    if (Model.ExistingDepositDensityModelID == "General")
                    {
                        Result.MTonnage = Model.MedianTonnage.ToString();
                    }
                    else
                    {
                        Result.MTonnage = "-";
                    }
                    Result.TArea = Model.AreaOfPermissiveTract.ToString();
                    Result.NKnown = Model.NumbOfKnownDeposits.ToString();
                    Result.Note = ddResult.Note;
                });
                input.N10 = Result.N10;
                input.N50 = Result.N50;
                input.N90 = Result.N90;
                input.Note = Result.Note;
                string outputFolder = Path.Combine(settingsService.RootPath, "UndiscDep");
                input.Save(Path.Combine(outputFolder, "deposit_density_input_params.json"));
                dialogService.ShowNotification("DepositDensityTool completed successfully.", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("DepositDensityTool completed successfully.", "Success");
                Model.LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                Model.RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to execute REngine() script");
                dialogService.ShowNotification("Run failed. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Run failed in Deposit Density Tool. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                Model.RunStatus = 0;
            }
            finally
            {
                Model.IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Load results of the last run.
        /// </summary>
        private void LoadResults()
        {
            try
            {
                Result.N10 = Model.N10;
                Result.N50 = Model.N50;
                Result.N90 = Model.N90;
                Result.MTonnage = Model.MedianTonnage.ToString();
                Result.Model = Model.ExistingDepositDensityModelID;
                Result.TArea = Model.AreaOfPermissiveTract.ToString();
                Result.NKnown = Model.NumbOfKnownDeposits.ToString();
                Result.Note = Model.Note;

                string plotDirectory = Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "scripts", "DepositDensity");
                if (Model.ExistingDepositDensityModelID == "General")
                {
                    Result.PlotImagePath = Path.Combine(plotDirectory, "GeneralPlot.jpeg");
                    Result.PlotImageBitMap = BitmapFromUri(Path.Combine(plotDirectory, "GeneralPlot.jpeg"));
                }
                else if (Model.ExistingDepositDensityModelID == "PorCu")
                {
                    Result.PlotImagePath = Path.Combine(plotDirectory, "porphyryPlot.jpeg");
                    Result.PlotImageBitMap = BitmapFromUri(Path.Combine(plotDirectory, "porphyryPlot.jpeg"));
                }
                else if (Model.ExistingDepositDensityModelID == "VMS")
                {
                    Result.PlotImagePath = Path.Combine(plotDirectory, "VMSplot.jpeg");
                    Result.PlotImageBitMap = BitmapFromUri(Path.Combine(plotDirectory, "VMSplot.jpeg"));
                }
                else if (Model.ExistingDepositDensityModelID == "PodiformCr")
                {
                    Result.PlotImagePath = Path.Combine(plotDirectory, "Podiformplot.jpeg");
                    Result.PlotImageBitMap = BitmapFromUri(Path.Combine(plotDirectory, "Podiformplot.jpeg"));
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to execute REngine() script");
                dialogService.ShowNotification("Error when loading Deposit Density results.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Error when loading Deposit Density results.", "Error");
            }
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
        /// Open plot image.
        /// </summary>
        public void OpenDepositDenPlotFile()
        {
            try
            {
                bool openFile = dialogService.MessageBoxDialog();
                if (openFile == true)
                {
                    if (File.Exists(Result.PlotImagePath))
                    {
                        Process.Start(Result.PlotImagePath);
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
        /// Check if tool can be executed.
        /// </summary>
        /// @return Boolean representing the state.
        private bool CanRunTool()
        {
            return !Model.IsBusy;
        }
    }
}
