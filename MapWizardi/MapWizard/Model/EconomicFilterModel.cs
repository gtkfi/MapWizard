using GalaSoft.MvvmLight;
using System;
using System.Collections.ObjectModel;

namespace MapWizard.Model
{
    /// <summary>
    /// Economic Filter Model
    /// </summary>
    public class EconomicFilterModel : ObservableObject
    {
        // Always initialized the same way.
        private bool isBusy;
        private int tabIndex = 0;
        private bool raefUseModelName = false;
        private bool screenerUseModelName = false;
        private int raefSelectedModelIndex = 0;
        private int screenerSelectedModelIndex = 0;
        private ObservableCollection<string> raefModelNames = new ObservableCollection<string>();
        private ObservableCollection<string> screenerModelNames = new ObservableCollection<string>();
        private ObservableCollection<string> metalIds;
        public ObservableCollection<string> perTypes = new ObservableCollection<string>() { "Count %", "Metal %" };
        // Not always initialized the same way.
        private string lastRunDate = "Last Run: Never";
        private string lastRunTract = "Tract: not run";
        private int runStatus = 2; // 0=error, 1=success, 2=not run yet.
        private string monteCarloResultTable = "Select file";
        private string selectedMetal;
        private string selectedMetalIndex;
        private string metalsToCalculate;
        private string perType;
        private string perCent;
        private string raefPackageFolder;
        private string raefPresetFile = "Choose file";
        private string raefEconFilterFile = "Choose file";
        private string raefExtensionFolder = "";
        private string screenerExtensionFolder = "";
        private ObservableCollection<string> tractIDNames = new ObservableCollection<string>();
        private string selectedTract;

        //42-49 on niitä CV ja MRR arvo-pareja kertaa x. DepthIntervalsien määrä? commodityjen/mineraalien määrä input filen mukaan?
        //nehän vedetään tosiaan jostain taulukosta, KS raefista miten kaivetaan.
        //noh, jos niitä on vaihteleva määrä niin niitä ei kannata sitten modeliin laittaa.


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
        /// Public property for RAEF model names.
        /// </summary>
        /// @return Collection of Raef run names.
        public ObservableCollection<string> RaefModelNames
        {
            get { return raefModelNames; }
            set
            {
                if (value == raefModelNames) return;
                raefModelNames = value;
            }
        }

        /// <summary>
        /// Public property for screener model names
        /// </summary>
        /// @return Collection of Raef run names.
        public ObservableCollection<string> ScreenerModelNames
        {
            get { return screenerModelNames; }
            set
            {
                if (value == screenerModelNames) return;
                screenerModelNames = value;
            }

        }

        /// <summary>
        /// Public tabindex property for the View to bind to.
        /// </summary>
        /// @return Bitmap.
        public int TabIndex
        {
            get { return tabIndex; }
            set
            {
                if (value == tabIndex) return;
                tabIndex = value;
                RaisePropertyChanged("TabIndex");
            }
        }

        /// <summary>
        /// Public property for Screener metal Ids
        /// </summary>
        /// @return ID collection.
        public ObservableCollection<string> MetalIds
        {
            get
            {
                return metalIds;
            }
            set
            {
                metalIds = value;
                RaisePropertyChanged("MetalIds");
            }
        }

        /// <summary>
        /// PerTypes.
        /// </summary>
        /// @return PerTypes.      
        public ObservableCollection<string> PerTypes
        {
            get
            {
                return perTypes;
            }
            set
            {
                perTypes = value;
                RaisePropertyChanged("PerTypes");
            }
        }

        /// <summary>
        /// Public property for whether Raef should use model name
        /// </summary>
        /// @return Boolean representing the choice.
        public bool RaefUseModelName
        {
            get { return raefUseModelName; }
            set
            {
                if (value == raefUseModelName) return;
                raefUseModelName = value;
                RaisePropertyChanged("RaefUseModelName");
            }
        }

        /// <summary>
        /// Public property for whether Screener should use model name
        /// </summary>
        /// @return Boolean representing the choice.
        public bool ScreenerUseModelName
        {
            get { return screenerUseModelName; }
            set
            {
                if (value == screenerUseModelName) return;
                screenerUseModelName = value;
                RaisePropertyChanged("ScreenerUseModelName");
            }
        }

        /// <summary>
        /// Public property indicating the selected RAEF model index, for the view to bind to.
        /// </summary>
        /// @return Boolean representing the choice.
        public int RaefSelectedModelIndex
        {
            get { return raefSelectedModelIndex; }
            set
            {
                if (value == raefSelectedModelIndex) return;
                raefSelectedModelIndex = value;
                RaisePropertyChanged("RaefSelectedModelIndex");
            }
        }

        /// <summary>
        ///  Public property indicating the selected screener model index, for the view to bind to.
        /// </summary>
        /// @return Boolean representing the choice.
        public int ScreenerSelectedModelIndex
        {
            get { return screenerSelectedModelIndex; }
            set
            {
                if (value == screenerSelectedModelIndex) return;
                screenerSelectedModelIndex = value;
                RaisePropertyChanged("ScreenerSelectedModelIndex");
            }
        }

