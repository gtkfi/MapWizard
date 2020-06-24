using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;

namespace MapWizard.Model
{
    /// <summary>
    /// Umdiscovered deposits model
    /// </summary>
    public class UndiscoveredDepositsModel : ObservableObject
    {
        // Always initialized the same way.
        private bool isBusy;
        private bool negBinomialUseModelName = false;
        private bool mark3UseModelName = false;
        private bool customUseModelName = false;
        private int selectedModelIndex = 0;
        private ObservableCollection<string> modelNames = new ObservableCollection<string>();
        // Not always initialized the same way.
        private string lastRunDate = "Last Run: Never";
        private int runStatus = 2;
        private string depositsCsvString = "Name,Weight,N90,N50,N10";
        private string customFunctionCsvString;
        private string estName;
        private string estWeight;
        private string estN90;
        private string estN50;
        private string estN10;
        private string estN5;
        private string estN1;
        private string nDeposits;
        private string probability;
        private string tractId;
        private string negBinomialExtensionFolder;
        private string mark3ExtensionFolder;
        private string customExtensionFolder;
        private string estimateRationale;
        private string customEstimateRationale;
        private string mark3EstimateRationale;
        private int selectedTabIndex;
        private ObservableCollection<string> tractIDNames = new ObservableCollection<string>();
        private string selectedTract;

        /// <summary>
        /// Is busy?
        /// </summary>
        /// <returns>Boolean representing the state.</returns>
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
        /// Whether to use a name for Neg. Binomial model.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool NegBinomialUseModelName
        {
            get { return negBinomialUseModelName; }
            set
            {
                if (value == negBinomialUseModelName) return;
                negBinomialUseModelName = value;
                RaisePropertyChanged("NegBinomialUseModelName");
            }
        }

        /// <summary>
        ///  Whether to use a name for Mark3 model.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool Mark3UseModelName
        {
            get { return mark3UseModelName; }
            set
            {
                if (value == mark3UseModelName) return;
                mark3UseModelName = value;
                RaisePropertyChanged("Mark3UseModelName");
            }
        }

        /// <summary>
        /// Whether to use a name for Custom model
        /// </summary>
        /// @return Boolean representing the choice.
        public bool CustomUseModelName
        {
            get { return customUseModelName; }
            set
            {
                if (value == customUseModelName) return;
                customUseModelName = value;
                RaisePropertyChanged("CustomUseModelName");
            }
        }

        /// <summary>
        /// Public property for index of selected model, for View to bind to.
        /// </summary>
        /// @return Collection of model names.
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
        /// Collection containing names of previously ran models for model selection.
        /// </summary>
        /// @return Collection of model names.
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
        /// Whether last run has been succesful, failed or the tool has not been run yet on this project.
        /// </summary>
        /// <returns>Integer representing the status.</returns>
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
        /// <returns>Date.</returns>
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
        /// Deposits csv string. Define "Negative binomial function" -input csv file content.
        /// </summary>
        /// @return Csv string.
        public string DepositsCsvString
        {
            get
            {
                return depositsCsvString;
            }
            set
            {
                if(value == null)
                {
                    value = "Name,Weight,N90,N50,N10";
                }
                Set<string>(() => this.DepositsCsvString, ref depositsCsvString, value);
            }
        }

        /// <summary>
        /// Deposits custom function csv string. Define "Custom function" -input csv file content.
        /// </summary>
        /// @return Csv string.
        public string CustomFunctionCsvString
        {
            get
            {
                return customFunctionCsvString;
            }
            set
            {
                Set<string>(() => this.CustomFunctionCsvString, ref customFunctionCsvString, value);
            }
        }

        /// <summary>
        /// Estimated name.
        /// </summary>
        /// @return Estimated name.
        public string EstName
        {
            get
            {
                return estName;
            }
            set
            {
                Set<string>(() => this.EstName, ref estName, value);
            }
        }

        /// <summary>
        /// Estimated weight.
        /// </summary>
        /// @return Estimated weight.
        public string EstWeight
        {
            get
            {
                return estWeight;
            }
            set
            {
                Set<string>(() => this.EstWeight, ref estWeight, value);
            }
        }

        /// <summary>
        /// Estimated N90.
        /// </summary>
        /// @return Estimated N90.
        public string EstN90
        {
            get
            {
                return estN90;
            }
            set
            {
                Set<string>(() => this.EstN90, ref estN90, value);
            }
        }

        /// <summary>
        /// Estimated N50.
        /// </summary>
        /// @return Estimated N50.
        public string EstN50
        {
            get
            {
                return estN50;
            }
            set
            {
                Set<string>(() => this.EstN50, ref estN50, value);
            }
        }

