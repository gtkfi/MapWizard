namespace MapWizard.Tools.Settings
{
    /// <summary>
    /// Data for settings.
    /// </summary>
    public class SettingsDataModel : ParameterBase
    {
        /// <summary>
        /// Default Python path.
        /// </summary>
        /// @return Path.
        public string PythonPathDefault
        {
            get { return GetValue<string>("PythonPathDefault"); }
            set { Add<string>("PythonPathDefault", value); }
        }

        /// <summary>
        /// Path to .exe file for Python.
        /// </summary>
        /// @return Path.
        public string PythonPathCustom
        {
            get { return GetValue<string>("PythonPathCustom"); }
            set { Add<string>("PythonPathCustom", value); }
        }

        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public string PythonLocationDefault
        {
            get { return GetValue<string>("PythonLocationDefault"); }
            set { Add<string>("PythonLocationDefault", value); }
        }

        /// <summary>
        /// Default R path.
        /// </summary>
        /// @return Path.
        public string RPathDefault
        {
            get { return GetValue<string>("RPathDefault"); }
            set { Add<string>("RPathDefault", value); }
        }

        /// <summary>
        /// Path to .exe file for R.
        /// </summary>
        /// @return Path.
        public string RPathCustom
        {
            get { return GetValue<string>("RPathCustom"); }
            set { Add<string>("RPathCustom", value); }
        }

        /// <summary>
        /// "Custom" radio button.
        /// </summary>
        /// @return Path.
        public string RLocationDefault
        {
            get { return GetValue<string>("DefaultRLocation"); }
            set { Add<string>("DefaultRLocation", value); }
        }

        /// <summary>
        /// Default Deposit Models Folder Path.
        /// </summary>
        /// @return Path.
        public string DepModelsFolderPathDefault
        {
            get { return GetValue<string>("DepModelsFolderPathDefault"); }
            set { Add<string>("DepModelsFolderPathDefault", value); }
        }

        /// <summary>
        /// Path to Deposit Models folder.
        /// </summary>
        /// @return Path.
        public string DepModelsFolderPathCustom
        {
            get { return GetValue<string>("DepModelsFolderPathCustom"); }
            set { Add<string>("DepModelsFolderPathCustom", value); }
        }

        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public string DepModelsLocationDefault
        {
            get { return GetValue<string>("DepModelsLocationDefault"); }
            set { Add<string>("DepModelsLocationDefault", value); }
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
        
        /// <summary>
        /// Path to root folder.
        /// </summary>
        /// @return Path.
        public string RootFolderPath
        {
            get { return GetValue<string>("RootFolderPath"); }
            set { Add<string>("RootFolderPath", value); }
        }
    }
}