        /// <summary>
        /// Raef package folder.
        /// </summary>
        /// @return Raef package folder.
        public string RaefPackageFolder
        {
            get
            {
                return raefPackageFolder;
            }
            set
            {
                Set<string>(() => this.RaefPackageFolder, ref raefPackageFolder, value);
            }
        }

        /// <summary>
        /// Raef preset file.
        /// </summary>
        /// @return Raef preset file.
        public string RaefPresetFile
        {
            get
            {
                return raefPresetFile;
            }
            set
            {
                if (String.IsNullOrEmpty(value))
                {
                    value = "Choose file";
                }
                Set<string>(() => this.RaefPresetFile, ref raefPresetFile, value);
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
        /// @return Boolean representing the state.
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
        /// Last run tractid.
        /// </summary>
        /// <returns>Date.</returns>
        public string LastRunTract
        {
            get { return lastRunTract; }
            set
            {
                if (value == lastRunTract) return;
                lastRunTract = value;
                RaisePropertyChanged("LastRunTract");
            }
        }

        /// <summary>
        /// Monte Carlo result table.
        /// </summary>
        /// @return Monte Carlo result table.
        public string MonteCarloResultTable
        {
            get
            {
                return monteCarloResultTable;
            }
            set
            {
                if(String.IsNullOrEmpty(value))
                    {
                    value = "Please select monte Carlo simulation result table";
                    MetalIds = null;
                }
                Set<string>(() => this.MonteCarloResultTable, ref monteCarloResultTable, value);
            }
        }

        /// <summary>
        /// Selected metal.
        /// </summary>
        /// @return Selected metal.
        public string SelectedMetal
        {
            get
            {
                return selectedMetal;
            }
            set
            {
                Set<string>(() => this.SelectedMetal, ref selectedMetal, value);
            }
        }

        /// <summary>
        /// Selected metal index.
        /// </summary>
        /// @return Selected metal index.
        public string SelectedMetalIndex
        {
            get
            {
                return selectedMetalIndex;
            }
            set
            {
                Set<string>(() => this.SelectedMetalIndex, ref selectedMetalIndex, value);
            }
        }

        /// <summary>
        /// Metals to calculate.
        /// </summary>
        /// @return Metals to calculate.
        public string MetalsToCalculate
        {
            get
            {
                return metalsToCalculate;
            }
            set
            {
                Set<string>(() => this.MetalsToCalculate, ref metalsToCalculate, value);
            }
        }

        /// <summary>
        /// Type.
        /// </summary>
        /// @return Type.
        public string PerType
        {
            get
            {
                return perType;
            }
            set
            {
                Set<string>(() => this.PerType, ref perType, value);
            }
        }

        /// <summary>
        /// Percentage.
        /// </summary>
        /// @return Percentage.
        public string PerCent
        {
            get
            {
                return perCent;
            }
            set
            {
                Set<string>(() => this.PerCent, ref perCent, value);
            }
        }

        /// <summary>
        /// Raef file.
        /// </summary>
        /// @return Raef file.
        public string RaefEconFilterFile
        {
            get
            {
                return raefEconFilterFile;
            }
            set
            {
                if (String.IsNullOrEmpty(value))
                {
                    value = "Choose file";
                }
                Set<string>(() => this.RaefEconFilterFile, ref raefEconFilterFile, value);
            }
        }

        /// <summary>
        /// Raef extension folder.
        /// </summary>
        /// @return Raef extension folder.
        public string RaefExtensionFolder
        {
            get
            {
                return raefExtensionFolder;
            }
            set
            {
                if (value == null)
                {
                    value = "";
                }
                Set<string>(() => this.RaefExtensionFolder, ref raefExtensionFolder, value);
            }
        }

        /// <summary>
        /// Screener extension folder.
        /// </summary>
        /// @return Screener extension folder.
        public string ScreenerExtensionFolder
        {
            get
            {
                return screenerExtensionFolder;
            }
            set
            {
                if (value == null)
                {
                    value = "";
                }
                Set<string>(() => this.ScreenerExtensionFolder, ref screenerExtensionFolder, value);
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

        private string raefRunName="";
        public string RaefRunName {
            get
            { return raefRunName; }
            set
            {
                if (value==raefRunName)
                    return;
                raefRunName = value;
                RaisePropertyChanged("RaefRunName");
            }
        } 
        public string RaefDepositType { get; set; } = "Flat-bedded/stratiform"; //
        public ObservableCollection<string> raefDepositTypeOptions = new ObservableCollection<string>() { "Flat-bedded/stratiform", "Ore body massive / disseminated", "Vein deposit / steep" };
        public ObservableCollection<string> RaefDepositTypeOptionsCollection
        {
            get
            {
                return raefDepositTypeOptions;
            }
            set
            {
                raefDepositTypeOptions = value;
                RaisePropertyChanged("RaefDepositTypeOptionsCollection");
            }
        }
        public string RaefMineMethod { get; set; } = "Open Pit"; //Tää määritetään depthin mukaan koneelisesti. jos depth =>61m: "Room and Pillar", jos depth <61m: "Open Pit". sit se pitäs selivttää että mikä depth se on. huoh.
        public string RaefMillType1 { get; set; } = "1 - Product Flotation"; //onko molemmille mill typeille samat optiot?
        public ObservableCollection<string> raefMillType1Options = new ObservableCollection<string>() {"1 - Product Flotation" , "2 - Product Flotation", "3 - Product Flotation", "3 - Product Flotation (Omit lowest value commodity", "Customize Mill Options", "None" };
        public ObservableCollection<string> RaefMillType1OptionsCollection
        {
            get
            {
                return raefMillType1Options;
            }
            set
            {
                raefMillType1Options = value;
                RaisePropertyChanged("RaefMillType1OptionsCollection");
            }
        }
        public string RaefMillType2 { get; set; } = "NA"; //
        public int RaefDaysOfOperation { get; set; } = 350; //
        public ObservableCollection<int> raefDaysOfOperationOptions = new ObservableCollection<int>() { 350,260};

        public string RaefEnvChoice1 { get; set; } = "NA"; //
        //public ObservableCollection<string> raefEnvChoice1Options = new ObservableCollection<string>() { "Customize Mill Options", "None" };

        public string RaefLiner { get; set; } = "NA"; //
        //public ObservableCollection<string> raefLinerOptions = new ObservableCollection<string>() { "Liner", "NA" };

        public double RaefMarshallSwiftCost { get; set; } = 1.26; 
        public double RaefInvestmentRateOfReturn { get; set; } = 0.15;
        public double RaefCapitalCostInflationFactor { get; set; } = 1;
        public double RaefOperatingCostInflationFactor { get; set; } = 1;
        private int raefArea = 0;
        public int RaefArea
        {
            get
            {
                return raefArea;
            }
            set
            {
                if (value == raefArea)
                    return;
                raefArea = value;
                RaisePropertyChanged("RaefArea");
            }
        }
        public string RaefMillName { get; set; } = "NONE";
        public double RaefMillCapitalConstant { get; set; } = 0;
        public double RaefMillCapitalLog { get; set; } = 0;
        public double RaefMillOperatingCostConstant { get; set; } = 0;
        public double RaefMillOperatingCostLog { get; set; } = 0;
        public string RaefCustomMillOption1 { get; set; } = "No set custom mill option for commodity #1";
        public string RaefCustomMillOption2 { get; set; } = "No set custom mill option for commodity #2";
        public string RaefCustomMillOption3 { get; set; } = "No set custom mill option for commodity #3";
        public string RaefCustomMillOption4 { get; set; } = "No set custom mill option for commodity #4";
        public string RaefCustomMillOption5 { get; set; } = "No set custom mill option for commodity #5";
        public string RaefCustomMillOption6 { get; set; } = "No set custom mill option for commodity #6";
        private int raefDepthIntervals = 1;
        public int RaefDepthIntervals
        {
            get
            {
                return raefDepthIntervals;
            }
            set
            {
                if (value == raefDepthIntervals)
                    return;
                raefDepthIntervals = value;
                RaisePropertyChanged("RaefDepthIntervals");
            }
        }
        public int RaefMin1 { get; set; } = 0;
        public int RaefMax1 { get; set; } = 0;
        public double RaefFract1 { get; set; } = 0;
        public int RaefMin2 { get; set; } = 0;
        public int RaefMax2 { get; set; } = 0;
        public double RaefFract2 { get; set; } = 0;
        public int RaefMin3 { get; set; } = 0;
        public int RaefMax3 { get; set; } = 0;
        public double RaefFract3 { get; set; } = 0;
        public int RaefMin4 { get; set; } = 0;
        public int RaefMax4 { get; set; } = 0;
        public double RaefFract4 { get; set; } = 0;
        private bool useRaefInputParams = true; //arvot GUI, Batch ja Empirical
        private string raefGTMFile = "Select grade-tonnage data file";
        private bool raefEmpiricalModel = false;
        public bool RaefEmpiricalModel
        {
            get { return raefEmpiricalModel; }
            set
            {
                if (value == raefEmpiricalModel)
                    return;
                raefEmpiricalModel = value;
                RaisePropertyChanged("RaefEmpiricalModel");
            }
        }
        public string RaefGTMFile
        {
            get { return raefGTMFile; }
            set
            {
                if (value == raefGTMFile)
                    return;
                raefGTMFile = value;
                RaisePropertyChanged("RaefGTMFile");
            }
        }

        /// <summary>
        /// Parameter for radiobutton in userInterface.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool UseRaefInputParams
        {
            get
            {
                return useRaefInputParams;
            }
            set
            {
                if (value == useRaefInputParams)
                    return;
                else
                {
                    useRaefInputParams = value;
                    RaisePropertyChanged("UseRaefInputParams");
                }
            }
        }
    }
}
