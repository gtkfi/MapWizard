using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// Economic Filter Result Model
    /// </summary>
    public class EconomicFilterResultModel : ObservableObject
    {
        private ImageSource screenerPlotBitMap;
        private ImageSource screenerHistogramBitMap;
        private string ecoTonnages;
        private string ecoTonnageStats;
        private string ecoTonHistrogram;
        private string resultPlot;

        /// <summary>
        /// Screener plot BitMap
        /// </summary>
        /// @return ImageSource.
        public ImageSource ScreenerPlotBitMap
        {
            get
            {
                return screenerPlotBitMap;
            }
            set
            {
                Set<ImageSource>(() => this.ScreenerPlotBitMap, ref screenerPlotBitMap, value);
            }
        }

        /// <summary>
        /// Tonnage plot BitMap.
        /// </summary>
        /// @return ImageSource.
        public ImageSource ScreenerHistogramBitMap
        {
            get
            {
                return screenerHistogramBitMap;
            }
            set
            {
                Set<ImageSource>(() => this.ScreenerHistogramBitMap, ref screenerHistogramBitMap, value);
            }
        }

        /// <summary>
        /// Summary eco tonnages.
        /// </summary>
        /// @return Summary eco tonnages.
        public string EcoTonnages
        {
            get
            {
                return ecoTonnages;
            }
            set
            {
                Set<string>(() => this.EcoTonnages, ref ecoTonnages, value);
            }
        }

        /// <summary>
        /// Summary eco tonnage statistics.
        /// </summary>
        /// @return Summary eco tonnage statistics.
        public string EcoTonnageStats
        {
            get
            {
                return ecoTonnageStats;
            }
            set
            {
                Set<string>(() => this.EcoTonnageStats, ref ecoTonnageStats, value);
            }
        }

        /// <summary>
        /// Summary eco tonnage histogram.
        /// </summary>
        /// @return Summary eco tonnage histogram.
        public string EcoTonHistrogram
        {
            get
            {
                return ecoTonHistrogram;
            }
            set
            {
                Set<string>(() => this.EcoTonHistrogram, ref ecoTonHistrogram, value);
            }
        }

        /// <summary>
        /// Summary Metal result plot file.
        /// </summary>
        /// @return Summary Metal result plot file.
        public string ResultPlot
        {
            get
            {
                return resultPlot;
            }
            set
            {
                Set<string>(() => this.ResultPlot, ref resultPlot, value);
            }
        }
    }
}
