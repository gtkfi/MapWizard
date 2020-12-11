using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;

namespace MapWizard.Model
{
    /// <summary>
    /// Reporting model.
    /// </summary>
    public class ReportingModel : ObservableObject
    {
        // Always initialized the same way.
        private bool isBusy;
        // Not always initialized the same way.
        private string lastRunDate = "Last Run: Never";
        private int runStatus = 2;
        private string descModelPath = "-";
        private string gtModelPath = "-";
        private string descModelName = "-";
        private string gtModelName = "-";
        private bool addDescriptive = false;
        private bool addGradeTon = false;
        private bool enableDescCheck = false;
        private bool enableGTCheck = false;
        private string estimateRationale;
        private string isUndiscDepDone = "No";
        private string isRaefDone = "No";
        private string isScreenerDone = "No";
        private string depositType = "-";
        private string tractImageFile = "Choose image jpeg file";
        private string knownDepositsFile = "Choose Word file";
        private string prospectsOccurencesFile = "Choose Word file";
        private string explorationFile = "Choose Word file";
        private string sourcesFile = "Choose Word file";
        private string referencesFile = "Choose Word file";
        private ObservableCollection<string> tractIDNames = new ObservableCollection<string>();
        private string selectedTract;
        private string authors;
        private string country;
        private string asDate;
        private string asDepth;
        private string asLeader;
        private string asTeamMembers;

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
        /// Status for the tool that shows if the tool ran correctly last time.
        /// </summary>
        /// <returns>Integer representing the status.</returns>
        public int RunStatus
        {
            get { return runStatus; }
            set
            {
                if (value == runStatus) return;
                runStatus = value;
                RaisePropertyChanged();
            }
        }

        /// <summary>
        /// Gets the last run time of the tool.
        /// </summary>
        /// <returns>Date and time of the last run.</returns>
        public string LastRunDate
        {
            get { return lastRunDate; }
            set
            {
                if (value == lastRunDate) return;
                lastRunDate = value;
                RaisePropertyChanged();
            }
        }

        /// <summary>
        /// Chosen model from Descriptive tool.
        /// </summary>
        /// @return Model path.
        public string DescModelPath
        {
            get
            {
                return descModelPath;
            }
            set
            {
                if (value == null)
                {
                    value = "-";
                }
                Set<string>(() => this.DescModelPath, ref descModelPath, value);
            }
        }

        /// <summary>
        /// Chosen model from GradeTonnage tool.
        /// </summary>
        /// @return Model path.
        public string GTModelPath
        {
            get
            {
                return gtModelPath;
            }
            set
            {
                if (value == null)
                {
                    value = "-";
                }
                Set<string>(() => this.GTModelPath, ref gtModelPath, value);
            }
        }

        /// <summary>
        /// Name of the chosen model from Descriptive tool.
        /// </summary>
        /// @return Model name.
        public string DescModelName
        {
            get
            {
                return descModelName;
            }
            set
            {
                if (value == null)
                {
                    value = "-";
                    EnableDescCheck = false;
                }
                else
                {
                    EnableDescCheck = true;
                }
                Set<string>(() => this.DescModelName, ref descModelName, value);
            }
        }

        /// <summary>
        /// Name of the chosen model from GradeTonnage tool.
        /// </summary>
        /// @return Model name.
        public string GTModelName
        {
            get
            {
                return gtModelName;
            }
            set
            {
                if (value == null)
                {
                    value = "-";
                    EnableGTCheck = false;
                }
                else
                {
                    EnableGTCheck = true;
                }
                Set<string>(() => this.GTModelName, ref gtModelName, value);
            }
        }

        /// <summary>
        /// Determines if the Descriptive model will be added.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool AddDescriptive
        {
            get
            {
                return addDescriptive;
            }
            set
            {
                Set<bool>(() => this.AddDescriptive, ref addDescriptive, value);
            }
        }

        /// <summary>
        /// Determines if the Grade-Tonnage model will be added.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool AddGradeTon
        {
            get
            {
                return addGradeTon;
            }
            set
            {
                Set<bool>(() => this.AddGradeTon, ref addGradeTon, value);
            }
        }

        /// <summary>
        /// Determines if the Descriptive model will be added.
        /// </summary>
        /// @return Boolean representing the state.
        public bool EnableDescCheck
        {
            get
            {
                return enableDescCheck;
            }
            set
            {
                Set<bool>(() => this.EnableDescCheck, ref enableDescCheck, value);
            }
        }

        /// <summary>
        /// Determines if the Grade-Tonnage model will be added.
        /// </summary>
        /// @return Boolean representing the state.
        public bool EnableGTCheck
        {
            get
            {
                return enableGTCheck;
            }
            set
            {
                Set<bool>(() => this.EnableGTCheck, ref enableGTCheck, value);
            }
        }

