using System.Collections.ObjectModel;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// MonteCarloSimulationModel.
    /// </summary>
    public class MonteCarloSimulationModel : ObservableObject
    {
        // Always initialized the same way.
        private bool isBusy;
        private bool useModelName = false;
        private string extensionFolder = "";
        private int selectedModelIndex = 0;
        private ObservableCollection<string> modelNames = new ObservableCollection<string>();
        // Not always initialized the same way.
        private string lastRunDate = "Last Run: Never";
        private string lastRunTract = "Tract: not run";
        private int runStatus = 2; // 0=error, 1=success, 2=not run yet.
        private string gradePlot = "Select grade pdf";
        private string tonnagePlot = "Select tonnage pdf";
        private string gradeTonnagePlot = "Select joint grade-tonnage pdf";
        private string nDepositsPmf = "Select number of deposits pmf";
        private ObservableCollection<string> tractIDNames = new ObservableCollection<string>();
        private string selectedTract;
        private ObservableCollection<string> tractIDNamesFromMC = new ObservableCollection<string>();
        private string selectedSimulation;

        /// <summary>
        /// Is busy?.
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
        /// Whether to save result in separate folder.
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
        /// Run status.
        /// </summary>
        /// @return Boolean representing the state.
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
        /// Date and time of last run.
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
        /// Grade image file.
        /// </summary>
        /// @return Grade Plot.
        public string GradePlot
        {
            get
            {
                return gradePlot;
            }
            set
            {
                if (value == null || value == "")
                {
                    value = "Select grade pdf";
                }
                Set<string>(() => this.GradePlot, ref gradePlot, value);
            }
        }

        /// <summary>
        /// Tonnage Pdf.
        /// </summary>
        /// @return Tonnage Pdf.
        public string TonnagePlot
        {
            get
            {
                return tonnagePlot;
            }
            set
            {
                if (value == null || value == "")
                {
                    value = "Select tonnage pdf";
                }
                Set<string>(() => this.TonnagePlot, ref tonnagePlot, value);
            }
        }

        /// <summary>
        /// Grade-Tonnage Pdf.
        /// </summary>
        /// @return Grade-Tonnage Pdf.
        public string GradeTonnagePlot
        {
            get
            {
                return gradeTonnagePlot;
            }
            set
            {
                if (value == null || value == "")
                {
                    value = "Select joint grade-tonnage pdf";
                }
                Set<string>(() => this.GradeTonnagePlot, ref gradeTonnagePlot, value);
            }
        }

        /// <summary>
        /// NDepositsPmf.
        /// </summary>
        /// @return NDepositsPmf.
        public string NDepositsPmf
        {
            get
            {
                return nDepositsPmf;
            }
            set
            {
                if (value == null)
                {
                    value = "Please select NDepositsPmf object";
                }
                Set<string>(() => this.NDepositsPmf, ref nDepositsPmf, value);
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
        /// Selected TractID.
        /// </summary>
        /// @return string.
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
        /// TractID collection produced by MC.
        /// </summary>
        /// @return TractID collection.
        public ObservableCollection<string> TractIDNamesFromMC
        {
            get
            {
                return tractIDNamesFromMC;
            }
            set
            {
                if (value == null)
                {
                    value = new ObservableCollection<string>();
                }
                Set<ObservableCollection<string>>(() => this.TractIDNamesFromMC, ref tractIDNamesFromMC, value);
            }
        }

        /// <summary>
        /// Selected simulation of TractID's of MC.
        /// </summary>
        /// @return string.
        public string SelectedSimulation
        {
            get
            {
                return selectedSimulation;
            }
            set
            {
                Set<string>(() => this.SelectedSimulation, ref selectedSimulation, value);
            }
        }
    }
}
