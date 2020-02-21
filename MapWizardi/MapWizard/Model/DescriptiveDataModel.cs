using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;

namespace MapWizard.Model
{
    /// <summary>
    /// Observable object for DescriptiveDataModel
    /// </summary>
    public class DescriptiveDataModel : ObservableObject
    {
        private string fieldText;
        private string newFieldText;
        private string subFieldText;
        private string subInfoText;
        private string infoText;
        private string newInfoText;
        private string resultText;
        private int newFieldId;
        private bool containsSubFields;
        private object switchButtonVisibility;
        private ObservableCollection<DescriptiveDataModel> subTextBoxList;

        /// <summary>
        /// Text of the field.
        /// </summary>
        /// @return Fieldtext.
        public string FieldText
        {
            get
            {
                return fieldText;
            }
            set
            {
                Set<string>(() => this.FieldText, ref fieldText, value);
            }
        }

        /// <summary>
        /// Text of the added field.
        /// </summary>
        /// @return Field text.
        public string NewFieldText
        {
            get
            {
                return newFieldText;
            }
            set
            {
                Set<string>(() => this.NewFieldText, ref newFieldText, value);
            }        
        }

        /// <summary>
        /// Text of the subfield.
        /// </summary>
        /// @return SubField Text.
        public string SubFieldText
        {
            get
            {
                return subFieldText;
            }
            set
            {
                Set<string>(() => this.SubFieldText, ref subFieldText, value);
            }
        }

        /// <summary>
        /// Text of the subfields info.
        /// </summary>
        /// @return SubField related info text.
        public string SubInfoText
        {
            get
            {
                return subInfoText;
            }
            set
            {
                Set<string>(() => this.SubInfoText, ref subInfoText, value);
            }
        }

        /// <summary>
        /// Text of the field related info.
        /// </summary>
        /// @return Field related info text.
        public string InfoText
        {
            get
            {
                return infoText;
            }
            set
            {
                Set<string>(() => this.InfoText, ref infoText, value);
            }
        }

        /// <summary>
        /// Text of the added field related info.
        /// </summary>
        /// @return Field related info text.
        public string NewInfoText
        {
            get
            {
                return newInfoText;
            }
            set
            {
                Set<string>(() => this.NewInfoText, ref newInfoText, value);
            }
        }

        /// <summary>
        /// ID of the added field.
        /// </summary>
        /// @return FieldID.
        public int NewFieldId
        {
            get
            {
                return newFieldId;
            }
            set
            {
                Set<int>(() => this.NewFieldId, ref newFieldId, value);
            }
        }

        /// <summary>
        /// Text of the field related info in result.
        /// </summary>
        /// @return Result text.
        public string ResultText
        {
            get
            {
                return resultText;
            }
            set
            {
                Set<string>(() => this.ResultText, ref resultText, value);
            }
        }

        /// <summary>
        /// Determines if the field contains subfields.
        /// </summary>
        /// @return Boolean representing answer.
        public bool ContainsSubFields
        {
            get
            {
                return containsSubFields;
            }
            set
            {
                Set<bool>(() => this.ContainsSubFields, ref containsSubFields, value);
            }
        }

        /// <summary>
        /// 'Save Order' button visibility in result view.
        /// </summary>
        /// @return Object representing the visibility.
        public object SwitchButtonVisibility
        {
            get
            {
                return switchButtonVisibility;
            }
            set
            {
                Set<object>(() => this.SwitchButtonVisibility, ref switchButtonVisibility, value);
            }
        }

        /// <summary>
        /// Collection for subfields and subfield infos.
        /// </summary>
        /// @return List containing SubTextBoxes.
        public ObservableCollection<DescriptiveDataModel> SubTextBoxList
        {
            get
            {
                return subTextBoxList;
            }
            set
            {
                Set<ObservableCollection<DescriptiveDataModel>>(() => this.SubTextBoxList, ref subTextBoxList, value);
            }
        }
    }
}
