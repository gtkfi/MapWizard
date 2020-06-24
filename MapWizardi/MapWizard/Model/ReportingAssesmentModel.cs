using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;

namespace MapWizard.Model
{
    /// <summary>
    /// Reporting assesment model.
    /// </summary>
    public class ReportingAssesmentModel : ObservableObject
    {
        // Always initialized the same way.
        private bool isBusy;
        // Not always initialized the same way.
        private string descModelPath = "-";
        private string gtModelPath = "-";
        private string raefFilePath = "-";
        private string descModelName = "-";
        private string gtModelName = "-";
        private string raefFileName = "-";
        private bool addDescriptive = false;
        private bool addGradeTon = false;
        private bool addRaef = false;
        private bool enableDescCheck = false;
        private bool enableGTCheck = false;
        private bool enableRaefCheck = false;
        private string isUndiscDepDone = "No";
        private string isRaefDone = "No";
        private string isScreenerDone = "No";
        private string depositType = "-";
        private string tractImageFile = "Choose image file";
        private ObservableCollection<ReportingAssesmentModel> tractIDCollection = new ObservableCollection<ReportingAssesmentModel>();
        private ObservableCollection<string> tractIDNames = new ObservableCollection<string>();
        private ObservableCollection<string> combinedTracts = new ObservableCollection<string>();
        private ObservableCollection<string> tractIDChoices = new ObservableCollection<string>();
        private string tractName;
        private bool isTractChosen;
        private string assesmentTitle;
        private string selectedTractCombination;
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
        /// Chosen RAEF result file from Economic Filter tool.
        /// </summary>
        /// @return Model path.
        public string RaefFilePath
        {
            get
            {
                return raefFilePath;
            }
            set
            {
                if (value == null)
                {
                    value = "-";
                }
                Set<string>(() => this.RaefFilePath, ref raefFilePath, value);
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
        /// Name of the chosen RAEF result file from Economic Filter tool.
        /// </summary>
        /// @return Model name.
        public string RaefFileName
        {
            get
            {
                return raefFileName;
            }
            set
            {
                if (value == null)
                {
                    value = "-";
                    EnableRaefCheck = false;
                }
                else
                {
                    EnableRaefCheck = true;
                }
                Set<string>(() => this.RaefFileName, ref raefFileName, value);
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
        /// Determines if the Economic Filter Raef result file will be added.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool AddRaef
        {
            get
            {
                return addRaef;
            }
            set
            {
                Set<bool>(() => this.AddRaef, ref addRaef, value);
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
        /// Determines if the Economic Filter Raef result file will be added.
        /// </summary>
        /// @return Boolean representing the state.
        public bool EnableRaefCheck
        {
            get
            {
                return enableRaefCheck;
            }
            set
            {
                Set<bool>(() => this.EnableRaefCheck, ref enableRaefCheck, value);
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
        /// TractID collection.
        /// </summary>
        /// @return TractID collection.
        public ObservableCollection<ReportingAssesmentModel> TractIDCollection
        {
            get
            {
                return tractIDCollection;
            }
            set
            {
                if (value == null)
                {
                    value = new ObservableCollection<ReportingAssesmentModel>();
                }
                Set<ObservableCollection<ReportingAssesmentModel>>(() => this.TractIDCollection, ref tractIDCollection, value);
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
        /// Collection of combined tracts.
        /// </summary>
        /// @return TractID collection.
        public ObservableCollection<string> CombinedTracts
        {
            get
            {
                return combinedTracts;
            }
            set
            {
                if (value == null)
                {
                    value = new ObservableCollection<string>();
                }
                Set<ObservableCollection<string>>(() => this.CombinedTracts, ref combinedTracts, value);
            }
        }

        /// <summary>
        /// TractID collection.
        /// </summary>
        /// @return TractID collection.
        public ObservableCollection<string> TractIDChoices
        {
            get
            {
                return tractIDChoices;
            }
            set
            {
                if (value == null)
                {
                    value = new ObservableCollection<string>();
                }
                Set<ObservableCollection<string>>(() => this.TractIDChoices, ref tractIDChoices, value);
            }
        }

        /// <summary>
        /// Name of the tract. Used by TractIDNames collection.
        /// </summary>
        /// @return Tract name.
        public string TractName
        {
            get
            {
                return tractName;
            }
            set
            {
                Set<string>(() => this.TractName, ref tractName, value);
            }
        }

        /// <summary>
        /// Defines if the tract is chosen. Used by TractIDNames collection.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool IsTractChosen
        {
            get
            {
                return isTractChosen;
            }
            set
            {
                Set<bool>(() => this.IsTractChosen, ref isTractChosen, value);
            }
        }

        /// <summary>
        /// Assesment title.
        /// </summary>
        /// @return Assesment title.
        public string AssesmentTitle
        {
            get
            {
                return assesmentTitle;
            }
            set
            {
                Set<string>(() => this.AssesmentTitle, ref assesmentTitle, value);
            }
        }

        /// <summary>
        /// Selected tract combination from CombinedTracts Collection.
        /// </summary>
        /// @return Index.
        public string SelectedTractCombination
        {
            get
            {
                return selectedTractCombination;
            }
            set
            {
                Set<string>(() => this.SelectedTractCombination, ref selectedTractCombination, value);
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
