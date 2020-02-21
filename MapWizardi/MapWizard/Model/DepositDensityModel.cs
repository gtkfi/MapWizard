using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GalaSoft.MvvmLight;


namespace MapWizard.Model
{
    /// <summary>
    /// Observable object for DepositDensityModel
    /// </summary>
    public class DepositDensityModel : ObservableObject
    {
        private double medianTonnage;
        private double areaOfPermissiveTract;
        private int numbOfKnownDeposits;
        private string existingDepositDensityModelID;
        private string csvPath;

        /// <summary>
        /// Median tonnage.
        /// </summary>
        /// @return Median tonnage.
        public double MedianTonnage
        {
            get
            {
                return medianTonnage;
            }
            set
            {
                Set<double>(() => this.MedianTonnage, ref medianTonnage, value);
            }
        }

        /// <summary>
        /// Returns area of Permissive Tract.
        /// </summary>
        /// @return Area of Permissive Tract.
        public double AreaOfPermissiveTract
        {
            get
            {
                return areaOfPermissiveTract;
            }
            set
            {
                Set<double>(() => this.AreaOfPermissiveTract, ref areaOfPermissiveTract, value);
            }
        }

        /// <summary>
        /// Number of known deposits.
        /// </summary>
        /// @return  Number of known deposits.
        public int NumbOfKnownDeposits
        {
            get
            {
                return numbOfKnownDeposits;
            }
            set
            {
                Set<int>(() => this.NumbOfKnownDeposits, ref numbOfKnownDeposits, value);
            }
        }

        /// <summary>
        /// Existing deposit density model id.
        /// </summary>
        /// @return ID.
        public string ExistingDepositDensityModelID
        {
            get
            {
                return existingDepositDensityModelID;
            }
            set
            {
                Set<string>(() => this.ExistingDepositDensityModelID, ref existingDepositDensityModelID, value);
            }
        }

        /// <summary>
        /// Path to .csv file.
        /// </summary>
        /// @return Path to .csv file.
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
    }
}
