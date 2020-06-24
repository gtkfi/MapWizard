using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapWizard.Model
{
    public class TractAggregationDataModel : ObservableObject
    {
        private string tractName;
        private bool chooseTract;
        private string tractText;
        private bool isCorrelated;
        private bool isVisible;
        private bool isTitle;
        private ObservableCollection<TractAggregationDataModel> tractPairColumn = new ObservableCollection<TractAggregationDataModel>();

        /// <summary>
        /// Name of the tract.
        /// </summary>
        /// @return Name of the tract.
        public string TractName
        {
            get
            {
                return tractName;
            }
            set
            {
                Set<string>(() => this.TractName, ref tractName, value);
            }
        }

        /// <summary>
        /// Determines if the tract is chosen.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool ChooseTract
        {
            get
            {
                return chooseTract;
            }
            set
            {
                Set<bool>(() => this.ChooseTract, ref chooseTract, value);
            }
        }

        /// <summary>
        /// Info of the tract.
        /// </summary>
        /// @return Tract text.
        public string TractText
        {
            get
            {
                return tractText;
            }
            set
            {
                Set<string>(() => this.TractText, ref tractText, value);
            }
        }

        /// <summary>
        /// Set textBox unEnabled if theres no correlation.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool IsCorrelated
        {
            get
            {
                return isCorrelated;
            }
            set
            {
                Set<bool>(() => this.IsCorrelated, ref isCorrelated, value);
            }
        }

        /// <summary>
        /// Set matrix index hidden or visible.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool IsVisible
        {
            get
            {
                return isVisible;
            }
            set
            {
                Set<bool>(() => this.IsVisible, ref isVisible, value);
            }
        }

        /// <summary>
        /// Determines if the tract is title or an index of the matrix.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool IsTitle
        {
            get
            {
                return isTitle;
            }
            set
            {
                Set<bool>(() => this.IsTitle, ref isTitle, value);
            }
        }

        /// <summary>
        /// Collection containing tractID pair names and texts.
        /// </summary>
        /// @return Tract ID collection.
        public ObservableCollection<TractAggregationDataModel> TractPairColumn
        {
            get
            {
                return tractPairColumn;
            }
            set
            {
                Set<ObservableCollection<TractAggregationDataModel>>(() => this.TractPairColumn, ref tractPairColumn, value);
            }
        }
    }
}