        /// <summary>
        /// Estimated N10.
        /// </summary>
        /// @return Estimated N10.
        public string EstN10
        {
            get
            {
                return estN10;
            }
            set
            {
                Set<string>(() => this.EstN10, ref estN10, value);
            }
        }

        /// <summary>
        /// Estimated N5.
        /// </summary>
        /// @return Estimated N5.
        public string EstN5
        {
            get
            {
                return estN5;
            }
            set
            {
                Set<string>(() => this.EstN5, ref estN5, value);
            }
        }

        /// <summary>
        /// Estimated N10.
        /// </summary>
        /// @return Estimated N10.
        public string EstN1
        {
            get
            {
                return estN1;
            }
            set
            {
                Set<string>(() => this.EstN1, ref estN1, value);
            }
        }

        /// <summary>
        /// Number of deposits, custom estimation.
        /// </summary>
        /// @return Number of deposits.
        public string NDeposits
        {
            get
            {
                return nDeposits;
            }
            set
            {
                Set<string>(() => this.NDeposits, ref nDeposits, value);
            }
        }

        /// <summary>
        /// Probability.
        /// </summary>
        /// @return Probability.
        public string Probability
        {
            get
            {
                return probability;
            }
            set
            {
                Set<string>(() => this.Probability, ref probability, value);
            }
        }

        /// <summary>
        /// Tract ID.
        /// </summary>
        /// @return Tract ID.
        public string TractId
        {
            get
            {
                return tractId;
            }
            set
            {
                Set<string>(() => this.TractId, ref tractId, value);
            }
        }
        
        /// <summary>
        /// Extension folder for negative binomial.
        /// </summary>
        /// @return Folder.
        public string NegBinomialExtensionFolder
        {
            get
            {
                return negBinomialExtensionFolder;
            }
            set
            {
                Set<string>(() => this.NegBinomialExtensionFolder, ref negBinomialExtensionFolder, value);
            }
        }
        
        /// <summary>
        /// Extension folder for MARK3.
        /// </summary>
        /// @return Folder.
        public string Mark3ExtensionFolder
        {
            get
            {
                return mark3ExtensionFolder;
            }
            set
            {
                Set<string>(() => this.Mark3ExtensionFolder, ref mark3ExtensionFolder, value);
            }
        }
        
        /// <summary>
        /// Extension folder for custom.
        /// </summary>
        /// @return Folder.
        public string CustomExtensionFolder
        {
            get
            {
                return customExtensionFolder;
            }
            set
            {
                Set<string>(() => this.CustomExtensionFolder, ref customExtensionFolder, value);
            }
        }

        /// <summary>
        /// Explanation for negative binomial estimates.
        /// </summary>
        /// @return Estimate rationale.
        public string EstimateRationale
        {
            get
            {
                return estimateRationale;
            }
            set
            {
                Set<string>(() => this.EstimateRationale, ref estimateRationale, value);
            }
        }

        /// <summary>
        /// Explanation for MARK3 estimates
        /// </summary>
        /// @return Estimate rationale.
        public string MARK3EstimateRationale
        {
            get
            {
                return mark3EstimateRationale;
            }
            set
            {
                Set<string>(() => this.MARK3EstimateRationale, ref mark3EstimateRationale, value);
            }
        }

        /// <summary>
        /// Explanation for custom estimates
        /// </summary>
        /// @return Estimate rationale.
        public string CustomEstimateRationale
        {
            get
            {
                return customEstimateRationale;
            }
            set
            {
                Set<string>(() => this.CustomEstimateRationale, ref customEstimateRationale, value);
            }
        }

        /// <summary>
        /// Defines which tab is selected.
        /// </summary>
        /// @return Tab index.
        public int SelectedTabIndex
        {
            get
            {
                return selectedTabIndex;
            }
            set
            {
                selectedTabIndex = value;
            }
        }

        /// <summary>
        /// TractID collection.
        /// </summary>
        /// @return TractID collection.
        public ObservableCollection<string> TractIDNames
        {
            get
            {
                return tractIDNames;
            }
            set
            {
                if (value == null)
                {
                    value = new ObservableCollection<string>();
                }
                Set<ObservableCollection<string>>(() => this.TractIDNames, ref tractIDNames, value);
            }
        }

        /// <summary>
        /// Selected index of TractID Collection.
        /// </summary>
        /// @return Index.
        public string SelectedTract
        {
            get
            {
                return selectedTract;
            }
            set
            {
                Set<string>(() => this.SelectedTract, ref selectedTract, value);
            }
        }
    }
}
