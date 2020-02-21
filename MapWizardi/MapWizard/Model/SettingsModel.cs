using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// Observable object for SettingsModel
    public class SettingsModel : ObservableObject
    {
        private string pythonexePath;
        private string rexePath;
        private string rootFolderPath;
        private string depModFolderPath;
        private string RexePathDefault;
        private string PexePathDefault;
        private string depModFolderPathDefault;
        private string defaultPythonLocation;
        private string customPythonLocation;
        private string pyButtonVisibility;
        private string defaultRLocation;
        private string customRLocation;
        private string rButtonVisibility;
        private string defaultDepModLocation;
        private string customDepModLocation;
        private string depModButtonVisibility;
        private string newProjectName;
        private string projectName;
        private string depositType;
        private object depositTypeVisibility;

        /// <summary>
        /// Path to .exe file for Python.
        /// </summary>
        /// @return Path.
        public string PythonEXEPath
        {
            get
            {
                return pythonexePath;
            }
            set
            {
                Set<string>(() => this.PythonEXEPath, ref pythonexePath, value);
            }
        }

        /// <summary>
        /// Path to .exe file for R.
        /// </summary>
        /// @return Path.
        public string REXEPath
        {
            get
            {
                return rexePath;
            }
            set
            {
                Set<string>(() => this.REXEPath, ref rexePath, value);
            }
        }

        /// <summary>
        /// Path to root folder.
        /// </summary>
        /// @return Path.
        public string RootFolderPath
        {
            get
            {
                return rootFolderPath;
            }
            set
            {
                Set<string>(() => this.RootFolderPath, ref rootFolderPath, value);
            }
        }

        /// <summary>
        /// Path to Deposit Models folder.
        /// </summary>
        /// @return Path.
        public string DepModFolderPath
        {
            get
            {
                return depModFolderPath;
            }
            set
            {
                Set<string>(() => this.DepModFolderPath, ref depModFolderPath, value);
            }
        }

        /// <summary>
        /// Default R path.
        /// </summary>
        /// @return Path.
        public string REXEPathDefault
         {
             get
             {
                 return RexePathDefault;
             }
             set
             {
                 Set<string>(() => this.REXEPathDefault, ref RexePathDefault, value);
             }
         }

        /// <summary>
        /// Default Python path.
        /// </summary>
        /// @return Path.
        public string PyEXEPathDefault
        {
            get
            {
                return PexePathDefault;
            }
            set
            {
                Set<string>(() => this.PyEXEPathDefault, ref PexePathDefault, value);
            }
        }

        /// <summary>
        /// Default Deposit Models Folder Path.
        /// </summary>
        /// @return Path.
        public string DepModFolderPathDefault
        {
            get
            {
                return depModFolderPathDefault;
            }
            set
            {
                Set<string>(() => this.DepModFolderPathDefault, ref depModFolderPathDefault, value);
            }
        }

        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public string DefaultPythonLocation
        {
            get
            {
                return defaultPythonLocation;
            }
            set
            {
                Set<string>(() => this.DefaultPythonLocation, ref defaultPythonLocation, value);
            }
        }

        /// <summary>
        /// "Custom" radio button.
        /// </summary>
        /// @return Path.
        public string CustomPythonLocation
        {
            get
            {
                return customPythonLocation;
            }
            set
            {
                Set<string>(() => this.CustomPythonLocation, ref customPythonLocation, value);
            }
        }

        /// <summary>
        /// Visibility for custom Python path button.
        /// </summary>
        /// @return Visibility value.
        public string PyButtonVisibility
        {
            get
            {
                return pyButtonVisibility;
            }
            set
            {
                Set<string>(() => this.PyButtonVisibility, ref pyButtonVisibility, value);
            }
        }

        /// <summary>
        /// "Custom" radio button.
        /// </summary>
        /// @return Path.
        public string CustomRLocation
        {
            get
            {
                return customRLocation;
            }
            set
            {
                Set<string>(() => this.CustomRLocation, ref customRLocation, value);
            }
        }

        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public string DefaultRLocation
        {
            get
            {
                return defaultRLocation;
            }
            set
            {
                Set<string>(() => this.DefaultRLocation, ref defaultRLocation, value);
            }
        }

        /// <summary>
        /// Visibility for custom R path button.
        /// </summary>
        /// @return Visibility value.
        public string RButtonVisibility
        {
            get
            {
                return rButtonVisibility;
            }
            set
            {
                Set<string>(() => this.RButtonVisibility, ref rButtonVisibility, value);
            }
        }

        /// <summary>
        /// "Default" radio button.
        /// </summary>
        /// @return Path.
        public string DefaultDepModLocation
        {
            get
            {
                return defaultDepModLocation;
            }
            set
            {
                Set<string>(() => this.DefaultDepModLocation, ref defaultDepModLocation, value);
            }
        }

        /// <summary>
        /// "Custom" radio button.
        /// </summary>
        /// @return Path.
        public string CustomDepModLocation
        {
            get
            {
                return customDepModLocation;
            }
            set
            {
                Set<string>(() => this.CustomDepModLocation, ref customDepModLocation, value);
            }
        }

        /// <summary>
        /// Visibility for custom Deposit Models path button.
        /// </summary>
        /// @return Visibility value.
        public string DepModButtonVisibility
        {
            get
            {
                return depModButtonVisibility;
            }
            set
            {
                Set<string>(() => this.DepModButtonVisibility, ref depModButtonVisibility, value);
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
