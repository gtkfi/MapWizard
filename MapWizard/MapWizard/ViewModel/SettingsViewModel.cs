using System;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using MapWizard.Model;
using NLog;
using MapWizard.Tools.Settings;
using MapWizard.Service;
using System.IO;
using System.Reflection;

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
            ShowLogCommand = new RelayCommand(ShowLog);
            viewModelLocator = new ViewModelLocator();
            // Load the data from settings.json file.
            try
            {
                Model = new SettingsModel
                {
                    PythonPathDefault = settingsService.Data.PythonPathDefault,
                    PythonPathCustom = settingsService.Data.PythonPathCustom,
                    PythonLocationDefault = bool.Parse(settingsService.Data.PythonLocationDefault),
                    RPathDefault = settingsService.Data.RPathDefault,
                    RPathCustom = settingsService.Data.RPathCustom,
                    RLocationDefault = bool.Parse(settingsService.Data.RLocationDefault),
                    DepModelsFolderPathDefault = settingsService.Data.DepModelsFolderPathDefault,
                    DepModelsFolderPathCustom = settingsService.Data.DepModelsFolderPathCustom,
                    DepModelsLocationDefault = bool.Parse(settingsService.Data.DepModelsLocationDefault),
                    ProjectName = "-",
                    NewProjectName = "",
                    DepositTypeVisibility = "Collapsed"
                };
                PropertyInfo[] settingProperties = Model.GetType().GetProperties();
                // Goes through all the settings and check if any of them are null.
                foreach (PropertyInfo prop in settingProperties)
                {
                    object modelObject = Model;
                    if (prop.GetValue(modelObject) == null)
                    {
                        if (prop.Name != "DepositType")
                        {
                            throw new Exception();
                        }                        
                    }
                }
            }
            catch (Exception ex)
            {
                this.settingsService.SettingsInitialization();
                string settings_json = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), "MapWizard", "settings.json");
                this.settingsService.SaveSettings(settings_json);
                Model = new SettingsModel
                {
                    PythonPathDefault = settingsService.Data.PythonPathDefault,
                    PythonPathCustom = settingsService.Data.PythonPathCustom,
                    PythonLocationDefault = bool.Parse(settingsService.Data.PythonLocationDefault),
                    RPathDefault = settingsService.Data.RPathDefault,
                    RPathCustom = settingsService.Data.RPathCustom,
                    RLocationDefault = bool.Parse(settingsService.Data.RLocationDefault),
                    DepModelsFolderPathDefault = settingsService.Data.DepModelsFolderPathDefault,
                    DepModelsFolderPathCustom = settingsService.Data.DepModelsFolderPathCustom,
                    DepModelsLocationDefault = bool.Parse(settingsService.Data.DepModelsLocationDefault),
                    ProjectName = "-",
                    NewProjectName = "",
                    DepositTypeVisibility = "Collapsed"
                };
                logger.Error(ex, "Error when loading settings.");
                WriteLogText("Error when loading settings. Settings were initialized to default values.", "Error");
                //this.dialogService.ShowNotification("Error when loading settings.", "Error");  //TAGGED: Throw error when trying to show notification because the view is not initialized. Better solution for this.
            }
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
        /// Show or hide log command.
        /// </summary>
        /// @return Command.
        public RelayCommand ShowLogCommand { get; }

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
        ///Update settings when project is opened in MainViewModel.
        /// </summary>
        public void UpdateSettings(string depositType)
        {
            Model.PythonPathDefault = settingsService.Data.PythonPathDefault;
            Model.PythonPathCustom = settingsService.Data.PythonPathCustom;
            Model.PythonLocationDefault = bool.Parse(settingsService.Data.PythonLocationDefault);
            Model.RPathDefault = settingsService.Data.RPathDefault;
            Model.RPathCustom = settingsService.Data.RPathCustom;
            Model.RLocationDefault = bool.Parse(settingsService.Data.RLocationDefault);
            Model.DepModelsFolderPathDefault = settingsService.Data.DepModelsFolderPathDefault;
            Model.DepModelsFolderPathCustom = settingsService.Data.DepModelsFolderPathCustom;
            Model.DepModelsLocationDefault = bool.Parse(settingsService.Data.DepModelsLocationDefault);
            Model.DepositTypeVisibility = "Visible";
            Model.ProjectName = Path.GetFileName(settingsService.Data.RootFolderPath);
            Model.DepositType = depositType;
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
                    if ((Path.GetFileName(rootDirectory) == Model.ProjectName) && (Model.DepositTypeVisibility.ToString() == "Visible"))
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
                    PythonPathDefault = Model.PythonPathDefault,
                    PythonPathCustom = Model.PythonPathCustom,
                    PythonLocationDefault = Model.PythonLocationDefault.ToString(),
                    RPathDefault = Model.RPathDefault,
                    RPathCustom = Model.RPathCustom,
                    RLocationDefault = Model.RLocationDefault.ToString(),
                    DepModelsFolderPathDefault = Model.DepModelsFolderPathDefault,
                    DepModelsFolderPathCustom = Model.DepModelsFolderPathCustom,
                    DepModelsLocationDefault = Model.DepModelsLocationDefault.ToString()
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
                    viewModelLocator.ReportingViewModel.Model.DepositType = Model.DepositType;
                    viewModelLocator.ReportingViewModel.SaveInputs();
                }
                settingsService.SaveSettings(json_file);  // Save rest of the information into settings.json.
                dialogService.ShowNotification("Settings saved.", "Success");
                WriteLogText("Settings saved.", "Success");
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to save settings to file.");
                dialogService.ShowNotification("Failed to save settings to file.", "Error");
                WriteLogText("Failed to save settings to file.", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        public void SelectPythonFile()
        {
            try
            {
                string exeFile = dialogService.OpenFileDialog("", "EXE files|*.exe;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(exeFile))
                {
                    Model.PythonPathCustom = exeFile;
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
                string exeFile = dialogService.OpenFileDialog("", "EXE files|*.exe;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(exeFile))
                {
                    Model.RPathCustom = exeFile;
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
                    Model.DepModelsFolderPathCustom = depModFolder;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show FolderBrowserDialog");
                dialogService.ShowNotification("Failed to show FolderBrowserDialog.", "Error");
            }
        }

        /// <summary>
        /// Writes text for the log in user interface.
        /// </summary>  
        public void WriteLogText(string logText, string logType)
        {
            if (logType == "Error")
            {
                Model.LogText = DateTime.Now.ToString("HH:mm") + " --> ERROR: " + logText + "\r\n" + Model.LogText;
            }
            else
            {
                Model.LogText = DateTime.Now.ToString("HH:mm") + " --> " + logText + "\r\n" + Model.LogText;
            }
        }

        /// <summary>
        /// Shows or hides log.
        /// </summary>  
        public void ShowLog()
        {
            if (Model.LogTitle=="Hide log")
            {
                Model.LogHeight = 0;
            }
            else
            {
                Model.LogHeight = 1000;  // Maximum height is Window's height/3 
            }
        }
    }
}
