using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// TractAggregationResultModel
    /// </summary>
    public class TractAggregationResultModel : ObservableObject
    {
        private string tractAggregationSummary;

        /// <summary>
        /// Tract Aggregation Summary.
        /// </summary>
        /// @return Tract Aggregation Summary.
        public string TractAggregationSummary
        {
            get { return tractAggregationSummary; }
            set
            {
                Set<string>(() => this.TractAggregationSummary, ref tractAggregationSummary, value);
            }
        }
    }
}
