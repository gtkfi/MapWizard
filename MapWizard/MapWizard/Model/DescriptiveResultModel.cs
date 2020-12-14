using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapWizard.Model
{
    /// <summary>
    /// Descriptive result model.
    /// </summary>
    public class DescriptiveResultModel : ObservableObject
    {
        private string outputFile;

        /// <summary>
        /// OutputFile.
        /// @return OutputFile.
        /// </summary>
        public string OutputFile
        {
            get
            {
                return outputFile;
            }
            set
            {
                Set<string>(() => this.OutputFile, ref outputFile, value);
            }
        }
    }
}
