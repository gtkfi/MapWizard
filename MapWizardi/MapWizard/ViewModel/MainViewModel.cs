using Dragablz;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using MapWizard.Model;
using MapWizard.View;
using NLog;
using MapWizard.Tools.Settings;
using MapWizard.Service;
using System;
using System.Windows.Controls;
using System.IO;
using Microsoft.Win32;
using System.Collections.Generic;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// This class contains properties that the main View can data bind to.
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
    public class MainViewModel : ViewModelBase
    {
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private OldMainWindowView mainWindowView;
        private MapWizardView mapWizardView;
        private NewProjectDialog newProjectDialog;
        private MainWindowModel model;
        private ViewModelLocator viewModelLocator;
        public UserControl activeView;        
        private readonly IInterTabClient _interTabClient;

        /// <summary>
        /// Initialize a new instance of the MainViewModel class.
        /// </summary>
        private void Initialize()
        {
            mainWindowView = new OldMainWindowView();
            mapWizardView = new MapWizardView();
            model = new MainWindowModel();
            viewModelLocator = new ViewModelLocator();
            activeView = mainWindowView;            
        }

        /// <summary>
        /// Initialize new instance of MainViewModel class.
        /// </summary>
        /// <param name="logger">Logging for the MapWizard</param>
        /// <param name="dialogService">Service for using project's dialogs and notifications</param>
        /// <param name="settingsService">Service for using and editing project's settings</param>
        public MainViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            Initialize();
            _interTabClient = new MyInterTabClient();
            GoToWizard = new RelayCommand(ChangeToWizardView, CanChangeView);
            GoToMainWindowView = new RelayCommand(ChangeToMainWindowView, CanChangeView);
            SelectProjectCommand = new RelayCommand(SelectProject, CanRunTool);
            OpenDialog = new RelayCommand(OpenNewProjectDialog, CanRunTool);
            OpenProject1 = new RelayCommand(LoadProject1Settings, CanChangeView);
            OpenProject2 = new RelayCommand(LoadProject2Settings, CanChangeView);
            OpenProject3 = new RelayCommand(LoadProject3Settings, CanChangeView);
            OpenProject4 = new RelayCommand(LoadProject4Settings, CanChangeView);
            OpenProject5 = new RelayCommand(LoadProject5Settings, CanChangeView);
            NewProject = new RelayCommand(CreateNewProject, CanRunTool);
            SelectProjectFolderCommand = new RelayCommand(SelectProjectFolder, CanRunTool);
            GetRecentProjects();  // Get the latest projects into user interface from registry.
            if (Path.GetDirectoryName(settingsService.RootPath) != null)
            {
                Model.ProjectLocation = Path.GetDirectoryName(settingsService.RootPath);
            }
            else
            {
                Model.ProjectLocation = Path.Combine(Path.GetPathRoot(Environment.SystemDirectory), "Temp", "MapWizard");
            }
            ////if (IsInDesignMode)
            ////{
            ////    // Code runs in Blend --> create design time data.
            ////}
            ////else
            ////{
            ////    // Code runs "for real"
            ////}
        }

        /// <summary>
        /// Go to MapWizard View command.
        /// </summary>
        /// @return Command.
        public RelayCommand GoToWizard { get; set; }

        /// <summary>
        /// Go to MainWindow View command.
        /// </summary>
        /// @return Command.
        public RelayCommand GoToMainWindowView { get; }

        /// <summary>
        /// Select project command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectProjectCommand { get; set; }

        /// <summary>
        /// Open dialog command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenDialog { get; set; }

        /// <summary>
        /// New project command.
        /// </summary>
        /// @return Command.
        public RelayCommand NewProject { get; set; }

        /// <summary>
        /// Select project folder command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectProjectFolderCommand { get; set; }

        /// <summary>
        /// Open project command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenProject1 { get; set; }

        /// <summary>
        /// Open project command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenProject2 { get; set; }

        /// <summary>
        /// Open project command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenProject3 { get; set; }

        /// <summary>
        /// Open project command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenProject4 { get; set; }

        /// <summary>
        /// Open project command.
        /// </summary>
        /// @return Command.
        public RelayCommand OpenProject5 { get; set; }

        /// <summary>
        /// Model for MainWindowModel.
        /// </summary>
        /// <returns>MainWindowModel.</returns>
        public MainWindowModel Model
        {
            get
            {
                return model;
            }
            set
            {
                model = value;
                RaisePropertyChanged("MainWindowModel");
            }
        }

        /// <summary>
        /// Get at most five recent projects.
        /// </summary>
        private void GetRecentProjects()  
        {
            try
            {
                if (Registry.CurrentUser.OpenSubKey(@"SOFTWARE\MapProjects") != null)
                {
                    using (RegistryKey RegKey = Registry.CurrentUser.CreateSubKey(@"SOFTWARE\MapProjects"))
                    {
                        List<string> GetRecents = new List<string>();
                        string[] nameArray = (string[])RegKey.GetValue("ProjectList");
                        // Check if the registry has any projects registered.
                        if (nameArray != null)
                        {
                            for (int i = 0; i < nameArray.Length; i++)
                            {
                                if (File.Exists(nameArray[i]) && !GetRecents.Contains(nameArray[i])) // Check if the registered project exists.
                                {
                                    GetRecents.Add(nameArray[i]);
                                }
                            }
                            nameArray = GetRecents.ToArray();
                            RegKey.DeleteValue("ProjectList");
                            RegKey.SetValue("ProjectList", nameArray);  // Update old ProjectList into a new one.
                        }
                        using (List<string>.Enumerator e = GetRecents.GetEnumerator())
                        {
                            if (e.MoveNext() != false)
                            {
                                model.Project1Name = Path.GetFileName(Path.GetDirectoryName(e.Current));
                                model.Project1Path = e.Current;
                            }
                        if (e.MoveNext() != false)
                        {
                            model.Project2Name = Path.GetFileName(Path.GetDirectoryName(e.Current));
                            model.Project2Path = e.Current;
                        }
                        if (e.MoveNext() != false)
                        {
                            model.Project3Name = Path.GetFileName(Path.GetDirectoryName(e.Current));
                            model.Project3Path = e.Current;
                        }
                        if (e.MoveNext() != false)
                        {
                            model.Project4Name = Path.GetFileName(Path.GetDirectoryName(e.Current));
                            model.Project4Path = e.Current;
                        }
                        if (e.MoveNext() != false)
                        {
                            model.Project5Name = Path.GetFileName(Path.GetDirectoryName(e.Current));
                            model.Project5Path = e.Current;
                        }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to load recent MapWizard projects");
                dialogService.ShowNotification("Failed to load recent MapWizard projects.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to load recent MapWizard projects.", "Error");
            }
        }

        /// <summary>
        /// Load projects settings when chosen from Recent Projects.
        /// </summary>
        private void LoadProject1Settings()
        {
            OpenProject(model.Project1Path);
        }

        /// <summary>
        /// Load projects settings when chosen from Recent Projects.
        /// </summary>
        private void LoadProject2Settings()
        {
            OpenProject(model.Project2Path);
        }

        /// <summary>
        /// Load projects settings when chosen from Recent Projects.
        /// </summary>
        private void LoadProject3Settings()
        {
            OpenProject(model.Project3Path);
        }

        /// <summary>
        /// Load projects settings when chosen from Recent Projects.
        /// </summary>
        private void LoadProject4Settings()
        {
            OpenProject(model.Project4Path);
        }

        /// <summary>
        /// Load projects settings when chosen from Recent Projects.
        /// </summary>
        private void LoadProject5Settings()
        {
            OpenProject(model.Project5Path);
        }

        /// <summary>
        /// Opens dialog from root path. 
        /// </summary>
        private void SelectProject()
        {
            try
            {
                string MAPWfile = dialogService.OpenFileDialog(settingsService.RootPath, "MapWizard Projects|*.MAPW;", true, true, settingsService.RootPath);
                OpenProject(MAPWfile);
            }

            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
                dialogService.ShowNotification("Failed to show OpenFileDialog.", "Error");
            }
        }

        /// <summary>
        /// Open the project's settings for use.
        /// </summary>
        /// <param name="MAPWfile">Path to the chosen project</param>
        private void OpenProject(string MAPWfile)
        {
            try
            {
                string settings_json = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), "MapWizard", "settings.json");
                if (!string.IsNullOrEmpty(MAPWfile) && File.Exists(MAPWfile))
                {
                    model.ProjectName = Path.GetFileName(MAPWfile);
                    settingsService.LoadSettings(MAPWfile);
                    string depositType = settingsService.Data.DepositType;  // Gets in store the depostitype so it can be later saved into project's MAPW-file.
                    settingsService.LoadSettings(settings_json);  // Settings don't have memory of the last deposittype, which is why it have to be saved in store.
                    settingsService.AddToRegistry(MAPWfile);  // Save path to the project into registry, this updates recent projects in the mainview.
                    GetRecentProjects();
                    viewModelLocator.ClearTools();  // Closes all tools, so that the tools can initialized correctly. Does not clear settings.
                    settingsService.Data.RootFolderPath = Path.GetDirectoryName(MAPWfile);  // Get location of the project so it can be saved into json file.
                    settingsService.Data.DepositType = depositType;  // Get deposittype so it can be saved into json file.
                    settingsService.SaveSettings(settings_json);  // Save only the root path and the deposittype into projects json file.
                    Model.ProjectLocation = Directory.GetParent(settingsService.RootPath).ToString();  // Shows the project that is being used in the user interface.
                    viewModelLocator.SettingsViewModel.UpdateSettings(depositType);  // Depositype is the only setting that is project specific.
                    mapWizardView = new MapWizardView();  // The view must be initialized again so that it will be updated.
                    ChangeToWizardView();
                    viewModelLocator.SettingsViewModel.WriteLogText("Project '" + model.ProjectName + "' opened from directory: "+ settingsService.Data.RootFolderPath, "Success");
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to open a project");
                dialogService.ShowNotification("Failed to open a project.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to open a project.", "Error");
            }
        }

        /// <summary>
        /// Opens dialog for creating new project.
        /// </summary>
        private void OpenNewProjectDialog()
        {
            newProjectDialog = new NewProjectDialog();  // New project dialog has it's own view.
            newProjectDialog.Show();
        }

        /// <summary>
        /// Select folder with FolderBrowserDialog.
        /// </summary>        
        private void SelectProjectFolder()
        {
            try
            {
                string rootFolder = dialogService.SelectFolderDialog(settingsService.RootPath, Environment.SpecialFolder.MyComputer);
                if (!string.IsNullOrEmpty(rootFolder))
                {
                    Model.ProjectLocation = rootFolder;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show FolderBrowserDialog");
                dialogService.ShowNotification("Failed to show FolderBrowserDialog", "Error");
            }
        }

        /// <summary>
        /// Creates a new project into root folder.
        /// </summary>
        private void CreateNewProject()
        {
            string MAPWfile = "";
            try
            {
                string projectFolder = Path.Combine(Model.ProjectLocation, model.NewProjectName);
                if (model.NewProjectName==null || model.NewProjectName == "")
                {
                    throw new Exception();
                }
                if (!Directory.Exists(projectFolder))
                {
                    Directory.CreateDirectory(projectFolder);
                }
                MAPWfile = Path.Combine(projectFolder, model.NewProjectName + ".MAPW");
                settingsService.Data = new SettingsDataModel()
                {
                    RootFolderPath = Path.GetDirectoryName(MAPWfile),
                    DepositType = Model.DepositType
                };
                settingsService.SaveSettings(MAPWfile);  // Save only the root path and the deposittype into projects json file.
                viewModelLocator.SettingsViewModel.WriteLogText("Project '" + model.NewProjectName + "' created into directory: " + projectFolder, "Success");
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to create a new project");
                dialogService.ShowNotification("Failed to create a new project.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to create a new project.", "Error");
            }
            OpenProject(MAPWfile);  // Open the created project.
            newProjectDialog.Close();
        }

        /// <summary>
        /// Change the active view of the main window to MapWizardView
        /// </summary>
        private void ChangeToWizardView()
        {
            ActiveView = mapWizardView;
            //throw new NotImplementedException();
        }

        /// <summary>
        /// Change the active view of the main window to MainWindowView
        /// </summary>
        private void ChangeToMainWindowView()
        {
            viewModelLocator.SettingsViewModel.Model.ProjectName = "-";  // In mainwindow there's no project being used.
            viewModelLocator.SettingsViewModel.Model.DepositTypeVisibility = "Collapsed";  // Since no project is being used, there is no deposittype.
            // Close all the tab wndows.
            for (int intCounter = App.Current.Windows.Count - 1; intCounter >= 0; intCounter--)
            {
                if (App.Current.Windows[intCounter]!=App.Current.MainWindow)
                {
                    App.Current.Windows[intCounter].Close();
                }
            }             
            ActiveView = mainWindowView;
        }

        /// <summary>
        /// Currently active view.
        /// </summary>
        /// <returns>ActiveView.</returns>
        public UserControl ActiveView
        {
            get { return activeView; }
            set
            {
                if (value == activeView) return;
                activeView = value;
                RaisePropertyChanged("ActiveView");
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

        /// <summary>
        /// Get the InterTabClient
        /// </summary>
        /// <returns>InterTabClient.</returns>
        public IInterTabClient InterTabClient
        {
            get { return _interTabClient; }
        }

        /// <summary>
        ///Defines which tools uses metro dialog.
        /// </summary>
        /// <returns>DialogContentSource.</returns>
        public string DialogContentSource
        {
            get
            {
                return model.DialogContentSource;
            }
            set
            {
                if (model.DialogContentSource == value) return;
                model.DialogContentSource = value.ToString();
                RaisePropertyChanged("DialogContentSource");
            }
        }
    }
}