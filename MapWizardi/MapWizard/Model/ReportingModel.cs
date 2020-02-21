using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;

namespace MapWizard.Model
{
    /// <summary>
    /// Reporting model.
    /// </summary>
    public class ReportingModel : ObservableObject
    {
        private string descModelPath;
        private string gtModelPath;
        private string descModelName;
        private string gtModelName;
        private bool addDescriptive;
        private bool addGradeTon;
        private bool enableDescCheck;
        private bool enableGTCheck;
        private string estimateRationale;
        private string isUndiscDepDone;
        private string isRaefDone;
        private string isScreenerDone;
        private string depositType;
        private string tractCriteriaFile;
        private string tractImageFile;
        private string knownDepositsFile;
        private string prospectsOccurencesFile;
        private string explorationFile;
        private string sourcesFile;
        private string referencesFile;
        private ObservableCollection<string> tractIDNames;
        private string selectedTractIndex;
        private string authors;
        private string country;
        private string asDate;
        private string asDepth;
        private string asLeader;
        private string asTeamMembers;

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
                Set<string>(() => this.DepositType, ref depositType, value);
            }
        }

        /// <summary>
        /// Tract criteria file.
        /// </summary>
        /// @return Tract criteria file.
        public string TractCriteriaFile
        {
            get
            {
                return tractCriteriaFile;
            }
            set
            {
                Set<string>(() => this.TractCriteriaFile, ref tractCriteriaFile, value);
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
                Set<ObservableCollection<string>>(() => this.TractIDNames, ref tractIDNames, value);
            }
        }

        /// <summary>
        /// Selected index of TractID Collection.
        /// </summary>
        /// @return Index.
        public string SelectedTractIndex
        {
            get
            {
                return selectedTractIndex;
            }
            set
            {
                Set<string>(() => this.SelectedTractIndex, ref selectedTractIndex, value);
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
