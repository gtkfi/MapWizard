using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// Observable object for SettingsModel
    public class SettingsModel : ObservableObject
    {
        private string logText="";        
        private int logHeight = 0;
        private string logTitle = "Hide log";
        private string pythonPathDefault;
        private string pythonPathCustom;
        private bool pythonLocationDefault;
        private bool pythonButtonVisibility;
        private string rPathDefault;
        private string rPathCustom;
        private bool rLocationDefault;
        private bool rButtonVisibility;
        private string depModelsFolderPathDefault;
        private string depModelsFolderPathCustom;                        
        private bool depModelsLocationDefault;
        private bool depModelsButtonVisibility;
        private string newProjectName;
        private string projectName;
        private string depositType;
        private object depositTypeVisibility;

        /// <summary>
        /// Title for log, located at the bottom of the view.
        /// </summary>
        /// @return Path.
        public string LogTitle
        {
            get
            {
                if (LogHeight > 1)
                {
                    logTitle = "Hide log";
                }
                else
                {
                    logTitle = "Show log";
                }
                return logTitle;
            }
            set
            {
                Set<string>(() => this.LogTitle, ref logTitle, value);
            }
        }

        /// <summary>
        /// Text for log, located at the bottom of the view.
        /// </summary>
        /// @return Path.
        public string LogText
        {
            get
            {
                return logText;
            }
            set
            {
                Set<string>(() => this.LogText, ref logText, value);
            }
        }

        /// <summary>
        /// Height of the log. Can be changed with a GridSplitter.
        /// </summary>
        /// @return Path.
        public int LogHeight
        {
            get
            {
                return logHeight;
            }
            set
            {
                Set<int>(() => this.LogHeight, ref logHeight, value);
                if (value > 1)
                {
                    LogTitle = "Hide log";
                }
                else
                {
                    LogTitle = "Show log";
                }
            }
        }

        /// <summary>
        /// Default Python path.
        /// </summary>
        /// @return Path.
        public string PythonPathDefault
        {
            get
            {
                return pythonPathDefault;
            }
            set
            {                
                Set<string>(() => this.PythonPathDefault, ref pythonPathDefault, value);
            }
        }

        /// <summary>
        /// Path to .exe file for Python.
        /// </summary>
        /// @return Path.
        public string PythonPathCustom
        {
            get
            {
                return pythonPathCustom;
            }
            set
            {
                Set<string>(() => this.PythonPathCustom, ref pythonPathCustom, value);
            }
        }

        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public bool PythonLocationDefault
        {
            get
            {
                return pythonLocationDefault;
            }
            set
            {
                PythonButtonVisibility = !value;
                Set<bool>(() => this.PythonLocationDefault, ref pythonLocationDefault, value);
                RaisePropertyChanged("PythonLocationDefault");
            }
        }

        /// <summary>
        /// Visibility for custom Python path button.
        /// </summary>
        /// @return Visibility value.
        public bool PythonButtonVisibility
        {
            get
            {
                return pythonButtonVisibility;
            }
            set
            {
                Set<bool>(() => this.PythonButtonVisibility, ref pythonButtonVisibility, value);
            }
        }

        /// <summary>
        /// Default R path.
        /// </summary>
        /// @return Path.
        public string RPathDefault
        {
            get
            {
                return rPathDefault;
            }
            set
            {
                Set<string>(() => this.RPathDefault, ref rPathDefault, value);
            }
        }

        /// <summary>
        /// Path to .exe file for R.
        /// </summary>
        /// @return Path.
        public string RPathCustom
        {
            get
            {
                return rPathCustom;
            }
            set
            {
                Set<string>(() => this.RPathCustom, ref rPathCustom, value);
            }
        }

        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public bool RLocationDefault
        {
            get
            {
                return rLocationDefault;
            }
            set
            {
                RButtonVisibility = !value;
                Set<bool>(() => this.RLocationDefault, ref rLocationDefault, value);
            }
        }

        /// <summary>
        /// Visibility for custom R path button.
        /// </summary>
        /// @return Visibility value.
        public bool RButtonVisibility
        {
            get
            {
                return rButtonVisibility;
            }
            set
            {
                Set<bool>(() => this.RButtonVisibility, ref rButtonVisibility, value);
            }
        }

        /// <summary>
        /// Default Deposit Models Folder Path.
        /// </summary>
        /// @return Path.
        public string DepModelsFolderPathDefault
        {
            get
            {
                return depModelsFolderPathDefault;
            }
            set
            {
                Set<string>(() => this.DepModelsFolderPathDefault, ref depModelsFolderPathDefault, value);
            }
        }

        /// <summary>
        /// Path to Deposit Models folder.
        /// </summary>
        /// @return Path.
        public string DepModelsFolderPathCustom
        {
            get
            {
                return depModelsFolderPathCustom;
            }
            set
            {
                Set<string>(() => this.DepModelsFolderPathCustom, ref depModelsFolderPathCustom, value);
            }
        }
        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public bool DepModelsLocationDefault
        {
            get
            {
                return depModelsLocationDefault;
            }
            set
            {
                DepModelsButtonVisibility = !value;
                Set<bool>(() => this.DepModelsLocationDefault, ref depModelsLocationDefault, value);
            }
        }

        /// <summary>
        /// Visibility for custom Deposit Models path button.
        /// </summary>
        /// @return Visibility value.
        public bool DepModelsButtonVisibility
        {
            get
            {
                return depModelsButtonVisibility;
            }
            set
            {
                Set<bool>(() => this.DepModelsButtonVisibility, ref depModelsButtonVisibility, value);
            }
        }

        /// <summary>
        /// Name for new project, that user gives in dialog.
        /// </summary>
        /// @return Project name.
        public string NewProjectName
        {
            get
            {
                return newProjectName;
            }
            set
            {
                Set<string>(() => this.NewProjectName, ref newProjectName, value);
            }
        }

        /// <summary>
        /// Name for project, that we are currently using. Value will be given from MainViewModel's OpenProject method. 
        /// </summary>
        /// @return Project name.
        public string ProjectName
        {
            get
            {
                return projectName;
            }
            set
            {
                Set<string>(() => this.ProjectName, ref projectName, value);
            }
        }

        /// <summary>
        /// Name for project, that we are currently using. Value will be given from MainViewModel's OpenProject method. 
        /// </summary>
        /// @return Project name.
        public string DepositType
        {
            get
            {
                return depositType;
            }
            set
            {
                Set<string>(() => this.DepositType, ref depositType, value);
            }
        }

        /// <summary>
        /// DepositType for project, that we are currently using. Value will be given from MainViewModel's OpenProject method.
        /// </summary>
        /// @return Visibility value.
        public object DepositTypeVisibility
        {
            get
            {
                return depositTypeVisibility;
            }
            set
            {
                Set<object>(() => this.DepositTypeVisibility, ref depositTypeVisibility, value);
            }
        }
    }
}
