using System;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using MapWizard.Model;
using NLog;
using MapWizard.Tools.Settings;
using MapWizard.Service;
using System.IO;
namespace MapWizard.ViewModel
{
    /// <summary>
    /// Class for handling tool and program settings.
    /// </summary>
    public class SettingsViewModel : ViewModelBase
    {
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private ViewModelLocator viewModelLocator;
        private SettingsModel model;

        /// <summary>
        /// Initialize new instance of SettingsViewModel.
        /// </summary>
        /// <param name="logger">Logging for the MapWizard.</param>
        /// <param name="dialogService">Service for using dialogs and notifications.</param>
        /// <param name="settingsService">Service for using and editing settings.</param>
        public SettingsViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            SelectPythonFileCommand = new RelayCommand(SelectPythonFile);
            SelectRFileCommand = new RelayCommand(SelectRFile);
            SelectDepModFolderCommand = new RelayCommand(SelectDepModFolder);
            SaveSettingsCommand = new RelayCommand(SaveToJson);
            viewModelLocator = new ViewModelLocator();
            // Load the data from settings.json file.
            model = new SettingsModel
            {
                PythonEXEPath = settingsService.Data.PythonEXEPath,
                REXEPath = settingsService.Data.REXEPath,
                DepModFolderPath = settingsService.Data.DepModFolderPath,
                REXEPathDefault = settingsService.Data.REXEPathDefault,
                PyEXEPathDefault = settingsService.Data.PyEXEPathDefault,
                DepModFolderPathDefault = settingsService.Data.DepModFolderPathDefault,
                DefaultPythonLocation = settingsService.Data.DefaultPythonLocation,
                CustomPythonLocation = settingsService.Data.CustomPythonLocation,
                PyButtonVisibility = settingsService.Data.PyButtonVisibility,
                DefaultRLocation = settingsService.Data.DefaultRLocation,
                CustomRLocation = settingsService.Data.CustomRLocation,
                RButtonVisibility = settingsService.Data.RButtonVisibility,
                DefaultDepModLocation = settingsService.Data.DefaultDepModLocation,
                CustomDepModLocation = settingsService.Data.CustomDepModLocation,
                DepModButtonVisibility = settingsService.Data.DepModButtonVisibility,
                ProjectName = "-"
            };
            DepositTypeVisibility = "Collapsed";
        }

        /// <summary>
        /// Select Python file command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectPythonFileCommand { get; }

        /// <summary>
        /// Select R file command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectRFileCommand { get; }

        /// <summary>
        /// Select Deposit Models folder command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectDepModFolderCommand { get; }
        /// <summary>
        /// Save settings command.
        /// </summary>
        /// @return Command.
        public RelayCommand SaveSettingsCommand { get; }

        /// <summary>
        ///Model for SettingsModel.
        /// </summary>
        /// @return Model.
        public SettingsModel Model
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
        /// Custom Python Path.
        /// </summary>
        /// @return Path.
        public string CustomPythonPath
        {
            get
            {
                return model.PythonEXEPath;
            }
            set
            {
                if (model.PythonEXEPath == value) return;
                model.PythonEXEPath = value.ToString();
                RaisePropertyChanged("CustomPythonPath");
            }
        }

        /// <summary>
        /// Custom R Path.
        /// </summary>
        /// @return Path.
        public string CustomRPath
        {
            get
            {
                return model.REXEPath;
            }
            set
            {
                if (model.REXEPath == value) return;
                model.REXEPath = value.ToString();
                RaisePropertyChanged("CustomRPath");
            }
        }

        /// <summary>
        ///Custom Root Path.
        /// </summary>
        /// @return Path.
        public string ProjectRootPath
        {
            get
            {
                return model.RootFolderPath;
            }
            set
            {
                if (model.RootFolderPath == value) return;
                model.RootFolderPath = value.ToString();
                RaisePropertyChanged("CustomRootPath");
            }
        }

        /// <summary>
        ///Custom Deposit Models Path.
        /// </summary>
        /// @return Path.
        public string CustomDepModPath
        {
            get
            {
                return model.DepModFolderPath;
            }
            set
            {
                if (model.DepModFolderPath == value) return;
                model.DepModFolderPath = value.ToString();
                RaisePropertyChanged("CustomDepModPath");
            }
        }

        /// <summary>
        /// When default for Python is checked.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool PyDefaultIsChecked
        {
            get
            {
                return bool.Parse(model.DefaultPythonLocation);
            }
            set
            {
                if (bool.Parse(model.DefaultPythonLocation) == value) return;
                model.DefaultPythonLocation = value.ToString();
                RaisePropertyChanged("PyDefaultIsChecked");
                PyButtonVisibility = true;
            }
        }

