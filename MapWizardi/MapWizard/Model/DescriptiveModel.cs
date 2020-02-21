using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// Observable object for DescriptiveModel
    /// </summary>
    public class DescriptiveModel : ObservableObject
    {
        private string textFile;
        private object runVisibilityTab1;
        private object runVisibilityTab2;        
        private int selectedTabIndex;
        private string tab1ExtensionFolder;
        private string tab2ExtensionFolder;
        private object orderButtonVisibility;
        private string usedMethod;
        private List<string> fieldList;
        private List<string> allSubFieldList;
        private List<string> subFieldList;
        private List<int> subFieldCountList;
        private string[] textArray;
        private string[] subTextArray;
        private List<int> randomList;

        /// <summary>
        /// Selected textfile.
        /// </summary>
        /// @return Path of the file.
        public string TextFile
        {
            get
            {
                return textFile;
            }
            set
            {
                Set<string>(() => this.TextFile, ref textFile, value);
            }
        }

        /// <summary>
        /// 'Run Tool' button visibility in first tab.
        /// </summary>
        /// @return Object representing the visibility.
        public object RunVisibilityTab1
        {
            get
            {
                return runVisibilityTab1;
            }
            set
            {
                Set<object>(() => this.RunVisibilityTab1, ref runVisibilityTab1, value);
            }
        }

        /// <summary>
        /// 'Run Tool' button visibility in second tab.
        /// </summary>
        /// @return Object representing the visibility.
        public object RunVisibilityTab2
        {
            get
            {
                return runVisibilityTab2;
            }
            set
            {
                Set<object>(() => this.RunVisibilityTab2, ref runVisibilityTab2, value);
            }
        }

        /// <summary>
        /// Determines if we are using 'Edit' or 'New' tab.
        /// </summary>
        /// @return Integer representing the tab.
        public int SelectedTabIndex
        {
            get
            {
                return selectedTabIndex;
            }
            set
            {
                selectedTabIndex = value;
            }
        }

        /// <summary>
        /// Named folder for 'Edit' tab.
        /// </summary>
        /// @return Folder name.
        public string Tab1ExtensionFolder
        {
            get
            {
                return tab1ExtensionFolder;
            }
            set
            {
                Set<string>(() => this.Tab1ExtensionFolder, ref tab1ExtensionFolder, value);
            }
        }

        /// <summary>
        /// Named folder for 'New' tab.
        /// </summary>
        /// @return Folder name.
        public string Tab2ExtensionFolder
        {
            get
            {
                return tab2ExtensionFolder;
            }
            set
            {
                Set<string>(() => this.Tab2ExtensionFolder, ref tab2ExtensionFolder, value);
            }
        }

        /// <summary>
        /// 'Save Order' button visibility in result view.
        /// </summary>
        /// @return Object representing the visibility.
        public object OrderButtonVisibility
        {
            get
            {
                return orderButtonVisibility;
            }
            set
            {
                Set<object>(() => this.OrderButtonVisibility, ref orderButtonVisibility, value);
            }

        }

        /// <summary>
        /// File we use in resultview.
        /// </summary>
        /// @return 'NewFile' or 'EditedFile'.
        public string UsedMethod
        {
            get
            {
                return usedMethod;
            }
            set
            {
                Set<string>(() => this.UsedMethod, ref usedMethod, value);
            }
        }

        /// <summary>
        /// List of the documents fields.
        /// </summary>
        /// @return Field list.
        public List<string> FieldList
        {
            get
            {
                return fieldList;
            }
            set
            {
                Set<List<string>>(() => this.FieldList, ref fieldList, value);
            }
        }

        /// <summary>
        /// List containing all subfields of´the different fields.
        /// </summary>
        /// @return Subfield list.
        public List<string> AllSubFieldList
        {
            get
            {
                return allSubFieldList;
            }
            set
            {
                Set<List<string>>(() => this.AllSubFieldList, ref allSubFieldList, value);
            }
        }

        /// <summary>
        /// List of a specific field's subFields.
        /// </summary>
        /// @return Subfield list.
        public List<string> SubFieldList
        {
            get
            {
                return subFieldList;
            }
            set
            {
                Set<List<string>>(() => this.SubFieldList, ref subFieldList, value);
            }
        }

        /// <summary>
        /// List of the amount of subFields each field has.
        /// </summary>
        /// @return SubField amount list.
        public List<int> SubFieldCountList
        {
            get
            {
                return subFieldCountList;
            }
            set
            {
                Set<List<int>>(() => this.SubFieldCountList, ref subFieldCountList, value);
            }
        }

        /// <summary>
        /// Array containing each field's info text.
        /// </summary>
        /// @return Field info array.
        public string[] TextArray
        {
            get
            {
                return textArray;
            }
            set
            {
                Set<string[]>(() => this.TextArray, ref textArray, value);
            }
        }

        /// <summary>
        /// Array containing each subfield's info text.
        /// </summary>
        /// @return Subfield info array.
        public string[] SubTextArray
        {
            get
            {
                return subTextArray;
            }
            set
            {
                Set<string[]>(() => this.SubTextArray, ref subTextArray, value);
            }
        }

        /// <summary>
        /// Randomly generated IDs for Fields.
        /// </summary>
        /// @return ID list.
        public List<int> RandomList
        {
            get
            {
                return randomList;
            }
            set
            {
                Set<List<int>>(() => this.RandomList, ref randomList, value);
            }
        }
    }
}
