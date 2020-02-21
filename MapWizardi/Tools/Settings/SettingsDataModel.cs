namespace MapWizard.Tools.Settings
{
    /// <summary>
    /// Data for settings.
    /// </summary>
    public class SettingsDataModel : ParameterBase
    {
        /// <summary>
        /// Path to .exe file for Python.
        /// </summary>
        /// @return Path.
        public string PythonEXEPath
        {
            get { return GetValue<string>("PythonEXEPath"); }
            set { Add<string>("PythonEXEPath", value); }
        }

        /// <summary>
        /// Path to .exe file for R.
        /// </summary>
        /// @return Path.
        public string REXEPath
        {
            get { return GetValue<string>("REXEPath"); }
            set { Add<string>("REXEPath", value); }
        }

        /// <summary>
        /// Path to root folder.
        /// </summary>
        /// @return Path.
        public string RootFolderPath
        {
            get { return GetValue<string>("RootFolderPath"); }
            set { Add<string>("RootFolderPath", value); }
        }

        /// <summary>
        /// Path to Deposit Models folder.
        /// </summary>
        /// @return Path.
        public string DepModFolderPath
        {
            get { return GetValue<string>("DepModFolderPath"); }
            set { Add<string>("DepModFolderPath", value); }
        }

        /// <summary>
        /// Default R path.
        /// </summary>
        /// @return Path.
        public string REXEPathDefault
        {
            get { return GetValue<string>("REXEPathdefault"); }
            set { Add<string>("REXEPathdefault", value); }
        }

        /// <summary>
        /// Default Python path.
        /// </summary>
        /// @return Path.
        public string PyEXEPathDefault
        {
            get { return GetValue<string>("PyEXEPathDefault"); }
            set { Add<string>("PyEXEPathDefault", value); }
        }

        /// <summary>
        /// Default Deposit Models Folder Path.
        /// </summary>
        /// @return Path.
        public string DepModFolderPathDefault
        {
            get { return GetValue<string>("DepModFolderPathDefault"); }
            set { Add<string>("DepModFolderPathDefault", value); }
        }

        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public string DefaultPythonLocation
        {
            get { return GetValue<string>("DefaultPythonLocation"); }
            set { Add<string>("DefaultPythonLocation", value); }
        }

        /// <summary>
        /// "Custom" radio button.
        /// </summary>
        /// @return Path.
        public string CustomPythonLocation
        {
            get { return GetValue<string>("CustomPythonLocation"); }
            set { Add<string>("CustomPythonLocation", value); }
        }

        /// <summary>
        /// Visibility for custom Python path button.
        /// </summary>
        /// @return Visibility value.
        public string PyButtonVisibility
        {
            get { return GetValue<string>("PyButtonVisibility"); }
            set { Add<string>("PyButtonVisibility", value); }
        }

        /// <summary>
        /// "Custom" radio button.
        /// </summary>
        /// @return Path.
        public string DefaultRLocation
        {
            get { return GetValue<string>("DefaultRLocation"); }
            set { Add<string>("DefaultRLocation", value); }
        }

        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public string CustomRLocation
        {
            get { return GetValue<string>("CustomRLocation"); }
            set { Add<string>("CustomRLocation", value); }
        }

        /// <summary>
        /// Visibility for custom R path button.
        /// </summary>
        /// @return Visibility value.
        public string RButtonVisibility
        {
            get { return GetValue<string>("RButtonVisibility"); }
            set { Add<string>("RButtonVisibility", value); }
        }

        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public string DefaultDepModLocation
        {
            get { return GetValue<string>("DefaultDepModLocation"); }
            set { Add<string>("DefaultDepModLocation", value); }
        }

        /// <summary>
        /// "Custom" radio button.
        /// </summary>
        /// @return Path.
        public string CustomDepModLocation
        {
            get { return GetValue<string>("CustomDepModLocation"); }
            set { Add<string>("CustomDepModLocation", value); }
        }

        /// <summary>
        /// Visibility for custom Deposit Models path button.
        /// </summary>
        /// @return Visibility value.
        public string DepModButtonVisibility
        {
            get { return GetValue<string>("DepModButtonVisibility"); }
            set { Add<string>("DepModButtonVisibility", value); }
        }

        /// <summary>
        /// Name for project, that we are currently using. Value will be given from MainViewModel's OpenProject method. 
        /// </summary>
        /// @return Project name.
        public string SelectedProjectName
        {
            get { return GetValue<string>("SelectedProjectName"); }
            set { Add<string>("SelectedProjectName", value); }
        }

        /// <summary>
        /// Path for project, that we are currently using. Value will be given from MainViewModel's OpenProject method. 
        /// </summary>
        /// @return Project path.
        public string SelectedProjectPath
        {
            get { return GetValue<string>("SelectedProjectPath"); }
            set { Add<string>("SelectedProjectPath", value); }
        }

        /// <summary>
        /// Name for project, that we are currently using. Value will be given from MainViewModel's OpenProject method. 
        /// </summary>
        /// @return Project name.
        public string DepositType
        {
            get { return GetValue<string>("DepositType"); }
            set { Add<string>("DepositType", value); }
        }
    }
}