        /// <summary>
        /// When custom for Python is checked.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool PyCustomIsChecked
        {
            get
            {
                return bool.Parse(model.CustomPythonLocation);
            }
            set
            {
                if (bool.Parse(model.CustomPythonLocation) == value) return;
                model.CustomPythonLocation = value.ToString();
                RaisePropertyChanged("PyCustomIsChecked");
                PyButtonVisibility = false;
            }
        }

        /// <summary>
        /// Changes button visibility.
        /// </summary>
        /// @return Boolean representing the change.
        public bool PyButtonVisibility
        {
            get { return bool.Parse(model.PyButtonVisibility); }

            set
            {
                model.PyButtonVisibility = value.ToString();
                RaisePropertyChanged("PyButtonVisibility");
            }
        }

        /// <summary>
        /// When default for R is checked.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool RDefaultIsChecked
        {
            get
            {
                return bool.Parse(model.DefaultRLocation);
            }
            set
            {
                if (bool.Parse(model.DefaultRLocation) == value) return;
                model.DefaultRLocation = value.ToString();
                RaisePropertyChanged("RDefaultIsChecked");
                RButtonVisibility = true;
            }
        }

        /// <summary>
        /// When custom for R is checked.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool RCustomIsChecked
        {
            get
            {
                return bool.Parse(model.CustomRLocation);
            }
            set
            {
                if (bool.Parse(model.CustomRLocation) == value) return;
                model.CustomRLocation = value.ToString();
                RaisePropertyChanged("RCustomIsChecked");
                RButtonVisibility = false;
            }
        }

        /// <summary>
        /// Changes button visibility.
        /// </summary>
        /// @return Boolean representing the change.
        public bool RButtonVisibility
        {
            get { return bool.Parse(model.RButtonVisibility); }

            set
            {
                model.RButtonVisibility = value.ToString();
                RaisePropertyChanged("RButtonVisibility");
            }
        }

        /// <summary>
        /// When default for Deposit Models is checked.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool DepModDefaultIsChecked
        {
            get
            {
                return bool.Parse(model.DefaultDepModLocation);
            }
            set
            {
                if (bool.Parse(model.DefaultDepModLocation) == value) return;
                model.DefaultDepModLocation = value.ToString();
                RaisePropertyChanged("DepModDefaultIsChecked");
                DepModButtonVisibility = true;
            }
        }

        /// <summary>
        /// When custom for Deposit Models is checked.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool DepModCustomIsChecked
        {
            get
            {
                return bool.Parse(model.CustomDepModLocation);
            }
            set
            {
                if (bool.Parse(model.CustomDepModLocation) == value) return;
                model.CustomDepModLocation = value.ToString();
                RaisePropertyChanged("DepModCustomIsChecked");
                DepModButtonVisibility = false;
            }
        }

        /// <summary>
        /// Changes button visibility.
        /// </summary>
        /// @return Boolean representing the change.
        public bool DepModButtonVisibility
        {
            get { return bool.Parse(model.DepModButtonVisibility); }

            set
            {
                model.DepModButtonVisibility = value.ToString();
                RaisePropertyChanged("DepModButtonVisibility");
            }
        }

        /// <summary>
        /// Deposit Type visibility.
        /// </summary>
        /// @return Object representing the visibility.
        public object DepositTypeVisibility
        {
            get { return model.DepositTypeVisibility; }

            set
            {
                model.DepositTypeVisibility = value;
                RaisePropertyChanged("DepositTypeVisibility");
            }
        }

        /// <summary>
        /// Name of the current project.
        /// </summary>
        /// @return Project name.
        public string ProjectName
        {
            get { return model.ProjectName; }

            set
            {
                model.ProjectName = value;
                RaisePropertyChanged("ProjectName");
            }
        }

        /// <summary>
        /// Deposit Type name.
        /// </summary>
        /// @return Deposit Type name.
        public string DepositType
        {
            get { return model.DepositType; }

            set
            {
                model.DepositType = value;
                RaisePropertyChanged("DepositType");
            }
        }

