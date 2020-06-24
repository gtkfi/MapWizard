using GalaSoft.MvvmLight;
using System.Windows.Media;

namespace MapWizard.Model
{
    /// <summary>
    /// Grade Tonnage result model
    /// </summary>
    public class GradeTonnageResultModel : ObservableObject
    {
        private ImageSource gradePlotBitMap;
        private ImageSource tonnagePlotBitMap;
        private string gradePlot;
        private string tonnagePlot;
        private string gradePDF;
        private string tonnagePDF;
        private string tonnageSummary;
        private string gradeSummary;
        private string output;
        private bool success;

        /// <summary>
        /// Grade plot BitMap.
        /// </summary>
        /// @return ImageSource.
        public ImageSource GradePlotBitMap
        {
            get
            {
                return gradePlotBitMap;
            }
            set
            {
                Set<ImageSource>(() => this.GradePlotBitMap, ref gradePlotBitMap, value);
            }
        }

        /// <summary>
        /// Tonnage plot BitMap.
        /// </summary>
        /// @return ImageSource.
        public ImageSource TonnagePlotBitMap
        {
            get
            {
                return tonnagePlotBitMap;
            }
            set
            {
                Set<ImageSource>(() => this.TonnagePlotBitMap, ref tonnagePlotBitMap, value);
            }
        }

        /// <summary>
        /// Grade plot.
        /// </summary>
        /// @return Grade plot.
        public string GradePlot
        {
            get
            {
                return gradePlot;
            }
            set
            {
                Set<string>(() => this.GradePlot, ref gradePlot, value);
            }
        }

        /// <summary>
        /// Tonnage plot.
        /// </summary>
        /// @return Tonnage plot.
        public string TonnagePlot
        {
            get
            {
                return tonnagePlot;
            }
            set
            {
                Set<string>(() => this.TonnagePlot, ref tonnagePlot, value);
            }
        }

        /// <summary>
        /// Grade PDF.
        /// </summary>
        /// @return Grade PDF.
        public string GradePdf
        {
            get
            {
                return gradePDF;
            }
            set
            {
                Set<string>(() => this.GradePdf, ref gradePDF, value);
            }
        }

        /// <summary>
        /// Tonnage PDF.
        /// </summary>
        /// @return Tonnage PDF.
        public string TonnagePdf
        {
            get
            {
                return tonnagePDF;
            }
            set
            {
                Set<string>(() => this.TonnagePdf, ref tonnagePDF, value);
            }
        }

        /// <summary>
        /// Grade summary.
        /// </summary>
        /// @return Grade summary.
        public string GradeSummary
        {
            get
            {
                return gradeSummary;
            }
            set
            {
                Set<string>(() => this.GradeSummary, ref gradeSummary, value);
            }
        }

        /// <summary>
        /// Tonnage summary.
        /// </summary>
        /// @return Tonnage summary.
        public string TonnageSummary
        {
            get
            {
                return tonnageSummary;
            }
            set
            {
                Set<string>(() => this.TonnageSummary, ref tonnageSummary, value);
            }
        }

        /// <summary>
        /// Output.
        /// </summary>
        /// @return Output.
        public string Output
        {
            get
            {
                return output;
            }
            set
            {
                Set<string>(() => this.Output, ref output, value);
            }
        }

        /// <summary>
        /// Indicates if tool was ran successfully.
        /// </summary>
        /// @return Boolean representing if tool was ran successfully.
        public bool Success
        {
            get
            {
                return success;
            }
            set
            {
                Set<bool>(() => this.Success, ref success, value);
            }
        }
    }
}
