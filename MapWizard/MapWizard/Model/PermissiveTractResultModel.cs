using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// Permissive Tract result model
    /// </summary>
    public class PermissiveTractResultModel : ObservableObject
    {
        private string returnvalue;
        private bool success;
        /// <summary>
        /// Return value
        /// </summary>
        /// @return string
        public string ReturnValue
        {
            get
            {
                return returnvalue;
            }
            set
            {
                Set<string>(() => this.ReturnValue, ref returnvalue, value);
            }
        }
        /// <summary>
        /// Indicates if the tool was ran succesfully
        /// </summary>
        /// @return bool
        public bool Success
        {
            get
            {
                return success;
            }
            set
            {
                Set<bool>(() => this.Success, ref success, value);
            }
        }
    }
}
