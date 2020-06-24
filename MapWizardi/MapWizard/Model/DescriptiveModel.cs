using System.Collections.Generic;
using System.Collections.ObjectModel;
using GalaSoft.MvvmLight;

namespace MapWizard.Model
{
    /// <summary>
    /// Observable object for DescriptiveModel
    /// </summary>
    public class DescriptiveModel : ObservableObject
    {
        // Always initialized the same way.
        private bool isBusy;        
        private bool tab1UseModelName = false;
        private bool tab2UseModelName = false;
        private bool saveToDepositModels = false;
        private int selectedModelIndex = 0;        
        private string depositModelsExtension = "";
        private ObservableCollection<string> modelNames = new ObservableCollection<string>();
        private ObservableCollection<DescriptiveDataModel> textBoxList = new ObservableCollection<DescriptiveDataModel>();
        private ObservableCollection<DescriptiveDataModel> newTextBoxList = new ObservableCollection<DescriptiveDataModel>();
        private ObservableCollection<DescriptiveDataModel> resultTextBoxList = new ObservableCollection<DescriptiveDataModel>();
        // Not always initialized the same way.
        private string lastRunDate = "Last Run: Never";
        private int runStatus = 2;
        private string textFile = "Select File";
        private string wordFile = "Select File";
        private object runVisibilityTab1 = "Collapsed";
        private object runVisibilityTab2 = "Collapsed";        
        private int selectedTabIndex;
        private string tab1ExtensionFolder;
        private string tab2ExtensionFolder;
        private object orderButtonVisibility = "Collapsed";
        private string usedMethod;
        private List<string> fieldList = new List<string>();
        private List<string> allSubFieldList = new List<string>();
        private List<string> subFieldList = new List<string>();
        private List<int> subFieldCountList = new List<int>();
        private string[] textArray = new string[0];
        private string[] subTextArray = new string[0];
        private List<int> randomList = new List<int>();

        /// <summary>
        /// Is busy?
        /// </summary>
        /// <returns>Boolean representing the state.</returns>
        public bool IsBusy
        {
            get { return isBusy; }
            set
            {
                if (isBusy == value) return;
                isBusy = value;
                RaisePropertyChanged(() => IsBusy);
            }
        }

        /// <summary>
        /// Determines if the model will be saved into a named folder in Edit -tab.
        /// </summary>
        /// <returns>Boolean representing the choice.</returns>
        public bool Tab1UseModelName
        {
            get { return tab1UseModelName; }
            set
            {
                if (value == tab1UseModelName) return;
                tab1UseModelName = value;
                RaisePropertyChanged("Tab1UseModelName");
            }
        }

        /// <summary>
        /// Determines if the model will be saved into a named folder in New -tab.
        /// </summary>
        /// <returns>Boolean representing the choice.</returns>
        public bool Tab2UseModelName
        {
            get { return tab2UseModelName; }
            set
            {
                if (value == tab2UseModelName) return;
                tab2UseModelName = value;
                RaisePropertyChanged("Tab2UseModelName");
            }
        }

        /// <summary>
        /// Index of the selected model to get the model's results. Binded in MainWindow.xaml.
        /// </summary>
        /// <returns>Index of the selected model.</returns>
        public int SelectedModelIndex
        {
            get { return selectedModelIndex; }
            set
            {
                if (value == selectedModelIndex) return;
                selectedModelIndex = value;
                RaisePropertyChanged("SelectedModelIndex");
            }
        }

        /// <summary>
        /// Choice to save model into deposit models folder. Binded in MainWindow.xaml.
        /// </summary>
        /// <returns>Boolean representing the choice.</returns>
        public bool SaveToDepositModels
        {
            get { return saveToDepositModels; }
            set
            {
                if (value == saveToDepositModels) return;
                saveToDepositModels = value;
                RaisePropertyChanged("SaveToDepositModels");
            }
        }

        /// <summary>
        /// Name of the folder where model will be saved in deposit models folder. Binded in MainWindow.xaml.
        /// </summary>
        /// <returns>Name of the extension folder.</returns>
        public string DepositModelsExtension
        {
            get { return depositModelsExtension; }
            set
            {
                if (value == depositModelsExtension) return;
                depositModelsExtension = value;
                RaisePropertyChanged("DepositModelsExtension");
            }
        }

        /// <summary>
        /// Collection for all the models. Binded in MainWindow.xaml.
        /// </summary>
        /// <returns>Collection containing all models that are saved into different paths.</returns>
        public ObservableCollection<string> ModelNames
        {
            get { return modelNames; }
            set
            {
                if (value == modelNames) return;
                modelNames = value;
            }

        }

        /// <summary>
        /// List for all TextBoxes.
        /// </summary>
        /// <returns>Collection of DescriptiveDataModels.</returns>
        public ObservableCollection<DescriptiveDataModel> TextBoxList
        {
            get { return textBoxList; }
            set
            {
                textBoxList = value;
                RaisePropertyChanged("TextBoxList");
            }
        }

        /// <summary>
        /// List for TextBoxes in New -tab.
        /// </summary>
        /// <returns>Collection of DescriptiveDataModels.</returns>
        public ObservableCollection<DescriptiveDataModel> NewTextBoxList
        {
            get { return newTextBoxList; }
            set
            {
                newTextBoxList = value;
                RaisePropertyChanged("NewTextBoxList");
            }
        }

        /// <summary>
        /// Collection of all TextBoxes for resultview.
        /// </summary>
        /// <returns>Collection of DescriptiveDataModels.</returns>
        public ObservableCollection<DescriptiveDataModel> ResultTextBoxList
        {
            get { return resultTextBoxList; }
            set
            {
                resultTextBoxList = value;
                RaisePropertyChanged("ResultTextBoxList");
            }
        }

        /// <summary>
        /// Check if tool can be executed (not busy.)
        /// </summary>
        /// <returns>Integer representing the status.</returns>
        public int RunStatus
        {
            get { return runStatus; }
            set
            {
                if (value == runStatus) return;
                runStatus = value;
                RaisePropertyChanged("RunStatus");
            }
        }

        /// <summary>
        /// Date and time of the last run.
        /// </summary>
        /// <returns>Run date.</returns>
        public string LastRunDate
        {
            get { return lastRunDate; }
            set
            {
                if (value == lastRunDate) return;
                lastRunDate = value;
                RaisePropertyChanged("LastRunDate");
            }
        }

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
                if (value == null)
                {
                    value = "Select File";
                }
                Set<string>(() => this.TextFile, ref textFile, value);
            }
        }

        /// <summary>
        /// Selected Word document file.
        /// </summary>
        /// @return Path of the file.
        public string WordFile
        {
            get
            {
                return wordFile;
            }
            set
            {
                if (value == null)
                {
                    value = "Select File";
                }
                Set<string>(() => this.WordFile, ref wordFile, value);                
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
                if (value == null)
                {
                    value = "Collapsed";
                }
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
                if (value == null)
                {
                    value = "Collapsed";
                }
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
                if (value == null)
                {
                    value = "Collapsed";
                }
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
                if (value == null)
                {
                    value = new List<string>();
                }
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
                if (value == null)
                {
                    value = new List<string>();
                }
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
                if (value == null)
                {
                    value = new List<string>();
                }
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
                if (value == null)
                {
                    value = new List<int>();
                }
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
                if (value == null)
                {
                    value = new string[0];
                }
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
                if (value == null)
                {
                    value = new string[0];
                }
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
                if (value == null)
                {
                    value = new List<int>();
                }
                Set<List<int>>(() => this.RandomList, ref randomList, value);
            }
        }
    }
}
