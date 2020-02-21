using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using MahApps.Metro.Controls;
using MahApps.Metro.Controls.Dialogs;
using MapWizard.Model;
using MapWizard.Service;
using MapWizard.Tools;
using MapWizard.Tools.Settings;
using NLog;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using Xceed.Words.NET;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// This class contains properties that the DescriptiveView can data bind to.
    /// </summary>
    public class DescriptiveViewModel : ViewModelBase
    {
        private DescriptiveModel currentModel;
        private DescriptiveDataModel model;
        private DescriptiveDataModel subModel;
        private DescriptiveResultModel result;
        private ViewModelLocator viewModelLocator;
        private readonly ILogger logger;
        private readonly IDialogService dialogService;
        private readonly ISettingsService settingsService;
        private bool isBusy;
        private bool tab1UseModelName;
        private bool tab2UseModelName;
        private int selectedModelIndex;
        private string lastRunDate;
        private int runStatus;
        private bool saveToDepositModels;
        private bool noFolderNameGiven;
        private string depositModelsExtension;
        private int selectedTabIndex;
        private ObservableCollection<string> modelNames;
        private ObservableCollection<DescriptiveDataModel> textBoxList;
        private ObservableCollection<DescriptiveDataModel> newTextBoxList;
        private ObservableCollection<DescriptiveDataModel> resultTextBoxList;
        public RelayCommand<string> openFieldInfoCommand;
        public RelayCommand<string> switchButtonsCommand;
        public RelayCommand<int> addTBoxCommand;
        public RelayCommand<int> deleteTBoxCommand;
        public RelayCommand<string> textWrapCommand;

        /// <summary>
        /// Initialize a new instance of the DescriptiveViewModel class.
        /// </summary>
        private void Initialize()
        {
            lastRunDate = "Last Run: Never";
            runStatus = 2;
            currentModel = new DescriptiveModel();
            model = new DescriptiveDataModel();
            subModel = new DescriptiveDataModel();
            result = new DescriptiveResultModel();
            viewModelLocator = new ViewModelLocator();
            tab1UseModelName = false;
            tab2UseModelName = false;
            saveToDepositModels = false;
            noFolderNameGiven = false;
            selectedModelIndex = 0;
            modelNames = new ObservableCollection<string>();
            TextFile = "Select File";
            depositModelsExtension = "";
            textBoxList = new ObservableCollection<DescriptiveDataModel>();
            newTextBoxList = new ObservableCollection<DescriptiveDataModel>();
            resultTextBoxList = new ObservableCollection<DescriptiveDataModel>();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            SelectFileCommand = new RelayCommand(SelectFile, CanRunTool);
            AddFirstTBoxCommand = new RelayCommand(AddFirstTBox, CanRunTool);
            SelectModelCommand = new RelayCommand(SelectResult, CanRunTool);
            DeleteAllTBoxCommand = new RelayCommand(DeleteAllTBox, CanRunTool);
            ShowModelDialog = new RelayCommand(OpenModelDialog, CanRunTool);
        }

        /// <summary>
        /// Initialize a new instance of the DescriptiveViewModel class.
        /// </summary>
        /// <param name="logger">Logging for the MapWizard.</param>
        /// <param name="dialogService">Service for using dialogs and notifications.</param>
        /// <param name="settingsService">Service for using and editing settings.</param>
        public DescriptiveViewModel(ILogger logger, IDialogService dialogService, ISettingsService settingsService)
        {
            this.logger = logger;
            this.dialogService = dialogService;
            this.settingsService = settingsService;
            Initialize();
            DescriptiveInputParams inputParams = new DescriptiveInputParams();            
            string selectedProjectFolder = Path.Combine(settingsService.RootPath, "DescModel", "SelectedResult");
            if (!Directory.Exists(selectedProjectFolder))
            {
                Directory.CreateDirectory(selectedProjectFolder);
            }
            string param_json = Path.Combine(selectedProjectFolder, "descriptive_input_params.json");
            if (File.Exists(param_json))
            {
                // Makes sure that the json file is valid.
                try
                {
                    inputParams.Load(param_json);
                    CurrentModel = new DescriptiveModel
                    {
                        TextFile = inputParams.TextFile,
                        UsedMethod = inputParams.Method,
                        RunVisibilityTab1 = "Visible",
                        FieldList = new List<string>(), // These should be initilized from method.
                        AllSubFieldList = new List<string>(),
                        SubFieldList = new List<string>(),
                        SubFieldCountList = new List<int>(),
                        TextArray = new string[0],
                        SubTextArray = new string[0],
                        RandomList = new List<int>()
                    };
                }
                catch(Exception ex)
                {
                    CurrentModel = new DescriptiveModel
                    {
                        TextFile = "Select File",
                        RunVisibilityTab1 = "Collapsed",
                        RunVisibilityTab2 = "Collapsed",
                        OrderButtonVisibility = "Collapsed",
                        FieldList = new List<string>(),
                        AllSubFieldList = new List<string>(),
                        SubFieldList = new List<string>(),
                        SubFieldCountList = new List<int>(),
                        TextArray = new string[0],
                        SubTextArray = new string[0],
                        RandomList = new List<int>()
                    };
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Descriptive model tool's inputs correctly.", "Error");
                }
                // If all the File -tab related files exist, then load the textfile update Success status.
                if (File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveModel(Chars).txt")) && File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveModel.txt"))
                    && File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveModel(docx).docx")))
                {
                    TextFile = Path.Combine(selectedProjectFolder, "DescriptiveModel(Chars).txt");
                    ReadFile();
                    RunStatus = 1;
                }
                // If all the files didn't exist and there have been a previous run in File -tab, then update error status.
                else if (UsedMethod == "EditedFile")
                {
                    RunStatus = 0;
                }
                // If all the File -tab related files exist, then load the textfile and update Success status.
                if (File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveNewModel(Chars).txt")) && File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveNewModel.txt"))
                    && File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveNewModel(docx).docx")))
                {
                    LoadLastNewTabSession(Path.Combine(selectedProjectFolder, "DescriptiveNewModel(Chars).txt"));
                    if (UsedMethod == "NewFile") // This makes sure that the last session was using New -tab.
                    {
                        RunStatus = 1;
                    }
                }
                // If all the files didn't exist and there have been a previous run in New -tab, then update Error status.
                else if (UsedMethod == "NewFile")
                {
                    CurrentModel.RunVisibilityTab2 = "Collapsed";
                    RunStatus = 0;
                }
            }
            // If json -file didn't exist.
            else
            {
                CurrentModel = new DescriptiveModel
                {
                    TextFile = "Select File",
                    RunVisibilityTab1 = "Collapsed",
                    RunVisibilityTab2 = "Collapsed",
                    OrderButtonVisibility = "Collapsed",
                    FieldList = new List<string>(),
                    AllSubFieldList = new List<string>(),
                    SubFieldList = new List<string>(),
                    SubFieldCountList = new List<int>(),
                    TextArray = new string[0],
                    SubTextArray = new string[0],
                    RandomList = new List<int>()
                };
            }
            string projectFolder = Path.Combine(settingsService.RootPath, "DescModel");
            FindModelnames(projectFolder);  // Get all previous result folders.
            var lastRunFile = Path.Combine(projectFolder, "descriptive_last_run.lastrun");
            if (File.Exists(lastRunFile))
            {
                LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
            }
        }

        /// <summary>
        /// Select file command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectFileCommand { get; set; }

        /// <summary>
        /// Run tool command.
        /// </summary>
        /// @return Command.
        public RelayCommand RunToolCommand { get; set; }

        /// <summary>
        /// Create file command.
        /// </summary>
        /// @return Command.
        public RelayCommand CreateEditFileCommand { get; set; }

        /// <summary>
        /// Create file from added fields command.
        /// </summary>
        /// @return Command.
        public RelayCommand CreateNewFileCommand { get; set; }

        /// <summary>
        /// Show dialog command.
        /// </summary>
        /// @return Command.
        public RelayCommand ShowModelDialog { get; set; }

        /// <summary>
        /// Selct model from dialog command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectModelCommand { get; set; }

        /// <summary>
        /// Add first TextBox command.
        /// </summary>
        /// @return Command.
        public RelayCommand AddFirstTBoxCommand { get; set; }

        /// <summary>
        /// Add TextBoxes command.
        /// </summary>
        /// @return Command.
        public RelayCommand<int> AddTBoxCommand
        {
            get
            {
                addTBoxCommand = new RelayCommand<int>(e => AddTBox(e));  // Gets chosen field's id as a parameter.
                return addTBoxCommand;
            }
            set
            {
                addTBoxCommand = value;
            }
        }

        /// <summary>
        /// Delete TextBoxes command.
        /// </summary>
        /// @return Command.
        public RelayCommand<int> DeleteTBoxCommand
        {
            get
            {
                deleteTBoxCommand = new RelayCommand<int>(e => DeleteTBox(e));  // Gets chosen field's id as a parameter.
                return deleteTBoxCommand;
            }
            set
            {
                deleteTBoxCommand = value;
            }
        }

        /// <summary>
        /// Deletes all TextBoxes from he New -tab.
        /// </summary>
        /// @return Command.
        public RelayCommand DeleteAllTBoxCommand { get; set; }

        /// <summary>
        /// Open field related command.
        /// </summary>
        /// @return Command.
        public RelayCommand<string> OpenFieldInfoCommand
        {
            get
            {
                openFieldInfoCommand = new RelayCommand<string>(e => OpenFieldInfo(e));  // Gets chosen field's infotext as a parameter.
                return openFieldInfoCommand;
            }
            set
            {
                openFieldInfoCommand = value;
            }
        }

        /// <summary>
        /// Switch places of the buttons in results.
        /// </summary>
        /// @return Command.
        public RelayCommand<string> SwitchButtonsCommand
        {
            get
            {
                switchButtonsCommand = new RelayCommand<string>(e => SwitchButtons(e));  // Gets chosen field's name as a parameter.
                return switchButtonsCommand;
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
        /// Selected textfile.
        /// </summary>
        /// <returns>Textfile.</returns>
        public string TextFile
        {
            get
            {
                return currentModel.TextFile;
            }
            set
            {
                currentModel.TextFile = value;
                RaisePropertyChanged("TextFile");
            }
        }

        /// <summary>
        /// Determines if the New or Edit tab is in use.
        /// </summary>
        /// <returns>Used method.</returns>
        public string UsedMethod  // SelectedTabIndex replaces this and this will be removed.
        {
            get
            {
                return CurrentModel.UsedMethod;
            }
            set
            {
                CurrentModel.UsedMethod = value;
                RaisePropertyChanged("UsedMethod");
            }
        }

        /// <summary>
        /// The model we are now using.
        /// </summary>
        /// <returns>Descriptive model.</returns>
        public DescriptiveModel CurrentModel
        {
            get
            {
                return currentModel;
            }
            set
            {
                currentModel = value;
                RaisePropertyChanged("CurrentModel");
            }
        }

        /// <summary>
        /// Descriptive subModel.
        /// </summary>
        /// <returns>Descriptive submodel.</returns>
        public DescriptiveDataModel SubModel
        {
            get
            {
                return subModel;
            }
            set
            {
                subModel = value;
                RaisePropertyChanged("SubModel");
            }
        }

        /// <summary>
        /// Descriptive data model.
        /// </summary>
        /// <returns>Descriptive datamodel.</returns>
        public DescriptiveDataModel Model
        {
            get
            {
                return model;
            }
            set
            {
                model = value;
                RaisePropertyChanged("Model");
            }
        }

        /// <summary>
        /// Descriptive result model.
        /// </summary>
        /// <returns>Descriptive resultmodel.</returns>
        public DescriptiveResultModel Result
        {
            get
            {
                return result;
            }
            set
            {
                result = value;
                RaisePropertyChanged("DescriptiveResultModel");
            }
        }

        /// <summary>
        /// Determines which tab is selected.
        /// </summary>
        /// <returns>Integer representing the selected tab.</returns>
        public int SelectedTabIndex
        {
            get
            {
                return selectedTabIndex;
            }
            set
            {
                selectedTabIndex = value;
                RaisePropertyChanged("SelectedTabIndex");
            }
        }

        /// <summary>
        /// Run tool with user input.
        /// </summary>
        private async void RunTool()
        {
            logger.Info("-->{0}", this.GetType().Name);
            CurrentModel.OrderButtonVisibility = "Collapsed";            
            string rootFolder = settingsService.RootPath;
            if (CurrentModel.SelectedTabIndex == 0)
            {
                UsedMethod = "EditedFile";
            }
            else if (CurrentModel.SelectedTabIndex == 1)
            {
                UsedMethod = "NewFile";
            }
            if (Tab1UseModelName == false)
            {
                CurrentModel.Tab1ExtensionFolder = "";
            }
            if (Tab2UseModelName == false)
            {
                CurrentModel.Tab2ExtensionFolder = "";
            }
            // 1. Collect input parameters
            DescriptiveInputParams inputParams = new DescriptiveInputParams
            {
                TextFile = CurrentModel.TextFile,
                Method = UsedMethod,
                Tab1ExtensionFolder = CurrentModel.Tab1ExtensionFolder,
                Tab2ExtensionFolder = CurrentModel.Tab2ExtensionFolder
            };
            /*
            logger.Trace(
              "DescriptiveInputParams:\n" +
              "\tTextFile: '{0}'\n" +
              "\tExtensionFolder:'{1}'",
              inputParams.TextFile,
              inputParams.ExtensionFolder
            );
            */
            DescriptiveResult ddResult = default(DescriptiveResult);
            IsBusy = true;
            try
            {
                await Task.Run(() =>
                {
                    DescriptiveTool tool = new DescriptiveTool();
                    ddResult = tool.Execute(inputParams) as DescriptiveResult;
                    if (inputParams.Method == "NewFile")
                    {
                        // Clears all the lists (it is not sure if this will ever be done anymore).
                        if (TextFile == ddResult.OutputFile)
                        {
                            TextFile = "Select File";
                            while (TextBoxList.Count != 0)
                            {
                                TextBoxList.RemoveAt(0);
                            }
                            CurrentModel.SubFieldCountList.Clear();
                            textBoxList.Clear();
                            CurrentModel.FieldList.Clear();
                            CurrentModel.SubFieldList.Clear();
                            CurrentModel.AllSubFieldList.Clear();
                        }
                        // Creates StreamWriter for textfile and for textfile with marked fields.
                        StreamWriter createFile = new StreamWriter(ddResult.OutputFile);
                        StreamWriter createCharFile = new StreamWriter(ddResult.CharOutputFile);
                        createFile.Close();
                        createCharFile.Close();
                        // Now create two new StreamWriters which refer to FileStream of the previous two StreamWriters.
                        StreamWriter outputFile = new StreamWriter(new FileStream(ddResult.OutputFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default);
                        StreamWriter charOutputFile = new StreamWriter(new FileStream(ddResult.CharOutputFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default);
                        var document = DocX.Create(ddResult.WordOutputFile);
                        // Get all the fields and field related infos into text- and wordfiles.
                        foreach (DescriptiveDataModel child in newTextBoxList)
                        {
                            child.SwitchButtonVisibility = "Visible"; // Puts every Switch -button visible to Results -tab.
                            outputFile.WriteLine(child.NewFieldText);
                            document.InsertParagraph(child.NewFieldText + "\r\n").FontSize(16);
                            charOutputFile.WriteLine("#" + child.NewFieldText + "#");
                            charOutputFile.WriteLine(child.NewInfoText);
                            StringReader infoReader = new StringReader(child.NewInfoText);
                            string line = infoReader.ReadLine();
                            string text = "";
                            // Goes through all the subfield chars to make charless file. 
                            while (line != null)
                            {
                                string arrayLine = "";
                                string documentArrayLine = "";
                                if (line != "")
                                {
                                    if (line.First().Equals('¤'))
                                    {
                                        char[] charArray = line.ToCharArray();
                                        int index = 1;
                                        char lineChar = charArray[index];
                                        // Adds subfield into word file by removing chars that are used for parsing.
                                        while (lineChar != '¤' && index != charArray.Count())
                                        {
                                            lineChar = charArray[index];
                                            if (lineChar != '¤')
                                            {
                                                documentArrayLine = documentArrayLine + lineChar;
                                            }
                                            index++;
                                        }
                                        index = 0;
                                        lineChar = charArray[index];
                                        // Adds subfield into word file by removing chars that are used for parsing. This could use the same while loop than documentArrayLine.
                                        while (index != charArray.Count())
                                        {
                                            lineChar = charArray[index];
                                            if (lineChar != '¤')
                                            {
                                                arrayLine = arrayLine + lineChar;
                                            }
                                            index++;
                                        }
                                        line = arrayLine;
                                    }
                                }
                                text = text + line + "\r\n";
                                // Add subfield into wordfile.
                                if (documentArrayLine != "")
                                {
                                    arrayLine = arrayLine.Replace(documentArrayLine, "");
                                    Paragraph paragraph = document.InsertParagraph(documentArrayLine).FontSize(10).Bold();
                                    if (arrayLine != null || arrayLine != "")
                                    {
                                        paragraph.Append(arrayLine);
                                    }
                                }
                                else
                                {
                                    document.InsertParagraph(line).FontSize(10);
                                }
                                line = infoReader.ReadLine();
                            }
                            outputFile.WriteLine(text);  // Add charless text to textFile.
                            infoReader.Close();
                        }
                        document.Save();
                        NewTextBoxList.Last<DescriptiveDataModel>().SwitchButtonVisibility = "Collapsed";
                        ResultTextBoxList = NewTextBoxList;
                        outputFile.Close();
                        charOutputFile.Close();
                    }
                    else if (inputParams.Method == "EditedFile")
                    {
                        // Creates StreamWriter for textfile and for textfile with marked fields.
                        StreamWriter createFile = new StreamWriter(ddResult.OutputFile);
                        StreamWriter createCharFile = new StreamWriter(ddResult.CharOutputFile);
                        createFile.Close();
                        createCharFile.Close();
                        // Now create two new StreamWriter which refer to FileStream of the previous two.
                        StreamWriter outputFile = new StreamWriter(new FileStream(ddResult.OutputFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default);
                        StreamWriter charOutputFile = new StreamWriter(new FileStream(ddResult.CharOutputFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default);
                        var document = DocX.Create(ddResult.WordOutputFile);
                        // Get all the fields, field related infos and subfields into text- and wordfiles.
                        foreach (DescriptiveDataModel child in TextBoxList)
                        {
                            outputFile.WriteLine(child.FieldText);
                            document.InsertParagraph(child.FieldText + "\r\n").FontSize(16);
                            charOutputFile.WriteLine("#" + child.FieldText + "#");
                            if (child.ContainsSubFields == true)
                            {
                                foreach (DescriptiveDataModel subItem in child.SubTextBoxList)
                                {
                                    outputFile.WriteLine(subItem.SubFieldText);
                                    document.InsertParagraph(subItem.SubFieldText).FontSize(10).Bold();
                                    charOutputFile.WriteLine("¤" + subItem.SubFieldText + "¤");
                                    outputFile.WriteLine(subItem.SubInfoText);
                                    document.InsertParagraph(subItem.SubInfoText).FontSize(10);
                                    charOutputFile.WriteLine(subItem.SubInfoText);
                                }
                            }
                            else
                            {
                                outputFile.WriteLine(child.InfoText);
                                document.InsertParagraph(child.InfoText).FontSize(10);
                                charOutputFile.WriteLine(child.InfoText);
                            }
                        }
                        document.Save();
                        ResultTextBoxList = TextBoxList;
                        outputFile.Close();
                        charOutputFile.Close();
                    }
                    /*

                    logger.Info("calling DescriptiveTool.Execute(inputParams)");
                    logger.Trace("DescriptiveResult:\n" +
                      "\tEditedOutputFile: '{0}'\n" +
                      "\tNewOutputFile: '{1}'",
                      */
                    Result.OutputFile = ddResult.OutputFile;
                    // 3. Publish results
                });
                // Saves result folder path into list if the path aren't there already.
                var modelFolder = Path.Combine(inputParams.Env.RootPath, "DescModel", CurrentModel.Tab1ExtensionFolder);
                if (UsedMethod == "EditedFile" && !ModelNames.Contains(modelFolder))
                {
                    ModelNames.Add(modelFolder);
                }
                modelFolder = Path.Combine(inputParams.Env.RootPath, "DescModel", CurrentModel.Tab2ExtensionFolder);
                if (UsedMethod == "NewFile" && !ModelNames.Contains(modelFolder))
                {
                    ModelNames.Add(modelFolder);
                }
                string lastRunFile = Path.Combine(Path.Combine(settingsService.RootPath, "DescModel", "descriptive_last_run" + ".lastrun"));
                File.Create(lastRunFile);
                dialogService.ShowNotification("Descriptive Model tool completed successfully", "Success");
                LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to create textfile");
                dialogService.ShowNotification("Run failed. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                RunStatus = 0;
            }
            finally
            {
                IsBusy = false;
            }
            logger.Info("<--{0} completed", this.GetType().Name);
        }

        /// <summary>
        /// Read file with user input.
        /// </summary>
        private void ReadFile()
        {
            CurrentModel.RunVisibilityTab1 = "Visible";
            try
            {
                // Clear the list if it isn't empty.
                while (TextBoxList.Count != 0)
                {
                    TextBoxList.RemoveAt(0);
                }
                CurrentModel.SubFieldCountList.Clear();
                textBoxList.Clear();
                CurrentModel.FieldList.Clear();
                CurrentModel.SubFieldList.Clear();
                CurrentModel.AllSubFieldList.Clear();
                CurrentModel.TextFile = TextFile;
                string text = CurrentModel.TextFile;
                StreamReader file = new StreamReader(text, Encoding.Default); // If there's ever an error related to reading textfile, then it might be because this encoding isn't good enough to read the text.                
                SetupFieldList(file); // Get fields from textfile.
                // Clear the array if it isn't empty.
                if (CurrentModel.TextArray.Length != 0)
                {
                    List<string> arraylist = CurrentModel.TextArray.ToList();
                    arraylist.Clear();
                    CurrentModel.TextArray = arraylist.ToArray();
                }
                CurrentModel.TextArray = new string[CurrentModel.FieldList.Count];
                string titleText = ""; // String for possible titletext, not currently used.                
                file = new StreamReader(text, Encoding.Default); // New streamreader to go through again the file to get field related infos.
                string line = file.ReadLine();
                SetupInfoArray(file, line, titleText); // Get field related infos from textfile.
                int arrayIndex = 0;
                int[] subFieldCountArray = CurrentModel.SubFieldCountList.ToArray(); // Array which has information of how many subfields are per field.
                List<string>.Enumerator SubFieldEnumerator = CurrentModel.AllSubFieldList.GetEnumerator();
                SubFieldEnumerator.MoveNext();
                // Updates field, field related infos and subfields into interface.
                foreach (string item in CurrentModel.FieldList)
                {
                    Model = new DescriptiveDataModel();
                    Model.SubTextBoxList = new ObservableCollection<DescriptiveDataModel>();
                    Model.FieldText = item;
                    Model.InfoText = CurrentModel.TextArray[arrayIndex];
                    Model.SwitchButtonVisibility = "Visible";
                    if (subFieldCountArray[arrayIndex] != 0)
                    {
                        CurrentModel.SubTextArray = new string[subFieldCountArray[arrayIndex]];
                        Model.ContainsSubFields = true;
                        SortSubFields(CurrentModel.TextArray[arrayIndex], SubFieldEnumerator); // Get this fields subfields and subfield related infos.
                        int subArrayIndex = 0;
                        foreach (string subItem in CurrentModel.SubFieldList)
                        {
                            SubModel = new DescriptiveDataModel();
                            SubModel.SubFieldText = subItem;
                            SubModel.SubInfoText = CurrentModel.SubTextArray[subArrayIndex];
                            Model.SubTextBoxList.Add(SubModel);
                            subArrayIndex++;
                        }
                    }
                    else
                    {
                        Model.ContainsSubFields = false; // Tells interface that the field doesn't contain subfields.
                    }
                    TextBoxList.Add(Model);
                    arrayIndex++;
                }
                TextBoxList.Last<DescriptiveDataModel>().SwitchButtonVisibility = "Collapsed"; // In the resultview the last button for switching the places of the fields has no use.
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to read textfile");
                dialogService.ShowNotification("Failed to read the file. Check output for details\r\n - Are all input and output files closed ?", "Error");
                TextFile = "Select File";
            }
        }

        /// <summary>
        /// Gathers fields from file into the list.
        /// </summary>
        /// <param name="file">File stream.</param>
        private void SetupFieldList(StreamReader file)
        {
            string line;
            while (file.EndOfStream != true)
            {
                string text = "";
                line = file.ReadLine();  // "line" refers always to current line.
                if (line != "")
                {
                    char[] charArray = line.ToCharArray();
                    line = line.First().ToString();
                    // Check if the line is a field
                    if (line.First().Equals('#'))
                    {
                        int i = 1;
                        char c = charArray[i];
                        {
                            text = text + c;
                        }
                        i++;
                        // Read all the chars from the field until it ends.
                        while (c != '#')
                        {
                            c = charArray[i];
                            if (c != '#')
                            {
                                text = text + c;
                            }
                            i++;
                        }
                        CurrentModel.FieldList.Add(text);
                    }
                    //check if the line is a subfield.
                    if (line.First().Equals('¤'))
                    {
                        int i = 1;
                        char c = charArray[i];
                        {
                            text = text + c;
                        }
                        i++;
                        // Read all the chars from the subfield until it ends.
                        while (c != '¤')
                        {
                            c = charArray[i];
                            if (c != '¤')
                            {
                                text = text + c;
                            }
                            i++;
                        }
                        CurrentModel.AllSubFieldList.Add(text);
                    }
                }
            }
            file.Close();
        }

        /// <summary>
        /// Gathers field related info texts into array.
        /// </summary>
        /// <param name="file">File stream</param>
        /// <param name="line">Current line</param>
        /// <param name="titleText">TitleText. Not currently in use.</param>
        private void SetupInfoArray(StreamReader file, string line, string titleText)
        {
            string deleteWord = "";
            int subFieldCount = 0;
            int arrayIndex = 0;
            List<string>.Enumerator enumerator = CurrentModel.FieldList.GetEnumerator();
            List<string>.Enumerator SubFieldEnumerator = CurrentModel.AllSubFieldList.GetEnumerator();
            while (file.EndOfStream != true)
            {
                if (line != "")
                {
                    // If line contains a field, then the field will be removed from the line and loop will continue reading lines containing field related info.
                    if (line.First().Equals('#'))
                    {
                        subFieldCount = 0;
                        if (enumerator.MoveNext() != false)
                        {
                            deleteWord = "#" + enumerator.Current + "#";

                            line = line.Replace(deleteWord, "");  // Removes the field from the line.
                            // If there's empty lines in the start, then jump over them.
                            while (line == "")
                            {
                                line = file.ReadLine();
                            }
                            bool stop = false;
                            // Reads field related info until the next field or if the file ends.
                            while (stop != true)
                            {
                                switch (line)
                                {
                                    // If line is empty.
                                    case "":
                                        CurrentModel.TextArray[arrayIndex] = CurrentModel.TextArray[arrayIndex] + line + "\r\n";
                                        line = file.ReadLine();
                                        break;
                                    // If the line is null, file ends.
                                    case null:
                                        stop = true;
                                        break;
                                    default:
                                        // If line contains subfield.
                                        if (line.First().Equals('¤'))
                                        {
                                            if (SubFieldEnumerator.MoveNext() != false)
                                            {
                                                CurrentModel.TextArray[arrayIndex] = CurrentModel.TextArray[arrayIndex] + line + "\r\n";
                                                line = file.ReadLine();
                                                subFieldCount++;  // Rises count of subfields in the field.
                                                break;
                                            }
                                        }
                                        // If line contains field.
                                        else if (line.First().Equals('#'))
                                        {

                                            stop = true;
                                            // This happens if the field is empty. This is to prevent an infinite loop (needs a more precise way to do this).
                                            if (line == "##")
                                            {
                                                line = file.ReadLine();
                                            }
                                            break;
                                        }
                                        // If line only contains text and nothing above.
                                        else
                                        {
                                            CurrentModel.TextArray[arrayIndex] = CurrentModel.TextArray[arrayIndex] + line + "\r\n";
                                            line = file.ReadLine();
                                        }
                                        break;
                                }
                            }
                            CurrentModel.SubFieldCountList.Add(subFieldCount);
                            arrayIndex++;
                        }
                    }
                    // If there was no field on the line, then jump into next line.
                    else
                    {
                        titleText = titleText + line + "\r\n";  // Titletext is not currently used.
                        line = file.ReadLine();
                    }
                }
                // If the line was empty, jump into next line.
                else
                {
                    line = file.ReadLine();
                }
            }
            file.Close();
        }

        /// <summary>
        /// Gets subfields and subfield infos.
        /// </summary>
        /// <param name="fieldInfoText">Text where the subfields will be gathered.</param>
        /// <param name="SubFieldEnumerator">Enumerator of subfields</param>
        private void SortSubFields(string fieldInfoText, List<string>.Enumerator SubFieldEnumerator)
        {
            string deleteWord = "";
            int arrayIndex = 0;

            StringReader infoReader = new StringReader(fieldInfoText);  // StringReader is used instead of Streamreader since this method doesn't read a file.
            string line = infoReader.ReadLine();
            CurrentModel.SubFieldList.Clear();  // Clear the list so that the previous subfields that prever to a different field don't stay in the list.
            // Read lines from inforeader until the line is null.
            while (line != null)
            {
                if (line != "")
                {
                    // If line contains a field, then the field will be removed from the line and loop will continue reading lines containing field related info.
                    if (line.First().Equals('¤'))
                    {
                        bool fieldStop = false;  // Seems to be not currently used effectively.
                        if (fieldStop != true || line != null)
                        {
                            CurrentModel.SubFieldList.Add(SubFieldEnumerator.Current);
                            deleteWord = "¤" + SubFieldEnumerator.Current + "¤";
                            line = line.Replace(deleteWord, "");  // Removes field from the line.
                            bool infoStop = false;
                            // Reads field related info until the next field or if the file ends
                            while (infoStop != true)
                            {
                                switch (line)
                                {
                                    // If line is empty.
                                    case "":
                                        CurrentModel.SubTextArray[arrayIndex] = CurrentModel.SubTextArray[arrayIndex] + line + "\r\n";
                                        line = infoReader.ReadLine();
                                        break;
                                    // If the line is null, file ends.
                                    case null:
                                        fieldStop = true;
                                        infoStop = true;
                                        break;
                                    default:
                                        // If line contains field.
                                        if (line.First().Equals('#'))
                                        {
                                            fieldStop = true;
                                            infoStop = true;
                                        }
                                        // If line contains subfield.
                                        else if (line.First().Equals('¤'))
                                        {
                                            infoStop = true;
                                        }
                                        // If line only contains text and nothing above.
                                        else
                                        {
                                            CurrentModel.SubTextArray[arrayIndex] = CurrentModel.SubTextArray[arrayIndex] + line + "\r\n";
                                            line = infoReader.ReadLine();
                                        }
                                        break;
                                }
                            }
                            SubFieldEnumerator.MoveNext();  // Move to next subfield.
                            arrayIndex++;
                        }
                    }
                    // If there was no field on the line, then jump into next line.
                    else
                    {
                        // There could be titletext for a subfield here, but right now we don't take note of it.
                        line = infoReader.ReadLine();
                    }
                }
                // If the line was empty, jump into next line.
                else
                {
                    line = infoReader.ReadLine();
                }
            }
            infoReader.Close();
        }

        /// <summary>
        /// Method stub to show Select Model -dialog
        /// </summary>
        public void OpenModelDialog()
        {
            try
            {
                viewModelLocator.Main.DialogContentSource = "DescriptiveViewModel";
                dialogService.ShowMessageDialog();
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show MessgeDialog");
                dialogService.ShowNotification("Failed to show MessgeDialog", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Text files|*.txt;", true, true);
                if (!string.IsNullOrEmpty(textFile))
                {
                    TextFile = textFile;
                    ReadFile();
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog");
            }
        }

        /// <summary>
        /// Add first new TextBoxes into "New" -tab in DescriptiveInputView.
        /// </summary>
        private void AddFirstTBox()
        {
            try
            {
                // Makes sure that there will not be textBoxes in the user interface when you are not able ton run the tool.
                if (CurrentModel.RunVisibilityTab2.ToString() == "Collapsed")
                {
                    while (NewTextBoxList.Count != 0)
                    {
                        NewTextBoxList.RemoveAt(0);
                    }
                }
                CurrentModel.RunVisibilityTab2 = "Visible";
                DescriptiveDataModel descriptiveModel = new DescriptiveDataModel();
                // Add empty field and field related info into the user interface.
                descriptiveModel.NewFieldText = "";
                descriptiveModel.NewInfoText = "";
                descriptiveModel.SwitchButtonVisibility = "Visible";
                int MyNumber = 0;
                Random random = new Random();
                MyNumber = random.Next(0, 1000);
                if (!CurrentModel.RandomList.Contains(MyNumber))
                {
                    CurrentModel.RandomList.Add(MyNumber);
                }
                descriptiveModel.NewFieldId = MyNumber;  // Each model has a specific ID, which is needed for searching a specific model.
                newTextBoxList.Insert(0, descriptiveModel);
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to add TextBox");
                dialogService.ShowNotification("Failed to add TextBox", "Error");
            }
        }

        /// <summary>
        /// Add new TextBoxes into "New" -tab in DescriptiveInputView.
        /// </summary>
        /// <param name="currentFieldId">Id for the textBox.</param>
        private void AddTBox(int currentFieldId)
        {
            CurrentModel.RunVisibilityTab2 = "Visible";
            DescriptiveDataModel descriptiveModel = new DescriptiveDataModel();
            // Add empty field and field related info into the user interface.
            descriptiveModel.NewFieldText = "";
            descriptiveModel.NewInfoText = "";
            descriptiveModel.SwitchButtonVisibility = "Visible";
            try
            {
                int MyNumber = 0;
                Random random = new Random();
                MyNumber = random.Next(0, 1000);
                if (!CurrentModel.RandomList.Contains(MyNumber))
                {
                    CurrentModel.RandomList.Add(MyNumber);
                }
                descriptiveModel.NewFieldId = MyNumber;  // Each model has a specific ID, which is needed for searching a specific model.
                int currentFieldIndex = -1;  // Index is initialized into a -1 so that if any of the ID's is not found, the model will be added to start.
                foreach (DescriptiveDataModel item in NewTextBoxList)
                {
                    // Depending on which of the Add TextBox -buttons is clicked, get the button's model ID and this new model after that model.
                    if (item.NewFieldId == currentFieldId)
                    {
                        currentFieldIndex = NewTextBoxList.IndexOf(item);
                    }
                }
                NewTextBoxList.Insert(currentFieldIndex + 1, descriptiveModel);
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to add field");
                dialogService.ShowNotification("Failed to add field", "Error");
            }
        }

        /// <summary>
        /// Add new TextBoxes into "New" -tab in DescriptiveInputView.
        /// </summary>
        /// <param name="currentFieldId">Id of the textbox that will be deleted.</param>
        private void DeleteTBox(int currentFieldId)
        {
            try
            {
                DescriptiveDataModel deleteItem = null;
                foreach (DescriptiveDataModel item in NewTextBoxList)
                {
                    // Delete item model which has the specific ID.
                    if (item.NewFieldId == currentFieldId)
                    {
                        CurrentModel.RandomList.Remove(item.NewFieldId);
                        deleteItem = item;
                    }
                }
                NewTextBoxList.Remove(deleteItem);
                // If there are not textboxes anymore, then the Run Tool -button will be hided.
                if (NewTextBoxList.Count == 0)
                {
                    CurrentModel.RunVisibilityTab2 = "Collapsed";
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to delete field");
                dialogService.ShowNotification("Failed to delete field", "Error");
            }
        }

        /// <summary>
        /// Delete all TextBoxes from "New" -tab in DescriptiveInputView.
        /// </summary>
        private void DeleteAllTBox()
        {
            try
            {
                while (NewTextBoxList.Count != 0)
                {
                    NewTextBoxList.RemoveAt(0);
                }
                CurrentModel.RunVisibilityTab2 = "Collapsed";
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to delete fields");
                dialogService.ShowNotification("Failed to delete fields", "Error");
            }
        }

        /// <summary>
        /// Switches places of the fields in DescriptiveResultView.
        /// </summary>
        /// <param name="field">Field whom place will be switched.</param>
        private void SwitchButtons(string field)
        {
            try
            {
                DescriptiveDataModel fieldsModel = null;
                if (UsedMethod == "EditedFile")
                {
                    foreach (DescriptiveDataModel item in TextBoxList)
                    {
                        // If the field's name is same, then switch place of this field.
                        if (field == item.FieldText)
                        {
                            fieldsModel = item;
                        }
                    }
                    if (fieldsModel != null)
                    {
                        int index = TextBoxList.IndexOf(fieldsModel);
                        // Switch places only if there's room at thye end of a list.
                        if (TextBoxList.Count != index + 1)
                        {
                            TextBoxList.Move(index, index + 1);
                            // This makes sure that the last Switch -button is not visible (since it's the last one, it doesn't switch any field's place).
                            if (index + 2 == TextBoxList.Count())
                            {
                                TextBoxList.ElementAt(index).SwitchButtonVisibility = "Visible";
                                TextBoxList.ElementAt(index + 1).SwitchButtonVisibility = "Collapsed";
                            }
                        }
                    }
                    CurrentModel.OrderButtonVisibility = "Visible";
                }
                if (UsedMethod == "NewFile")
                {
                    foreach (DescriptiveDataModel item in NewTextBoxList)
                    {
                        // If the field's name is same, then we chose to switch place of this field.
                        if (field == item.NewFieldText)
                        {
                            fieldsModel = item;
                        }
                    }
                    if (fieldsModel != null)
                    {
                        int index = NewTextBoxList.IndexOf(fieldsModel);
                        if (NewTextBoxList.Count != index + 1)
                        {
                            NewTextBoxList.Move(index, index + 1);
                            // This makes sure that the last Switch -button is not visible(since it's the last one, it doesn't switch field's place).
                            if (index + 2 == NewTextBoxList.Count())
                            {
                                NewTextBoxList.ElementAt(index).SwitchButtonVisibility = "Visible";
                                NewTextBoxList.ElementAt(index + 1).SwitchButtonVisibility = "Collapsed";
                            }
                        }
                    }
                    CurrentModel.OrderButtonVisibility = "Visible";
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to edit field order");
                dialogService.ShowNotification("Failed to edit field order", "Error");
            }
        }

        /// <summary>
        /// Open field related info by clicking field button in result tab.
        /// </summary>
        /// <param name="text">Text that will showed in the user interface.</param>
        private void OpenFieldInfo(string text)
        {
            try
            {
                foreach (var field in CurrentModel.SubFieldList)
                {
                    // Right now this does linebreak even when there's aleady is a linebreak, so the result is two linebreaks instead of one.
                    text = text.Replace("¤" + field + "¤", field + "\r\n");
                }
                Model.ResultText = text;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show field info");
                dialogService.ShowNotification("Failed to show field info", "Error");
            }
        }

        /// <summary>
        /// Loads last session for 'New' -tab.
        /// </summary>
        /// <param name="newTextFile">Path to file that will be loaded.</param>
        public void LoadLastNewTabSession(string newTextFile)
        {
            CurrentModel.RunVisibilityTab2 = "Visible";

            try
            {
                // Clear the list it is not empty.
                while (NewTextBoxList.Count != 0)
                {
                    NewTextBoxList.RemoveAt(0);
                }
                NewTextBoxList.Clear();
                CurrentModel.FieldList.Clear();
                StreamReader file = new StreamReader(newTextFile, Encoding.Default);  // If there's ever an error related to reading textfile, then it might be because this encoding isn't good enough to read the text.                
                SetupFieldList(file);  // Get fields from textfile.
                // Clear the array it is not empty.
                if (CurrentModel.TextArray.Length != 0)
                {
                    List<string> arraylist = CurrentModel.TextArray.ToList();
                    arraylist.Clear();
                    CurrentModel.TextArray = arraylist.ToArray();
                }
                CurrentModel.TextArray = new string[CurrentModel.FieldList.Count];
                string titleText = "";  // String for possible titletext. This is not currently used.                
                file = new StreamReader(newTextFile, Encoding.Default);  // New streamreader to go through again the file to get field related infos.
                string line = file.ReadLine();
                SetupInfoArray(file, line, titleText);  // Get field related infos from textfile.
                int arrayIndex = 0;
                // Adds all field related textboxes into user interface.
                foreach (string item in CurrentModel.FieldList)
                {
                    if (NewTextBoxList.Count() == 0)
                    {
                        AddFirstTBox();
                    }
                    else
                    {
                        AddTBox(NewTextBoxList.ElementAt(arrayIndex - 1).NewFieldId);
                    }
                    Model = NewTextBoxList.ElementAt(arrayIndex);
                    Model.NewFieldText = item;
                    Model.NewInfoText = CurrentModel.TextArray[arrayIndex];
                    Model.SwitchButtonVisibility = "Visible";
                    arrayIndex++;
                }
                // In some cases the list has been empty. This makes sure that the Run Tool -button is hidden if list is empty.
                if (NewTextBoxList.Count() == 0)
                {
                    CurrentModel.RunVisibilityTab2 = "Collapsed";
                }
                // The last of the buttons doesn't do anything so it can't be visible.
                if (NewTextBoxList.Count() != 0)
                {
                    NewTextBoxList.Last<DescriptiveDataModel>().SwitchButtonVisibility = "Collapsed";
                }
                CurrentModel.OrderButtonVisibility = "Collapsed";
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to read textfile in 'New' -tab");
                dialogService.ShowNotification("Failed to read the file in 'New' -tab. Check output for details", "Error");
            }
        }

        /// <summary>
        /// Select certain result.
        /// </summary>
        private void SelectResult()
        {
            if (ModelNames.Count > 0)
            {
                if (SaveToDepositModels == true && DepositModelsExtension.Length == 0)
                {
                    NoFolderNameGiven = true;
                    return;
                }
                try
                {
                    var modelDirPath = ModelNames[SelectedModelIndex];
                    var modelDirInfo = new DirectoryInfo(ModelNames[SelectedModelIndex]);
                    var gtRootPath = Path.Combine(settingsService.RootPath, "DescModel", "SelectedResult");
                    if (!Directory.Exists(gtRootPath))
                    {
                        Directory.CreateDirectory(gtRootPath);
                    }
                    if (modelDirPath != gtRootPath)
                    {
                        DirectoryInfo dir = new DirectoryInfo(gtRootPath);
                        // Deletes all files and directorys before adding new files.
                        foreach (FileInfo file in dir.GetFiles())
                        {
                            file.Delete();
                        }
                        foreach (DirectoryInfo direk in dir.GetDirectories())
                        {
                            direk.Delete(true);
                        }
                        // Select files from selected model root folder and add them into SelectedResult folder.
                        foreach (FileInfo file2 in modelDirInfo.GetFiles())
                        {
                            var destPath = Path.Combine(gtRootPath, file2.Name);
                            var sourcePath = Path.Combine(modelDirPath, file2.Name);
                            if (File.Exists(destPath))
                            {
                                File.Delete(destPath);
                            }
                            File.Copy(sourcePath, destPath);  // Copy files to new Root folder.
                            if (SaveToDepositModels == true)
                            {
                                var depositPath = Path.Combine(settingsService.DepositModelsPath, "DepositModels", "Descriptive", DepositModelsExtension);
                                Directory.CreateDirectory(depositPath);
                                destPath = Path.Combine(depositPath, file2.Name);
                                var depositDirInfo = new DirectoryInfo(depositPath);
                                if (File.Exists(destPath))
                                {
                                    File.Delete(destPath);
                                }
                                File.Copy(sourcePath, destPath);
                            }
                        }
                    }
                    else
                    {
                        if (SaveToDepositModels == true)
                        {
                            // Select files from selected model root folder
                            foreach (FileInfo file in modelDirInfo.GetFiles())
                            {
                                var sourcePath = Path.Combine(modelDirPath, file.Name);
                                var depositPath = Path.Combine(settingsService.DepositModelsPath, "DepositModels", "Descriptive", DepositModelsExtension);
                                Directory.CreateDirectory(depositPath);
                                var destPath = Path.Combine(depositPath, file.Name);
                                var depositDirInfo = new DirectoryInfo(depositPath);
                                if (File.Exists(destPath))
                                {
                                    File.Delete(destPath);
                                }
                                File.Copy(sourcePath, destPath);
                            }
                            foreach (DirectoryInfo di in modelDirInfo.GetDirectories())
                            {
                                var newDirPath = Path.Combine(gtRootPath, di.Name);
                                string sourcePath;
                                string destPath;
                                DirectoryInfo newDirInfo = new DirectoryInfo(newDirPath);
                                Directory.CreateDirectory(Path.Combine(settingsService.DepositModelsPath, "DepositModels", "Descriptive", DepositModelsExtension, di.Name));
                                foreach (FileInfo file2 in di.GetFiles())
                                {
                                    sourcePath = Path.Combine(modelDirPath, di.Name, file2.Name);
                                    destPath = Path.Combine(settingsService.DepositModelsPath, "DepositModels", "Descriptive", DepositModelsExtension, di.Name, file2.Name);
                                    File.Copy(sourcePath, destPath);
                                }
                            }
                        }
                    }
                    // Get parameters of the selected project.
                    DescriptiveInputParams inputParams = new DescriptiveInputParams();
                    string projectFolder = Path.Combine(settingsService.RootPath, "DescModel");
                    string selectedProjectFolder = Path.Combine(settingsService.RootPath, "DescModel", "SelectedResult");
                    string param_json = Path.Combine(selectedProjectFolder, "descriptive_input_params.json");
                    // Clear ResultTextBox list so that new results can be added.
                    while (ResultTextBoxList.Count != 0)
                    {
                        ResultTextBoxList.RemoveAt(0);
                    }
                    if (File.Exists(param_json))
                    {
                        inputParams.Load(param_json);
                        CurrentModel.UsedMethod = inputParams.Method;
                        if (File.Exists(Path.Combine(projectFolder, inputParams.Tab1ExtensionFolder, "DescriptiveModel(Chars).txt")))
                        {
                            CurrentModel.TextFile = Path.Combine(projectFolder, inputParams.Tab1ExtensionFolder, "DescriptiveModel(Chars).txt");

                            CurrentModel.Tab1ExtensionFolder = inputParams.Tab1ExtensionFolder;
                            CurrentModel.RunVisibilityTab1 = "Visible";

                            TextFile = CurrentModel.TextFile;
                            ReadFile();
                        }
                        if (File.Exists(Path.Combine(projectFolder, inputParams.Tab2ExtensionFolder, "DescriptiveNewModel(Chars).txt")))
                        {
                            CurrentModel.Tab2ExtensionFolder = inputParams.Tab2ExtensionFolder;
                            CurrentModel.RunVisibilityTab2 = "Visible";
                            LoadLastNewTabSession(Path.Combine(projectFolder, "DescriptiveNewModel(Chars).txt"));
                        }
                        // Information for reporting tool about selected model.
                        if (CurrentModel.UsedMethod == "EditedFile")
                        {
                            viewModelLocator.ReportingViewModel.DescModelPath = Path.Combine(gtRootPath, "DescriptiveModel(docx).docx");
                            viewModelLocator.ReportingViewModel.DescModelName = Path.GetFileName(modelDirPath);
                            viewModelLocator.ReportingViewModel.SaveInputs();
                        }
                        else if (CurrentModel.UsedMethod == "NewFile")
                        {
                            viewModelLocator.ReportingViewModel.DescModelPath = Path.Combine(gtRootPath, "DescriptiveNewModel(docx).docx");
                            viewModelLocator.ReportingViewModel.DescModelName = Path.GetFileName(modelDirPath);
                            viewModelLocator.ReportingViewModel.SaveInputs();
                        }
                    }
                    dialogService.ShowNotification("Model selected successfully", "Success");
                }
                catch (Exception ex)
                {
                    logger.Trace(ex, "Error in Model Selection:");
                    dialogService.ShowNotification("Failed to select model", "Error");
                }
                NoFolderNameGiven = false;
                var metroWindow = (Application.Current.MainWindow as MetroWindow);
                var dialog = metroWindow.GetCurrentDialogAsync<BaseMetroDialog>();
                metroWindow.HideMetroDialogAsync(dialog.Result);
            }
        }

        /// <summary>
        /// Find all saved results, which have been made by past runs.
        /// </summary>
        /// <param name="projectFolder">Folder containing past result folders</param>
        private void FindModelnames(string projectFolder)
        {
            DirectoryInfo projectFolderInfo = new DirectoryInfo(projectFolder);
            // Goes through all the existing models.
            foreach (DirectoryInfo model in projectFolderInfo.GetDirectories())
            {
                if (model.Name != "SelectedResult")
                {
                    foreach (FileInfo file in model.GetFiles())
                    {
                        if (file.Name == "descriptive_input_params.json")
                        {
                            ModelNames.Add(model.FullName);
                        }
                    }
                }
            }
            // Goes also through the main folder.
            foreach (FileInfo file in projectFolderInfo.GetFiles())
            {
                if (file.Name == "descriptive_input_params.json")
                {
                    ModelNames.Add(projectFolderInfo.FullName);
                }
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
        /// Determines if the user gave name to a folder. Binded in MainWindow.xaml.
        /// </summary>
        /// <returns>Boolean representing the choice.</returns>
        public bool NoFolderNameGiven
        {
            get { return noFolderNameGiven; }
            set
            {
                if (value == noFolderNameGiven) return;
                noFolderNameGiven = value;
                RaisePropertyChanged("NoFolderNameGiven");
            }
        }

        /// <summary>
        /// Check if tool can be executed (not busy).
        /// </summary>
        /// <returns>Boolean representing the state.</returns>
        public bool CanRunTool()
        {
            return !IsBusy;
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
                RunToolCommand.RaiseCanExecuteChanged();
                SelectFileCommand.RaiseCanExecuteChanged();
            }
        }
    }
}
