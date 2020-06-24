using GalaSoft.MvvmLight;
using System.Windows.Media;

namespace MapWizard.Model
{
    /// <summary>
    /// Deposit density result model
    /// </summary>
    public class DepositDensityResultModel : ObservableObject
    {
        private string n10;
        private string n50;
        private string n90;
        private string plotImagePath;
        private ImageSource plotImageBitMap;
        private string model;
        private string mTonnage;
        private string tArea;
        private string nKnown;
        private string note;

        /// <summary>
        /// N10.
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
        /// N50.
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
        /// N90.
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
        /// Model.
        /// </summary>
        /// @return Model.
        public string Model
        {
            get
            {
                return model;
            }
            set
            {
                Set<string>(() => this.Model, ref model, value);
            }
        }

        /// <summary>
        /// MTonnage.
        /// </summary>
        /// @return MTonnage.
        public string MTonnage
        {
            get
            {
                return mTonnage;
            }
            set
            {
                Set<string>(() => this.MTonnage, ref mTonnage, value);
            }
        }

        /// <summary>
        /// TArea.
        /// </summary>
        /// @return TArea.
        public string TArea
        {
            get
            {
                return tArea;
            }
            set
            {
                Set<string>(() => this.TArea, ref tArea, value);
            }
        }

        /// <summary>
        /// NKnown.
        /// </summary>
        /// return NKnown.
        public string NKnown
        {
            get
            {
                return nKnown;
            }
            set
            {
                Set<string>(() => this.NKnown, ref nKnown, value);
            }
        }

        /// <summary>
        /// Path to plot image.
        /// </summary>
        /// @return Path to plot image.
        public string PlotImagePath
        {
            get
            {
                return plotImagePath;
            }
            set
            {
                Set<string>(() => this.PlotImagePath, ref plotImagePath, value);
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
        /// Note.
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

    }
}
