using GalaSoft.MvvmLight;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace MapWizard.Model
{ 
    /// <summary>
    /// TractAggregationModel
    /// </summary>
    public class TractAggregationModel : ObservableObject
    {
        private bool isBusy;
        private ObservableCollection<string> combineFilesList = new ObservableCollection<string>();
        private ObservableCollection<TractAggregationDataModel> tractIDCollection = new ObservableCollection<TractAggregationDataModel>();
        private ObservableCollection<TractAggregationDataModel> tractPairRow = new ObservableCollection<TractAggregationDataModel>();
        private int runStatus = 2;  // 0=error, 1=success, 2=not run yet.
        private string lastRunDate = "Last Run: Never";
        private string correlationMatrix = "Choose file";
        private string testName = "";
        private string workingDir = "Choose folder";
        private string probDistFile = "Choose file";
        private bool createInputFile;
        private bool createCorrelationMatrix;
        private bool useInputParams = true; //arvot GUI, Batch ja Empirical
        private bool openComboBoxMenu = false;
        private string tractCombinationName = "";
        /// <summary>
        /// Whether tool is busy or not.
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
        /// Collection containing a list of files for when probability distribution file is created from separate files.
        /// </summary>
        /// @return File list.
        public ObservableCollection<string> CombineFilesList
        {
            get
            {
                return combineFilesList;
            }
            set
            {
                if (value == combineFilesList) return;
                combineFilesList = value;
            }
        }

        /// <summary>
        /// Collection containing tractIDs and boolean values representing if the tract is chosen.
        /// </summary>
        /// @return Tract ID collection.
        public ObservableCollection<TractAggregationDataModel> TractIDCollection
        {
            get
            {
                return tractIDCollection;
            }
            set
            {
                Set<ObservableCollection<TractAggregationDataModel>>(() => this.TractIDCollection, ref tractIDCollection, value);
            }
        }

        /// <summary>
        /// Collection containing tract columns, which each contain tract pair.
        /// </summary>
        /// @return Tract ID collection.
        public ObservableCollection<TractAggregationDataModel> TractPairRow
        {
            get
            {
                return tractPairRow;
            }
            set
            {
                Set<ObservableCollection<TractAggregationDataModel>>(() => this.TractPairRow, ref tractPairRow, value);
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
                RaisePropertyChanged("LastRunDate");
            }
        }

        /// <summary>
        /// Correlation matrix.
        /// </summary>
        /// @return Correlation matrix.
        public string CorrelationMatrix
        {
            get
            {
                return correlationMatrix;
            }
            set
            {
                if (value == null)
                {
                    value = "Choose file";
                }
                Set<string>(() => this.CorrelationMatrix, ref correlationMatrix, value);
            }
        }

        /// <summary>
        /// Test name.
        /// </summary>
        /// @return Test name.
        public string TestName
        {
            get
            {
                return testName;
            }
            set
            {
                if (value == null)
                {
                    value = "";
                }
                Set<string>(() => this.TestName, ref testName, value);
            }
        }

        /// <summary>
        /// Working directory.
        /// </summary>
        /// @return Working directory.
        public string WorkingDir
        {
            get
            {
                return workingDir;
            }
            set
            {
                if (value == null)
                {
                    value = "Choose folder";
                }
                Set<string>(() => this.WorkingDir, ref workingDir, value);
            }
        }

        /// <summary>
        /// Propability file.
        /// </summary>
        /// @return Propability file.
        public string ProbDistFile
        {
            get
            {
                return probDistFile;
            }
            set
            {
                if (value == null)
                {
                    value = "Choose file";
                }
                Set<string>(() => this.ProbDistFile, ref probDistFile, value);
            }
        }

        /// <summary>
        /// Tract Combination Name
        /// </summary>
        /// @return Propability file.
        public string TractCombinationName
        {
            get
            {
                return tractCombinationName;
            }
            set
            {
                if (value == null)
                {
                    value = "";
                }
                Set<string>(() => this.TractCombinationName, ref tractCombinationName, value);
            }
        }

        /// <summary>
        /// Input file creation.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool CreateCorrelationMatrix
        {
            get
            {
                return createInputFile;
            }
            set
            {
                Set<bool>(() => this.CreateCorrelationMatrix, ref createCorrelationMatrix, value);
            }
        }
        /// <summary>
        /// Input file creation.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool CreateInputFile
        {
            get
            {
                return createInputFile;
            }
            set
            {
                Set<bool>(() => this.CreateInputFile, ref createInputFile, value);
            }
        }

        /// <summary>
        /// Parameter for radiobutton in user interface.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool UseInputParams
        {
            get
            {
                return useInputParams;
            }
            set
            {
                if (value == useInputParams)
                    return;
                else
                {
                    useInputParams = value;
                    RaisePropertyChanged("UseInputParams");
                }
            }
        }
    }
}
