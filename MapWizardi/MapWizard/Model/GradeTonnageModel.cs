using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;

namespace MapWizard.Model
{
    /// <summary>
    /// GradeTonnage model.
    /// </summary>
    public class GradeTonnageModel : ObservableObject
    {
        // Always initialized the same way.
        private bool isBusy;
        private int selectedIndex;
        private ObservableCollection<string> modelNames = new ObservableCollection<string>();
        public ObservableCollection<string> pdfTypes = new ObservableCollection<string>() { "normal", "kde" };
        public ObservableCollection<string> truncated = new ObservableCollection<string>() { "FALSE", "TRUE" };
        private int selectedModelIndex = 0;
        private string depositModelsExtension = "";
        private bool saveToDepositModels = false;
        private bool useModelName = false;
        // Not always initialized the same way.
        private int runStatus = 2;  // 0=error, 1=success, 2=not run yet.
        private string lastRunDate = "Last Run: Never";
        private string csvPath = "Select Data";
        private int seed = 1;
        private string pdfType = "Normal";
        private string isTruncated = "FALSE";
        private int minDeposits = 20;
        private int randSamples = 1000000;
        private string folder;
        private string runGrade = "false";
        private string runTonnage = "false";
        private string runGradeTonnage = "false";
        private string modelType = "GT";
        private string extensionFolder = "";

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
            }
        }

        /// <summary>
        /// Public index for View to bind to.
        /// </summary>
        /// @return Integer representing the tab.
        public int SelectedIndex
        {
            get { return selectedIndex; }
            set
            {
                if (value == selectedIndex) return;
                selectedIndex = value;
                RaisePropertyChanged("SelectedIndex");
            }
        }

        /// <summary>
        /// Public Model names property
        /// </summary>
        /// @return Collection of models.
        public ObservableCollection<string> ModelNames
        {
            get { return modelNames; }
            set
            {
                if (value == modelNames) return;
                modelNames = value;
            }
        }

        /// <summary>
        /// Pdf types.
        /// </summary>
        /// @return Pdf type collection.   
        public ObservableCollection<string> PdfTypes
        {
            get
            {
                return pdfTypes;
            }
            set
            {
                pdfTypes = value;
                RaisePropertyChanged("PdfTypes");
            }
        }

        /// <summary>
        /// Is truncated?
        /// </summary>
        /// @return Truncation collection.
        public ObservableCollection<string> Truncated
        {
            get
            {
                return truncated;
            }
            set
            {
                truncated = value;
                RaisePropertyChanged("Truncated");
            }
        }

        /// <summary>
        /// Public index for View to bind to
        /// </summary>
        /// @return Integer representing the selected model.
        public int SelectedModelIndex
        {
            get { return selectedModelIndex; }
            set
            {
                if (value == selectedModelIndex) return;
                selectedModelIndex = value;
                RaisePropertyChanged("SelectedModelIndex");
            }
        }

        /// <summary>
        /// Extension folder for Deposit model.
        /// </summary>
        /// @return Extendion folder name.
        public string DepositModelsExtension
        {
            get { return depositModelsExtension; }
            set
            {
                if (value == depositModelsExtension) return;
                depositModelsExtension = value;
            }
        }

        /// <summary>
        /// Whether to save to deposit models
        /// </summary>
        /// @return Boolean representing the choice.
        public bool SaveToDepositModels
        {
            get { return saveToDepositModels; }
            set
            {
                if (value == saveToDepositModels) return;
                saveToDepositModels = value;
            }
        }

        /// <summary>
        /// Boolean representing whether to use model name or not.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool UseModelName
        {
            get { return useModelName; }
            set
            {
                if (value == useModelName) return;
                useModelName = value;
                RaisePropertyChanged("UseModelName");
            }
        }

        /// <summary>
        /// Date of last run
        /// </summary>
        /// @return Date.
        public string LastRunDate
        {
            get { return lastRunDate; }
            set
            {
                if (value == lastRunDate) return;
                lastRunDate = value;
                RaisePropertyChanged("LastRunDate");
            }
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
                RaisePropertyChanged("RunStatus");
            }
        }

        /// <summary>
        /// CSV path.
        /// </summary>
        /// @return CSV path.
        public string CSVPath
        {
            get
            {
                return csvPath;
            }
            set
            {
                if (value == null)
                {
                    value = "Select Data";
                }
                Set<string>(() => this.CSVPath, ref csvPath, value);
            }
        }

        /// <summary>
        /// Seed value.
        /// </summary>
        /// @return Seed value.
        public int Seed
        {
            get
            {
                return seed;
            }
            set
            {
                Set<int>(() => this.Seed, ref seed, value);
            }
        }

        /// <summary>
        /// Is truncated?
        /// </summary>
        /// @return Is truncated?
        public string IsTruncated
        {
            get
            {
                return isTruncated;
            }
            set
            {
                if (value == null)
                {
                    value = "FALSE";
                }
                Set<string>(() => this.IsTruncated, ref isTruncated, value);
            }
        }

        /// <summary>
        /// PDF type.
        /// </summary>
        /// @return PDF type.
        public string PdfType
        {
            get
            {
                return pdfType;
            }
            set
            {
                if (value == null)
                {
                    value = "Normal";
                }
                Set<string>(() => this.PdfType, ref pdfType, value);
            }
        }

        /// <summary>
        /// Minimum deposits.
        /// </summary>
        /// @return Minimum deposits.
        public int MinDepositCount
        {
            get
            {
                return minDeposits;
            }
            set
            {
                Set<int>(() => this.MinDepositCount, ref minDeposits, value);
            }
        }

        /// <summary>
        /// Random sample count.
        /// </summary>
        /// @return Random sample count.
        public int RandomSampleCount
        {
            get
            {
                return randSamples;
            }
            set
            {
                Set<int>(() => this.RandomSampleCount, ref randSamples, value);
            }
        }

        /// <summary>
        /// Folder.
        /// </summary>
        /// @return Folder.
        public string Folder
        {
            get
            {
                return folder;
            }
            set
            {
                Set<string>(() => this.Folder, ref folder, value);
            }
        }

        /// <summary>
        /// Run Grade tool.
        /// </summary>
        /// @return Run Grade tool.
        public string RunGrade
        {
            get
            {
                return runGrade;
            }
            set
            {
                if (value == null)
                {
                    value = "false";
                }
                Set<string>(() => this.RunGrade, ref runGrade, value);
            }
        }

        /// <summary>
        /// Run Tonnage tool.
        /// </summary>
        /// @return Run Tonnage tool.
        public string RunTonnage
        {
            get
            {
                return runTonnage;
            }
            set
            {
                if (value == null)
                {
                    value = "false";
                }
                Set<string>(() => this.RunTonnage, ref runTonnage, value);
            }
        }

        /// <summary>
        /// Run Grade-Tonnage tool.
        /// </summary>
        /// @return Run Grade-Tonnage tool.
        public string RunGradeTonnage
        {
            get
            {
                return runGradeTonnage;
            }
            set
            {
                if (value == null)
                {
                    value = "false";
                }
                Set<string>(() => this.RunGradeTonnage, ref runGradeTonnage, value);
            }
        }

        /// <summary>
        /// Model type.
        /// </summary>
        /// @return Model type.
        public string ModelType
        {
            get
            {
                return modelType;
            }
            set
            {
                if (value == null)
                {
                    value = "GT";
                }
                Set<string>(() => this.ModelType, ref modelType, value);
            }
        }

        /// <summary>
        /// Folder for result saving.
        /// </summary>
        /// @return Folder for result saving.
        public string ExtensionFolder
        {
            get
            {
                return extensionFolder;
            }
            set
            {
                if (value == null)
                {
                    value = "";
                }
                Set<string>(() => this.ExtensionFolder, ref extensionFolder, value);
            }
        }
    }
}
