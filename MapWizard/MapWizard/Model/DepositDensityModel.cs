using System.Collections.ObjectModel;
using GalaSoft.MvvmLight;


namespace MapWizard.Model
{
    /// <summary>
    /// Observable object for DepositDensityModel
    /// </summary>
    public class DepositDensityModel : ObservableObject
    {
        private bool isBusy;
        private string lastRunDate = "Last Run: Never";
        private int runStatus = 2;
        private string n10;
        private string n50;
        private string n90;
        private string note;
        private double medianTonnage = 0;
        private double areaOfPermissiveTract = 0;
        private int numbOfKnownDeposits = 0;
        private string existingDepositDensityModelID;
        private string csvPath = "Choose *.csv file";
        private ObservableCollection<string> tractIDNames = new ObservableCollection<string>();
        private string selectedTract;

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
            }
        }

        /// <summary>
        /// Last run's N10.
        /// </summary>
        /// @return N10.
        public string N10
        {
            get
            {
                return n10;
            }
            set
            {
                Set<string>(() => this.N10, ref n10, value);
            }
        }

        /// <summary>
        /// Last run's N50.
        /// </summary>
        /// @return N50.
        public string N50
        {
            get
            {
                return n50;
            }
            set
            {
                Set<string>(() => this.N50, ref n50, value);
            }
        }

        /// <summary>
        /// Last run's N90.
        /// </summary>
        /// @return N90.
        public string N90
        {
            get
            {
                return n90;
            }
            set
            {
                Set<string>(() => this.N90, ref n90, value);
            }
        }

        /// <summary>
        /// Last run's Note. If there was a note.
        /// </summary>
        /// @return Note.
        public string Note
        {
            get
            {
                return note;
            }
            set
            {
                Set<string>(() => this.Note, ref note, value);
            }
        }

        /// <summary>
        /// Median tonnage.
        /// </summary>
        /// @return Median tonnage.
        public double MedianTonnage
        {
            get
            {
                return medianTonnage;
            }
            set
            {
                Set<double>(() => this.MedianTonnage, ref medianTonnage, value);
            }
        }

        /// <summary>
        /// Returns area of Permissive Tract.
        /// </summary>
        /// @return Area of Permissive Tract.
        public double AreaOfPermissiveTract
        {
            get
            {
                return areaOfPermissiveTract;
            }
            set
            {
                Set<double>(() => this.AreaOfPermissiveTract, ref areaOfPermissiveTract, value);
            }
        }

        /// <summary>
        /// Number of known deposits.
        /// </summary>
        /// @return  Number of known deposits.
        public int NumbOfKnownDeposits
        {
            get
            {
                return numbOfKnownDeposits;
            }
            set
            {
                Set<int>(() => this.NumbOfKnownDeposits, ref numbOfKnownDeposits, value);
            }
        }

        /// <summary>
        /// Existing deposit density model id.
        /// </summary>
        /// @return ID.
        public string ExistingDepositDensityModelID
        {
            get
            {
                return existingDepositDensityModelID;
            }
            set
            {
                Set<string>(() => this.ExistingDepositDensityModelID, ref existingDepositDensityModelID, value);
            }
        }

        /// <summary>
        /// Path to .csv file.
        /// </summary>
        /// @return Path to .csv file.
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
                    value = "Choose *.csv file";
                }                
                Set<string>(() => this.CSVPath, ref csvPath, value);
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
