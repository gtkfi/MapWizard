using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{

    /// <summary>
    /// GradeTonnage model.
    /// </summary>
    public class GradeTonnageModel : ObservableObject
    {
        private string csvPath;
        private int seed;
        private string pdfType;
        private string isTruncated;
        private int minDeposits;
        private int randSamples;
        private string folder;
        private string runGrade;
        private string runTonnage;
        private string modelType;
        private string extensionFolder;

        /// <summary>
        /// CSV path.
        /// </summary>
        /// @return CSV path.
        public string CSVPath
        {
            get
            {
                return csvPath;
            }
            set
            {
                Set<string>(() => this.CSVPath, ref csvPath, value);
            }
        }

        /// <summary>
        /// Seed value.
        /// </summary>
        /// @return Seed value.
        public int Seed
        {
            get
            {
                return seed;
            }
            set
            {
                Set<int>(() => this.Seed, ref seed, value);
            }
        }

        /// <summary>
        /// Is truncated?
        /// </summary>
        /// @return Is truncated?
        public string IsTruncated
        {
            get
            {
                return isTruncated;
            }
            set
            {
                Set<string>(() => this.IsTruncated, ref isTruncated, value);
            }
        }

        /// <summary>
        /// PDF type.
        /// </summary>
        /// @return PDF type.
        public string PdfType
        {
            get
            {
                return pdfType;
            }
            set
            {
                Set<string>(() => this.PdfType, ref pdfType, value);
            }
        }

        /// <summary>
        /// Minimum deposits.
        /// </summary>
        /// @return Minimum deposits.
        public int MinDepositCount
        {
            get
            {
                return minDeposits;
            }
            set
            {
                Set<int>(() => this.MinDepositCount, ref minDeposits, value);
            }
        }

        /// <summary>
        /// Random sample count.
        /// </summary>
        /// @return Random sample count.
        public int RandomSampleCount
        {
            get
            {
                return randSamples;
            }
            set
            {
                Set<int>(() => this.RandomSampleCount, ref randSamples, value);
            }
        }

        /// <summary>
        /// Folder.
        /// </summary>
        /// @return Folder.
        public string Folder
        {
            get
            {
                return folder;
            }
            set
            {
                Set<string>(() => this.Folder, ref folder, value);
            }
        }

        /// <summary>
        /// Run Grade tool.
        /// </summary>
        /// @return Run Grade tool.
        public string RunGrade
        {
            get
            {
                return runGrade;
            }
            set
            {
                Set<string>(() => this.RunGrade, ref runGrade, value);
            }
        }

        /// <summary>
        /// Run Tonnage tool.
        /// </summary>
        /// @return Run Tonnage tool.
        public string RunTonnage
        {
            get
            {
                return runTonnage;
            }
            set
            {
                Set<string>(() => this.RunTonnage, ref runTonnage, value);
            }
        }

        /// <summary>
        /// Model type.
        /// </summary>
        /// @return Model type.
        public string ModelType
        {
            get
            {
                return modelType;
            }
            set
            {
                Set<string>(() => this.ModelType, ref modelType, value);
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
