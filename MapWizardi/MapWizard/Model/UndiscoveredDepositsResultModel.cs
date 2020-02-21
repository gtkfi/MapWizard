using System.Windows.Media;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// UndiscoveredDepositsResultModel
    /// </summary>
    public class UndiscoveredDepositsResultModel : ObservableObject
    {
        private string plotImage;
        private ImageSource plotImageBitMap;
        private string summary;
        private string nDepositsPmf;

        /// <summary>
        /// Deposits Pmf.
        /// </summary>
        /// @return Deposits Pmf.
        public string NDepositsPmf
        {
            get
            {
                return nDepositsPmf;
            }
            set
            {
                Set<string>(() => this.NDepositsPmf, ref nDepositsPmf, value);
            }
        }

        /// <summary>
        /// Plot image.
        /// </summary>
        /// @return Plot image.
        public string PlotImage
        {
            get
            {
                return plotImage;
            }
            set
            {
                Set<string>(() => this.PlotImage, ref plotImage, value);
            }
        }

        /// <summary>
        /// Plot image BitMap.
        /// </summary>
        /// @return ImageSource.
        public ImageSource PlotImageBitMap
        {
            get
            {
                return plotImageBitMap;
            }
            set
            {
                Set<ImageSource>(() => this.PlotImageBitMap, ref plotImageBitMap, value);
            }
        }

        /// <summary>
        /// Summary.
        /// </summary>
        /// @return Summary.
        public string Summary
        {
            get
            {
                return summary;
            }
            set
            {
                Set<string>(() => this.Summary, ref summary, value);
            }
        }
    }
}