        /// <summary>
        /// Rationale for the estimate of the number of undiscovered deposits.
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
        /// Defines if all the files for the report are in SelectResult folder.
        /// </summary>
        /// @return Tells that which method was used when running the tool.
        public string IsUndiscDepDone
        {
            get
            {
                return isUndiscDepDone;
            }
            set
            {
                if (value == null)
                {
                    value = "No";
                }
                Set<string>(() => this.IsUndiscDepDone, ref isUndiscDepDone, value);
            }
        }

        /// <summary>
        /// Defines if all the files for the report are in SelectResult folder.
        /// </summary>
        /// @return 'No' or 'Yes'.
        public string IsRaefDone
        {
            get
            {
                return isRaefDone;
            }
            set
            {
                if (value == null)
                {
                    value = "No";
                }
                Set<string>(() => this.IsRaefDone, ref isRaefDone, value);
            }
        }

        /// <summary>
        /// Defines if all the files for the report are in SelectResult folder.
        /// </summary>
        /// @return 'No' or 'Yes'.
        public string IsScreenerDone
        {
            get
            {
                return isScreenerDone;
            }
            set
            {
                if (value == null)
                {
                    value = "No";
                }
                Set<string>(() => this.IsScreenerDone, ref isScreenerDone, value);
            }
        }

        /// <summary>
        /// Deposit type of the project.
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
                if (value == null)
                {
                    value = "-";
                }
                Set<string>(() => this.DepositType, ref depositType, value);
            }
        }

        /// <summary>
        /// Tract image file.
        /// </summary>
        /// @return Tract image file.
        public string TractImageFile
        {
            get
            {
                return tractImageFile;
            }
            set
            {
                if (value == null)
                {
                    value = "Choose image file";
                }
                Set<string>(() => this.TractImageFile, ref tractImageFile, value);
            }
        }

        /// <summary>
        /// Known Deposits file.
        /// </summary>
        /// @return Known Deposits file.
        public string KnownDepositsFile
        {
            get
            {
                return knownDepositsFile;
            }
            set
            {
                if (value == null)
                {
                    value = "Choose Word file";
                }
                Set<string>(() => this.KnownDepositsFile, ref knownDepositsFile, value);
            }
        }

        /// <summary>
        /// Prospects and occurences file.
        /// </summary>
        /// @return Prospects and occurences file.
        public string ProspectsOccurencesFile
        {
            get
            {
                return prospectsOccurencesFile;
            }
            set
            {
                if (value == null)
                {
                    value = "Choose Word file";
                }
                Set<string>(() => this.ProspectsOccurencesFile, ref prospectsOccurencesFile, value);
            }
        }

        /// <summary>
        /// Exploration file.
        /// </summary>
        /// @return Exploration file.
        public string ExplorationFile
        {
            get
            {
                return explorationFile;
            }
            set
            {
                Set<string>(() => this.ExplorationFile, ref explorationFile, value);
            }
        }

        /// <summary>
        /// Sources file.
        /// </summary>
        /// @return Sources file.
        public string SourcesFile
        {
            get
            {
                return sourcesFile;
            }
            set
            {
                if (value == null)
                {
                    value = "Choose Word file";
                }
                Set<string>(() => this.SourcesFile, ref sourcesFile, value);
            }
        }

        /// <summary>
        /// References file.
        /// </summary>
        /// @return References file.
        public string ReferencesFile
        {
            get
            {
                return referencesFile;
            }
            set
            {
                if (value == null)
                {
                    value = "Choose Word file";
                }
                Set<string>(() => this.ReferencesFile, ref referencesFile, value);
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
        /// Selected tract from TractID Collection.
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

        /// <summary>
        /// Authors.
        /// </summary>
        /// @return Authors.
        public string Authors
        {
            get
            {
                return authors;
            }
            set
            {
                Set<string>(() => this.Authors, ref authors, value);
            }
        }

        /// <summary>
        /// Country.
        /// </summary>
        /// @return Country.
        public string Country
        {
            get
            {
                return country;
            }
            set
            {
                Set<string>(() => this.Country, ref country, value);
            }
        }

        /// <summary>
        /// Assesment date.
        /// </summary>
        /// @return Assesment date.
        public string AsDate
        {
            get
            {
                return asDate;
            }
            set
            {
                Set<string>(() => this.AsDate, ref asDate, value);
            }
        }

        /// <summary>
        /// Assesment depth.
        /// </summary>
        /// @return Assesment depth.
        public string AsDepth
        {
            get
            {
                return asDepth;
            }
            set
            {
                Set<string>(() => this.AsDepth, ref asDepth, value);
            }
        }

        /// <summary>
        /// Assesment leader.
        /// </summary>
        /// @return Assesment leader.
        public string AsLeader
        {
            get
            {
                return asLeader;
            }
            set
            {
                Set<string>(() => this.AsLeader, ref asLeader, value);
            }
        }

        /// <summary>
        /// Assesment team members.
        /// </summary>
        /// @return Assesment team members.
        public string AsTeamMembers
        {
            get
            {
                return asTeamMembers;
            }
            set
            {
                Set<string>(() => this.AsTeamMembers, ref asTeamMembers, value);
            }
        }
    }
}
