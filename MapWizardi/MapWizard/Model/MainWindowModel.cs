using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// MainWindowModel
    /// </summary>
    public class MainWindowModel : ObservableObject
    {                
        private string depositType;
        private string projectLocation;
        private string newProjectName;
        private string projectName;
        private string project1Name;
        private string project2Name;
        private string project3Name;
        private string project4Name;
        private string project5Name;
        private string project1Path;
        private string project2Path;
        private string project3Path;
        private string project4Path;
        private string project5Path;
        private string dialogContentSource;

        /// <summary>
        /// Deposit type.
        /// </summary>
        /// @return Deposit type.
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
        /// Project location.
        /// </summary>
        /// @return Project location.
        public string ProjectLocation
        {
            get
            {
                return projectLocation;
            }
            set
            {
                Set<string>(() => this.ProjectLocation, ref projectLocation, value);
            }
        }

        /// <summary>
        /// Name for new project, that user gives in dialog.
        /// </summary>
        /// @return Name for new project.
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
        /// Name of the project that is selected.
        /// </summary>
        /// @return Name of the project.
        public string ProjectName
        {
            get { return projectName; }
            set
            {
                Set<string>(() => this.ProjectName, ref projectName, value);
            }
        }

        /// <summary>
        /// Name of the first project in Recent Projects.
        /// </summary>
        /// @return Name of the project.
        public string Project1Name
        {
            get { return project1Name; }
            set
            {
                Set<string>(() => this.Project1Name, ref project1Name, value);
            }
        }

        /// <summary>
        /// Name of the second project in Recent Projects.
        /// </summary>
        /// @return Name of the project.
        public string Project2Name
        {
            get { return project2Name; }
            set
            {
                Set<string>(() => this.Project2Name, ref project2Name, value);
            }
        }

        /// <summary>
        /// Name of the third project in Recent Projects.
        /// </summary>
        /// @return Name of the project.
        public string Project3Name
        {
            get { return project3Name; }
            set
            {
                Set<string>(() => this.Project3Name, ref project3Name, value);
            }
        }

        /// <summary>
        /// Name of the fourth project in Recent Projects.
        /// </summary>
        /// @return Name of the project.
        public string Project4Name
        {
            get { return project4Name; }
            set
            {
                Set<string>(() => this.Project4Name, ref project4Name, value);
            }
        }

        /// <summary>
        /// Name of the fifth project in Recent Projects.
        /// </summary>
        /// @return Name of the project.
        public string Project5Name
        {
            get { return project5Name; }
            set
            {
                Set<string>(() => this.Project5Name, ref project5Name, value);
            }
        }

        /// <summary>
        /// Path of the first project in Recent Projects.
        /// </summary>
        /// @return Project path.
        public string Project1Path
        {
            get { return project1Path; }
            set
            {
                Set<string>(() => this.Project1Path, ref project1Path, value);
            }
        }

        /// <summary>
        /// Path of the second project in Recent Projects.
        /// </summary>
        /// @return Project path.
        public string Project2Path
        {
            get { return project2Path; }
            set
            {
                Set<string>(() => this.Project2Path, ref project2Path, value);
            }
        }

        /// <summary>
        /// Path of the third project in Recent Projects.
        /// </summary>
        /// @return Project path.
        public string Project3Path
        {
            get { return project3Path; }
            set
            {
                Set<string>(() => this.Project3Path, ref project3Path, value);
            }
        }

        /// <summary>
        /// Path of the fourth project in Recent Projects.
        /// </summary>
        /// @return Project path.
        public string Project4Path
        {
            get { return project4Path; }
            set
            {
                Set<string>(() => this.Project4Path, ref project4Path, value);
            }
        }

        /// <summary>
        /// Path of the fifth project in Recent Projects.
        /// </summary>
        /// @return Project path.
        public string Project5Path
        {
            get { return project5Path; }
            set
            {
                Set<string>(() => this.Project5Path, ref project5Path, value);
            }
        }

        /// <summary>
        /// Defines which tools uses metro dialog.
        /// </summary>
        /// @return Source.
        public string DialogContentSource
        {
            get { return dialogContentSource; }
            set
            {
                Set<string>(() => this.DialogContentSource, ref dialogContentSource, value);
            }
        }
    }
}
