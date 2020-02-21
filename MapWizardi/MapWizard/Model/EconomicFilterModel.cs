using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// Economic Filter Model
    /// </summary>
    public class EconomicFilterModel : ObservableObject
    {
        private string monteCarloResultTable;
        private string selectedMetal;
        private string selectedMetalIndex;
        private string metalsToCalculate;
        private string perType;
        private string perCent;
        private string raefPackageFolder;
        private string raefPresetFile;
        private string raefEconFilterFile;
        private string raefExtensionFolder;
        private string screenerExtensionFolder;

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
                Set<string>(() => this.RaefPresetFile, ref raefPresetFile, value);
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
                Set<string>(() => this.ScreenerExtensionFolder, ref screenerExtensionFolder, value);
            }
        }
    }
}
