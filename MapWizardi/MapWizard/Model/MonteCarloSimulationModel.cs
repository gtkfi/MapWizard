using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// MonteCarloSimulationModel.
    /// </summary>
    public class MonteCarloSimulationModel : ObservableObject
    {
        private string gradePdf;
        private string tonnagePdf;
        private string nDepositsPmf;
        private string extensionFolder;

        /// <summary>
        /// Grade Pdf.
        /// </summary>
        /// @return Grade Pdf.
        public string GradePdf
        {
            get
            {
                return gradePdf;
            }
            set
            {
                Set<string>(() => this.GradePdf, ref gradePdf, value);
            }
        }

        /// <summary>
        /// Tonnage Pdf.
        /// </summary>
        /// @return Tonnage Pdf.
        public string TonnagePdf
        {
            get
            {
                return tonnagePdf;
            }
            set
            {
                Set<string>(() => this.TonnagePdf, ref tonnagePdf, value);
            }
        }

        /// <summary>
        /// NDepositsPmf.
        /// </summary>
        /// @return NDepositsPmf.
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
        /// Folder for result saving.
        /// </summary>
        /// @return Folder for result saving.
        public string ExtensionFolder
        {
            get
            {
                return extensionFolder;
            }
            set
            {
                Set<string>(() => this.ExtensionFolder, ref extensionFolder, value);
            }
        }
    }
}
