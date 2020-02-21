using GalaSoft.MvvmLight;

namespace MapWizard.Model
{   /// <summary>
    /// TractAggregationModel
    /// </summary>
    public class TractAggregationModel : ObservableObject
    {
        private string correlationMatrix;
        private string testName;
        private string workingDir;
        private string probDistFile;
        private bool createInputFile;

        /// <summary>
        /// Correlation matrix.
        /// </summary>
        /// @return Correlation matrix.
        public string CorrelationMatrix
        {
            get
            {
                return correlationMatrix;
            }
            set
            {
                Set<string>(() => this.CorrelationMatrix, ref correlationMatrix, value);
            }
        }

        /// <summary>
        /// Test name.
        /// </summary>
        /// @return Test name.
        public string TestName
        {
            get
            {
                return testName;
            }
            set
            {
                Set<string>(() => this.TestName, ref testName, value);
            }
        }

        /// <summary>
        /// Working directory.
        /// </summary>
        /// @return Working directory.
        public string WorkingDir
        {
            get
            {
                return workingDir;
            }
            set
            {
                Set<string>(() => this.WorkingDir, ref workingDir, value);
            }
        }

        /// <summary>
        /// Propability file.
        /// </summary>
        /// @return Propability file.
        public string ProbDistFile
        {
            get
            {
                return probDistFile;
            }
            set
            {
                Set<string>(() => this.ProbDistFile, ref probDistFile, value);
            }
        }

        /// <summary>
        /// Input file creation.
        /// </summary>
        /// @return Boolean representing the choice.
        public bool CreateInputFile
        {
            get
            {
                return createInputFile;
            }
            set
            {
                Set<bool>(() => this.CreateInputFile, ref createInputFile, value);
            }
        }
    }
}