        /// <summary>
        ///Update settings when project is opened in MainViewModel.
        /// </summary>
        public void UpdateSettings(string depositType)
        {
            CustomPythonPath = settingsService.Data.PythonEXEPath;
            CustomRPath = settingsService.Data.REXEPath;
            CustomDepModPath = settingsService.Data.DepModFolderPath;
            PyDefaultIsChecked = bool.Parse(settingsService.Data.DefaultPythonLocation);
            PyCustomIsChecked = bool.Parse(settingsService.Data.CustomPythonLocation);
            PyButtonVisibility = bool.Parse(settingsService.Data.PyButtonVisibility);
            RDefaultIsChecked = bool.Parse(settingsService.Data.DefaultRLocation);
            RCustomIsChecked = bool.Parse(settingsService.Data.CustomRLocation);
            RButtonVisibility = bool.Parse(settingsService.Data.RButtonVisibility);
            DepModDefaultIsChecked = bool.Parse(settingsService.Data.DefaultDepModLocation);
            DepModCustomIsChecked = bool.Parse(settingsService.Data.CustomDepModLocation);
            DepModButtonVisibility = bool.Parse(settingsService.Data.DepModButtonVisibility);
            DepositTypeVisibility = "Visible";
            ProjectName = Path.GetFileName(settingsService.Data.RootFolderPath);
            DepositType = depositType;
        }

        /// <summary>
        /// Save information to json file.
        /// </summary>
        public void SaveToJson()
        {
            string rootDirectory = settingsService.Data.RootFolderPath; 
            string MAPWfile = "";
            try
            {
                if (Directory.Exists(rootDirectory))
                {
                    MAPWfile = Path.Combine(rootDirectory, Path.GetFileName(rootDirectory) + ".MAPW");
                    if ((Path.GetFileName(rootDirectory) == ProjectName) && (DepositTypeVisibility.ToString() == "Visible"))
                    {
                        settingsService.Data = new SettingsDataModel()
                        {
                            RootFolderPath = Path.GetDirectoryName(MAPWfile),
                            DepositType = Model.DepositType
                        };
                        settingsService.SaveSettings(MAPWfile);  // Save DepositType aand rootFolder into model's own MAPW file.
                    }
                }
                settingsService.Data = new SettingsDataModel()
                {
                    PythonEXEPath = model.PythonEXEPath,
                    REXEPath = model.REXEPath,
                    DepModFolderPath = model.DepModFolderPath,
                    REXEPathDefault = model.REXEPathDefault,
                    PyEXEPathDefault = model.PyEXEPathDefault,
                    DepModFolderPathDefault = model.DepModFolderPathDefault,
                    DefaultPythonLocation = model.DefaultPythonLocation,
                    CustomPythonLocation = model.CustomPythonLocation,
                    PyButtonVisibility = model.PyButtonVisibility,
                    DefaultRLocation = model.DefaultRLocation,
                    CustomRLocation = model.CustomRLocation,
                    RButtonVisibility = model.RButtonVisibility,
                    DefaultDepModLocation = model.DefaultDepModLocation,
                    CustomDepModLocation = model.CustomDepModLocation,
                    DepModButtonVisibility = model.DepModButtonVisibility,
                };
                string SettingsDirectory = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), "MapWizard");
                if (!Directory.Exists(SettingsDirectory))
                {
                    Directory.CreateDirectory(SettingsDirectory);
                }
                string json_file = Path.Combine(SettingsDirectory, "settings.json");
                if (File.Exists(MAPWfile) && viewModelLocator.ReportingViewModel != null)
                {
                    settingsService.Data.RootFolderPath = Path.GetDirectoryName(MAPWfile);
                    settingsService.Data.DepositType = Model.DepositType;
                    viewModelLocator.ReportingViewModel.DepositType = Model.DepositType;
                    viewModelLocator.ReportingViewModel.SaveInputs();
                }
                settingsService.SaveSettings(json_file);  // Save rest of the information into settings.json.
                dialogService.ShowNotification("Settings saved.", "Success");
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to save settings to file.");
                dialogService.ShowNotification("Failed to save settings to file.", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        public void SelectPythonFile()
        {
            try
            {
                string exeFile = dialogService.OpenFileDialog("", "EXE files|*.exe;", true, true);
                if (!string.IsNullOrEmpty(exeFile))
                {
                    model.PythonEXEPath = exeFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to show OpenFileDialog.", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        public void SelectRFile()
        {
            try
            {
                string exeFile = dialogService.OpenFileDialog("", "EXE files|*.exe;", true, true);
                if (!string.IsNullOrEmpty(exeFile))
                {
                    model.REXEPath = exeFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to show OpenFileDialog.", "Error");
            }
        }

        /// <summary>
        /// Select folder with FolderBrowserDialog.
        /// </summary>        
        public void SelectDepModFolder()
        {
            try
            {
                string depModFolder = dialogService.SelectFolderDialog("c:\\", Environment.SpecialFolder.MyComputer);
                if (!string.IsNullOrEmpty(depModFolder))
                {
                    model.DepModFolderPath = depModFolder;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show FolderBrowserDialog");
                dialogService.ShowNotification("Failed to show FolderBrowserDialog.", "Error");
            }
        }
    }
}
