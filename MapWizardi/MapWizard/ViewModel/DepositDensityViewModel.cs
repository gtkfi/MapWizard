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
        private bool isBusy;
        private string lastRunDate;
        private int runStatus;

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
            lastRunDate = "Last Run: Never";
            runStatus = 2;
            result = new DepositDensityResultModel();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            SelectFileCommand = new RelayCommand(SelectFile, CanRunTool);
            DepositDensityInputParams inputParams = new DepositDensityInputParams();
            string outputFolder = Path.Combine(settingsService.RootPath, "DensModel");
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
                    model = new DepositDensityModel
                    {
                        CSVPath = inputParams.CSVPath,
                        MedianTonnage = Convert.ToDouble(inputParams.MedianTonnage),
                        AreaOfPermissiveTract = Convert.ToDouble(inputParams.AreaOfTrack),
                        NumbOfKnownDeposits = Convert.ToInt32(inputParams.NumbOfKnownDeposits),
                        ExistingDepositDensityModelID = inputParams.ExistingDepositDensityModelID
                    };
                }
                catch (Exception ex)
                {                    
                    model = new DepositDensityModel
                    {
                        CSVPath = "Choose *.csv file",
                        MedianTonnage = 0,
                        AreaOfPermissiveTract = 0,
                        NumbOfKnownDeposits = 0
                    };
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Deposit Density tool's inputs correctly.", "Error");
                }
            }
            else
            {
                model = new DepositDensityModel
                {
                    CSVPath = "Choose *.csv file",
                    MedianTonnage = 0,
                    AreaOfPermissiveTract = 0,
                    NumbOfKnownDeposits = 0
                };
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
        /// Select file command.
        /// @return Command.
        /// </summary>
        public RelayCommand SelectFileCommand { get; }

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
                CSVPath = Model.CSVPath
            };
            // 2. Execute tool.
            DepositDensityResult ddResult = default(DepositDensityResult);
            IsBusy = true;

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
                dialogService.ShowNotification("DepositDensityTool completed successfully", "Success");
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to execute REngine() script");
                dialogService.ShowNotification("Run failed. Check output for details", "Error");
                RunStatus = 0;
            }
            finally
            {
                IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectFile()
        {
            try
            {
                string csvFile = dialogService.OpenFileDialog("", "CSV files|*.csv;", true, true);
                if (!string.IsNullOrEmpty(csvFile))
                {
                    model.CSVPath = csvFile;
                    model.CSVPath = csvFile.Replace("\\", "/");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
        }

        /// <summary>
        /// Is busy?
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
                SelectFileCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Check if tool can be executed.
        /// </summary>
        /// @return Boolean representing the state.
        private bool CanRunTool()
        {
            return !IsBusy;
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
            }
        }
    }
}
