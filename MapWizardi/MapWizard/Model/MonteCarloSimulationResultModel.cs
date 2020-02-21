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
        private string totalTonPdf;
        private ImageSource totalTonPdfBitMap;
        private string marginalPdf;
        private ImageSource marginalPdfBitMap;
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
        /// Total tonnage Pdf.
        /// </summary>
        /// @return Total tonnage Pdf.
        public string TotalTonPdf
        {
            get
            {
                return totalTonPdf;
            }
            set
            {
                Set<string>(() => this.TotalTonPdf, ref totalTonPdf, value);
            }
        }

        /// <summary>
        /// Total tonnage Pdf BitMap.
        /// </summary>
        /// @return ImageSource.
        public ImageSource TotalTonPdfBitMap
        {
            get
            {
                return totalTonPdfBitMap;
            }
            set
            {
                Set<ImageSource>(() => this.TotalTonPdfBitMap, ref totalTonPdfBitMap, value);
            }
        }

        /// <summary>
        /// Marginal Pdf.
        /// </summary>
        /// @return Marginal Pdf.
        public string MarginalPdf
        {
            get
            {
                return marginalPdf;
            }
            set
            {
                Set<string>(() => this.MarginalPdf, ref marginalPdf, value);
            }
        }

        /// <summary>
        /// Marginal Pdf BitMap.
        /// </summary>
        /// @return ImageSource.
        public ImageSource MarginalPdfBitMap
        {
            get
            {
                return marginalPdfBitMap;
            }
            set
            {
                Set<ImageSource>(() => this.MarginalPdfBitMap, ref marginalPdfBitMap, value);
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
