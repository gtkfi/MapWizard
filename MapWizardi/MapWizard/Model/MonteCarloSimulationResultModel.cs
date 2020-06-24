using System.Windows.Media;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// MonteCarloSimulationModel.
    /// </summary>
    public class MonteCarloSimulationResultModel : ObservableObject
    {
        private string summaryTotalTonnage;
        private string totalTonPlot;
        private ImageSource totalTonPlotBitMap;
        private string marginalPlot;
        private ImageSource marginalPlotBitMap;
        private string simulatedDepositsCSV;

        /// <summary>
        /// Summary total tonnage.
        /// </summary>
        /// @return Summary total tonnage.
        public string SummaryTotalTonnage
        {
            get
            {
                return summaryTotalTonnage;
            }
            set
            {
                Set<string>(() => this.SummaryTotalTonnage, ref summaryTotalTonnage, value);
            }
        }

        /// <summary>
        /// Total tonnage Plot.
        /// </summary>
        /// @return Total tonnage Plot.
        public string TotalTonPlot
        {
            get
            {
                return totalTonPlot;
            }
            set
            {
                Set<string>(() => this.TotalTonPlot, ref totalTonPlot, value);
            }
        }

        /// <summary>
        /// Total tonnage Plot BitMap.
        /// </summary>
        /// @return ImageSource.
        public ImageSource TotalTonPlotBitMap
        {
            get
            {
                return totalTonPlotBitMap;
            }
            set
            {
                Set<ImageSource>(() => this.TotalTonPlotBitMap, ref totalTonPlotBitMap, value);
            }
        }

        /// <summary>
        /// Marginal Plot.
        /// </summary>
        /// @return Marginal Plot.
        public string MarginalPlot
        {
            get
            {
                return marginalPlot;
            }
            set
            {
                Set<string>(() => this.MarginalPlot, ref marginalPlot, value);
            }
        }

        /// <summary>
        /// Marginal Plot BitMap.
        /// </summary>
        /// @return ImageSource.
        public ImageSource MarginalPlotBitMap
        {
            get
            {
                return marginalPlotBitMap;
            }
            set
            {
                Set<ImageSource>(() => this.MarginalPlotBitMap, ref marginalPlotBitMap, value);
            }
        }

        /// <summary>
        /// Simulated deposits csv.
        /// </summary>
        /// @return Simulated deposits csv.
        public string SimulatedDepositsCSV
        {
            get
            {
                return simulatedDepositsCSV;
            }
            set
            {
                Set<string>(() => this.SimulatedDepositsCSV, ref simulatedDepositsCSV, value);
            }
        }
    }
}
