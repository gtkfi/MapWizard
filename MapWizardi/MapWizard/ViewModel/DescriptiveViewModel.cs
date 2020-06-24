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
            currentModel = new DescriptiveModel();
            model = new DescriptiveDataModel();
            subModel = new DescriptiveDataModel();
            result = new DescriptiveResultModel();
            viewModelLocator = new ViewModelLocator();
            RunToolCommand = new RelayCommand(RunTool, CanRunTool);
            SelectFileCommand = new RelayCommand(SelectFile, CanRunTool);
            SelectWordCommand = new RelayCommand(SelectWordDocument, CanRunTool);
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
                        WordFile = inputParams.WordFile,
                        UsedMethod = inputParams.Method,
                        RunVisibilityTab1 = "Visible",
                        RunVisibilityTab2 = "Collapsed",
                    };
                }
                catch (Exception ex)
                {
                    CurrentModel = new DescriptiveModel();
                    logger.Error(ex, "Failed to read json file");
                    dialogService.ShowNotification("Couldn't load Descriptive model tool's inputs correctly. Inputs were initialized to default values.", "Error");
                    viewModelLocator.SettingsViewModel.WriteLogText("Couldn't load Descriptive model tool's inputs correctly. Inputs were initialized to default values.", "Error");
                }
                LoadResults(selectedProjectFolder);
            }
            else
            {
                CurrentModel = new DescriptiveModel();
            }
            string projectFolder = Path.Combine(settingsService.RootPath, "DescModel");
            FindModelnames(projectFolder);  // Get all previous result folders.
            var lastRunFile = Path.Combine(projectFolder, "descriptive_last_run.lastrun");
            if (File.Exists(lastRunFile))
            {
                CurrentModel.LastRunDate = "Last Run: " + (new FileInfo(lastRunFile)).LastWriteTime.ToString();
            }
        }

        /// <summary>
        /// Select file command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectFileCommand { get; set; }

        /// <summary>
        /// Select Word document file command.
        /// </summary>
        /// @return Command.
        public RelayCommand SelectWordCommand { get; set; }

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
        /// Run tool with user input.
        /// </summary>
        private async void RunTool()
        {
            logger.Info("-->{0}", this.GetType().Name);
            CurrentModel.OrderButtonVisibility = "Collapsed";
            string rootFolder = settingsService.RootPath;
            if (CurrentModel.SelectedTabIndex == 0)
            {
                CurrentModel.UsedMethod = "WordFile";
            }
            else if (CurrentModel.SelectedTabIndex == 1)
            {
                CurrentModel.UsedMethod = "EditedFile";
            }
            else if (CurrentModel.SelectedTabIndex == 2)
            {
                CurrentModel.UsedMethod = "NewFile";
            }
            if (CurrentModel.Tab1UseModelName == false)
            {
                CurrentModel.Tab1ExtensionFolder = "";
            }
            if (CurrentModel.Tab2UseModelName == false)
            {
                CurrentModel.Tab2ExtensionFolder = "";
            }
            // 1. Collect input parameters
            DescriptiveInputParams inputParams = new DescriptiveInputParams
            {
                TextFile = CurrentModel.TextFile,
                WordFile = CurrentModel.WordFile,
                Method = CurrentModel.UsedMethod,
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
            CurrentModel.IsBusy = true;
            try
            {
                await Task.Run(() =>
                {
                    DescriptiveTool tool = new DescriptiveTool();
                    ddResult = tool.Execute(inputParams) as DescriptiveResult;
                    if (inputParams.Method == "WordFile")
                    {
                        if (DocX.Load(CurrentModel.WordFile) != null)
                        {
                            string descPath = Path.Combine(inputParams.Env.RootPath, "DescModel");
                            DirectoryInfo dir = new DirectoryInfo(Path.Combine(descPath, "SelectedResult"));
                            // Deletes all files and directorys before adding new files.
                            foreach (FileInfo file in dir.GetFiles())
                            {
                                file.Delete();
                            }
                            foreach (DirectoryInfo direk in dir.GetDirectories())
                            {
                                direk.Delete(true);
                            }
                            using (var outputDocument = DocX.Create(ddResult.WordOutputFile))
                            {
                                using (var inputDocument = DocX.Load(CurrentModel.WordFile))
                                {
                                    outputDocument.InsertDocument(inputDocument, true);
                                }
                                outputDocument.Save();
                            }
                            File.Copy(Path.Combine(descPath, "descriptive_input_params.json"), Path.Combine(descPath, "SelectedResult", "descriptive_input_params.json"));
                            viewModelLocator.ReportingViewModel.Model.DescModelPath = Path.Combine(ddResult.WordOutputFile);
                            viewModelLocator.ReportingViewModel.Model.DescModelName = Path.GetFileName(Path.Combine(inputParams.Env.RootPath, "DescModel"));
                            viewModelLocator.ReportingViewModel.SaveInputs();
                            viewModelLocator.ReportingAssesmentViewModel.Model.DescModelPath = Path.Combine(ddResult.WordOutputFile);
                            viewModelLocator.ReportingAssesmentViewModel.Model.DescModelName = Path.GetFileName(Path.Combine(inputParams.Env.RootPath, "DescModel"));
                            viewModelLocator.ReportingAssesmentViewModel.SaveInputs();
                            // Create textfile containing name of selected model.
                            string modelNameFile = Path.Combine(descPath, "SelectedResult", "DescModelName.txt");
                            File.Create(modelNameFile).Close();
                            using (StreamWriter writeStream = new StreamWriter(new FileStream(modelNameFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default))
                            {
                                writeStream.Write(Path.GetFileName(Path.Combine(inputParams.Env.RootPath, "DescModel")) + "," + ddResult.WordOutputFile);
                            }
                        }
                    }
                    else if (inputParams.Method == "EditedFile")
                    {
                        // Creates files of textfile and of textfile with marked fields.
                        File.Create(ddResult.OutputFile).Close();
                        File.Create(ddResult.CharOutputFile).Close();
                        // Now create two new StreamWriter which refer to FileStream of the previous two.
                        StreamWriter outputFile = new StreamWriter(new FileStream(ddResult.OutputFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default);
                        StreamWriter charOutputFile = new StreamWriter(new FileStream(ddResult.CharOutputFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default);
                        try
                        {
                            using (var document = DocX.Create(ddResult.WordOutputFile))
                            {
                                // Get all the fields, field related infos and subfields into text- and wordfiles.
                                foreach (DescriptiveDataModel child in CurrentModel.TextBoxList)
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
                                CurrentModel.ResultTextBoxList = CurrentModel.TextBoxList;
                            }
                            outputFile.Close();
                            charOutputFile.Close();
                        }
                        finally
                        {
                            outputFile.Close();
                            charOutputFile.Close();
                        }
                    }
                    else if (inputParams.Method == "NewFile")
                    {
                        // Clears all the lists (it is not sure if this will ever be done anymore).
                        if (CurrentModel.TextFile == ddResult.OutputFile)
                        {
                            CurrentModel.TextFile = "Select File";
                            while (CurrentModel.TextBoxList.Count != 0)
                            {
                                CurrentModel.TextBoxList.RemoveAt(0);
                            }
                            CurrentModel.SubFieldCountList.Clear();
                            CurrentModel.TextBoxList.Clear();
                            CurrentModel.FieldList.Clear();
                            CurrentModel.SubFieldList.Clear();
                            CurrentModel.AllSubFieldList.Clear();
                        }
                        // Creates files of textfile and of textfile with marked fields.
                        File.Create(ddResult.OutputFile).Close();
                        File.Create(ddResult.CharOutputFile).Close();
                        StreamWriter outputFile = new StreamWriter(new FileStream(ddResult.OutputFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default);
                        StreamWriter charOutputFile = new StreamWriter(new FileStream(ddResult.CharOutputFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default);
                        try
                        {
                            using (var document = DocX.Create(ddResult.WordOutputFile))
                            {
                                // Get all the fields and field related infos into text- and wordfiles.
                                foreach (DescriptiveDataModel child in CurrentModel.NewTextBoxList)
                                {
                                    child.SwitchButtonVisibility = "Visible"; // Puts every Switch -button visible to Results -tab.
                                    outputFile.WriteLine(child.NewFieldText);
                                    document.InsertParagraph(child.NewFieldText + "\r\n").FontSize(16);
                                    charOutputFile.WriteLine("#" + child.NewFieldText + "#");
                                    charOutputFile.WriteLine(child.NewInfoText);
                                    using (StringReader infoReader = new StringReader(child.NewInfoText))
                                    {
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
                                }
                                document.Save();
                            }
                            CurrentModel.NewTextBoxList.Last<DescriptiveDataModel>().SwitchButtonVisibility = "Collapsed";
                            CurrentModel.ResultTextBoxList = CurrentModel.NewTextBoxList;
                            outputFile.Close();
                            charOutputFile.Close();
                        }
                        finally
                        {
                            outputFile.Close();
                            charOutputFile.Close();
                        }
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
                if (CurrentModel.UsedMethod == "EditedFile" && !CurrentModel.ModelNames.Contains(modelFolder))
                {
                    CurrentModel.ModelNames.Add(modelFolder);
                }
                modelFolder = Path.Combine(inputParams.Env.RootPath, "DescModel", CurrentModel.Tab2ExtensionFolder);
                if (CurrentModel.UsedMethod == "NewFile" && !CurrentModel.ModelNames.Contains(modelFolder))
                {
                    CurrentModel.ModelNames.Add(modelFolder);
                }
                string lastRunFile = Path.Combine(Path.Combine(settingsService.RootPath, "DescModel", "descriptive_last_run" + ".lastrun"));
                File.Create(lastRunFile).Close();
                dialogService.ShowNotification("Descriptive Model tool completed successfully", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Descriptive Model tool completed successfully.", "Success");
                CurrentModel.LastRunDate = "Last Run: " + DateTime.Now.ToString("g");
                CurrentModel.RunStatus = 1;
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to create textfile");
                dialogService.ShowNotification("Run failed. Check output for details.\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Descriptive model tool run failed. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                CurrentModel.RunStatus = 0;
            }
            finally
            {
                CurrentModel.IsBusy = false;
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
                while (CurrentModel.TextBoxList.Count != 0)
                {
                    CurrentModel.TextBoxList.RemoveAt(0);
                }
                CurrentModel.SubFieldCountList.Clear();
                CurrentModel.TextBoxList.Clear();
                CurrentModel.FieldList.Clear();
                CurrentModel.SubFieldList.Clear();
                CurrentModel.AllSubFieldList.Clear();
                string text = CurrentModel.TextFile;
                using (StreamReader file = new StreamReader(text, Encoding.Default)) // If there's ever an error related to reading textfile, then it might be because this encoding isn't good enough to read the text.                
                {
                    SetupFieldList(file); // Get fields from textfile.
                }
                // Clear the array if it isn't empty.
                if (CurrentModel.TextArray.Length != 0)
                {
                    List<string> arraylist = CurrentModel.TextArray.ToList();
                    arraylist.Clear();
                    CurrentModel.TextArray = arraylist.ToArray();
                }
                CurrentModel.TextArray = new string[CurrentModel.FieldList.Count];
                string titleText = ""; // String for possible titletext, not currently used.                
                using (StreamReader file = new StreamReader(text, Encoding.Default)) // New streamreader to go through again the file to get field related infos.
                {
                    using (List<string>.Enumerator enumerator = CurrentModel.FieldList.GetEnumerator())
                    {
                        using (List<string>.Enumerator SubFieldEnumerator = CurrentModel.AllSubFieldList.GetEnumerator())
                        {
                            SetupInfoArray(file, enumerator, SubFieldEnumerator, titleText); // Get field related infos from textfile.
                        }
                    }
                }
                int arrayIndex = 0;
                int[] subFieldCountArray = CurrentModel.SubFieldCountList.ToArray(); // Array which has information of how many subfields are per field.
                using (List<string>.Enumerator SubFieldEnumerator = CurrentModel.AllSubFieldList.GetEnumerator())
                {
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
                        CurrentModel.TextBoxList.Add(Model);
                        arrayIndex++;
                    }
                }
                CurrentModel.TextBoxList.Last<DescriptiveDataModel>().SwitchButtonVisibility = "Collapsed"; // In the resultview the last button for switching the places of the fields has no use.
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to read textfile");
                dialogService.ShowNotification("Failed to read the file. Check output for details\r\n - Are all input and output files closed ?", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to read the textfile in Descriptive model tool. Check output for details\r\n- Are all input parameters correct?\r\n- Are all input files valid? \r\n- Are all input and output files closed?", "Error");
                CurrentModel.TextFile = "Select File";
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
                    // Check if the line is a field.
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
        }

        /// <summary>
        /// Gathers field related info texts into array.
        /// </summary>
        /// <param name="file">File stream</param>
        /// <param name="line">Current line</param>
        /// <param name="titleText">TitleText. Not currently in use.</param>
        private void SetupInfoArray(StreamReader file, List<string>.Enumerator enumerator, List<string>.Enumerator subFieldEnumerator, string titleText)
        {
            string deleteWord = "";
            int subFieldCount = 0;
            int arrayIndex = 0;
            string line = file.ReadLine();
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
                                            if (subFieldEnumerator.MoveNext() != false)
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
            using (StringReader infoReader = new StringReader(fieldInfoText))  // StringReader is used instead of Streamreader since this method doesn't read a file.
            {
                string line = infoReader.ReadLine();
                CurrentModel.SubFieldList.Clear();  // Clear the list so that the previous subfields that prever to a different field don't stay in the list.                                                    // Read lines from inforeader until the line is null.
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
                logger.Error(ex, "Failed to show OpenFileDialog.");
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
        }

        /// <summary>
        /// Select file from filesystem.
        /// </summary>
        private void SelectFile()
        {
            try
            {
                string textFile = dialogService.OpenFileDialog("", "Text files|*.txt;", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(textFile))
                {
                    CurrentModel.TextFile = textFile;
                    ReadFile();
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog.");
                dialogService.ShowNotification("Failed to select input file.", "Error");
            }
        }

        /// <summary>
        /// Select document file from filesystem.
        /// </summary>
        private void SelectWordDocument()
        {
            try
            {
                string wordFile = dialogService.OpenFileDialog("", "Word Document|*.docx", true, true, settingsService.RootPath);
                if (!string.IsNullOrEmpty(wordFile))
                {
                    CurrentModel.WordFile = wordFile;
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to show OpenFileDialog.");
                dialogService.ShowNotification("Failed to select input file.", "Error");
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
                    while (CurrentModel.NewTextBoxList.Count != 0)
                    {
                        CurrentModel.NewTextBoxList.RemoveAt(0);
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
                CurrentModel.NewTextBoxList.Insert(0, descriptiveModel);
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to add TextBox");
                dialogService.ShowNotification("Failed to add Field.", "Error");
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
                foreach (DescriptiveDataModel item in CurrentModel.NewTextBoxList)
                {
                    // Depending on which of the Add TextBox -buttons is clicked, get the button's model ID and this new model after that model.
                    if (item.NewFieldId == currentFieldId)
                    {
                        currentFieldIndex = CurrentModel.NewTextBoxList.IndexOf(item);
                    }
                }              
                CurrentModel.NewTextBoxList.Insert(currentFieldIndex + 1, descriptiveModel);
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to add field");
                dialogService.ShowNotification("Failed to add field.", "Error");
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
                foreach (DescriptiveDataModel item in CurrentModel.NewTextBoxList)
                {
                    // Delete item model which has the specific ID.
                    if (item.NewFieldId == currentFieldId)
                    {
                        CurrentModel.RandomList.Remove(item.NewFieldId);
                        deleteItem = item;
                    }
                }
                CurrentModel.NewTextBoxList.Remove(deleteItem);
                // If there are not textboxes anymore, then the Run Tool -button will be hided.
                if (CurrentModel.NewTextBoxList.Count == 0)
                {
                    CurrentModel.RunVisibilityTab2 = "Collapsed";
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to delete field");
                dialogService.ShowNotification("Failed to delete field.", "Error");
            }
        }

        /// <summary>
        /// Delete all TextBoxes from "New" -tab in DescriptiveInputView.
        /// </summary>
        private void DeleteAllTBox()
        {
            try
            {
                while (CurrentModel.NewTextBoxList.Count != 0)
                {
                    CurrentModel.NewTextBoxList.RemoveAt(0);
                }
                CurrentModel.RunVisibilityTab2 = "Collapsed";
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to delete fields");
                dialogService.ShowNotification("Failed to delete fields.", "Error");
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
                if (CurrentModel.UsedMethod == "EditedFile")
                {
                    foreach (DescriptiveDataModel item in CurrentModel.TextBoxList)
                    {
                        // If the field's name is same, then switch place of this field.
                        if (field == item.FieldText)
                        {
                            fieldsModel = item;
                        }
                    }
                    if (fieldsModel != null)
                    {
                        int index = CurrentModel.TextBoxList.IndexOf(fieldsModel);
                        // Switch places only if there's room at thye end of a list.
                        if (CurrentModel.TextBoxList.Count != index + 1)
                        {
                            CurrentModel.TextBoxList.Move(index, index + 1);
                            // This makes sure that the last Switch -button is not visible (since it's the last one, it doesn't switch any field's place).
                            if (index + 2 == CurrentModel.TextBoxList.Count())
                            {
                                CurrentModel.TextBoxList.ElementAt(index).SwitchButtonVisibility = "Visible";
                                CurrentModel.TextBoxList.ElementAt(index + 1).SwitchButtonVisibility = "Collapsed";
                            }
                        }
                    }
                    CurrentModel.OrderButtonVisibility = "Visible";
                }
                if (CurrentModel.UsedMethod == "NewFile")
                {
                    foreach (DescriptiveDataModel item in CurrentModel.NewTextBoxList)
                    {
                        // If the field's name is same, then we chose to switch place of this field.
                        if (field == item.NewFieldText)
                        {
                            fieldsModel = item;
                        }
                    }
                    if (fieldsModel != null)
                    {
                        int index = CurrentModel.NewTextBoxList.IndexOf(fieldsModel);
                        if (CurrentModel.NewTextBoxList.Count != index + 1)
                        {
                            CurrentModel.NewTextBoxList.Move(index, index + 1);
                            // This makes sure that the last Switch -button is not visible(since it's the last one, it doesn't switch field's place).
                            if (index + 2 == CurrentModel.NewTextBoxList.Count())
                            {
                                CurrentModel.NewTextBoxList.ElementAt(index).SwitchButtonVisibility = "Visible";
                                CurrentModel.NewTextBoxList.ElementAt(index + 1).SwitchButtonVisibility = "Collapsed";
                            }
                        }
                    }
                    CurrentModel.OrderButtonVisibility = "Visible";
                }
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to edit field order");
                dialogService.ShowNotification("Failed to edit field order.", "Error");
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
                dialogService.ShowNotification("Failed to show field info.", "Error");
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
                while (CurrentModel.NewTextBoxList.Count != 0)
                {
                    CurrentModel.NewTextBoxList.RemoveAt(0);
                }
                CurrentModel.NewTextBoxList.Clear();
                CurrentModel.FieldList.Clear();
                using (StreamReader file = new StreamReader(newTextFile, Encoding.Default))  // If there's ever an error related to reading textfile, then it might be because this encoding isn't good enough to read the text.                
                {
                    SetupFieldList(file);  // Get fields from textfile.
                }
                // Clear the array it is not empty.
                if (CurrentModel.TextArray.Length != 0)
                {
                    List<string> arraylist = CurrentModel.TextArray.ToList();
                    arraylist.Clear();
                    CurrentModel.TextArray = arraylist.ToArray();
                }
                CurrentModel.TextArray = new string[CurrentModel.FieldList.Count];
                string titleText = "";  // String for possible titletext. This is not currently used.                
                using (StreamReader file = new StreamReader(newTextFile, Encoding.Default))  // New streamreader to go through again the file to get field related infos.
                {
                    using (List<string>.Enumerator enumerator = CurrentModel.FieldList.GetEnumerator())
                    {
                        using (List<string>.Enumerator SubFieldEnumerator = CurrentModel.AllSubFieldList.GetEnumerator())
                        {
                            SetupInfoArray(file, enumerator, SubFieldEnumerator, titleText);  // Get field related infos from textfile.
                        }
                    }
                }
                int arrayIndex = 0;
                // Adds all field related textboxes into user interface.
                foreach (string item in CurrentModel.FieldList)
                {
                    if (CurrentModel.NewTextBoxList.Count() == 0)
                    {
                        AddFirstTBox();
                    }
                    else
                    {
                        AddTBox(CurrentModel.NewTextBoxList.ElementAt(arrayIndex - 1).NewFieldId);
                    }
                    Model = CurrentModel.NewTextBoxList.ElementAt(arrayIndex);
                    Model.NewFieldText = item;
                    Model.NewInfoText = CurrentModel.TextArray[arrayIndex];
                    Model.SwitchButtonVisibility = "Visible";
                    arrayIndex++;
                }
                // In some cases the list has been empty. This makes sure that the Run Tool -button is hidden if list is empty.
                if (CurrentModel.NewTextBoxList.Count() == 0)
                {
                    CurrentModel.RunVisibilityTab2 = "Collapsed";
                }
                // The last of the buttons doesn't do anything so it can't be visible.
                if (CurrentModel.NewTextBoxList.Count() != 0)
                {
                    CurrentModel.NewTextBoxList.Last<DescriptiveDataModel>().SwitchButtonVisibility = "Collapsed";
                }
                CurrentModel.OrderButtonVisibility = "Collapsed";
            }
            catch (Exception ex)
            {
                logger.Error(ex, "Failed to read textfile in 'New' -tab");
                dialogService.ShowNotification("Failed to read the file in 'New' -tab. Check output for details.", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to read the textfile in Descriptive model tool's 'New' - tab.", "Error");
            }
        }

        /// <summary>
        /// Select certain result.
        /// </summary>
        private void SelectResult()
        {
            if (CurrentModel.ModelNames.Count <= 0 || CurrentModel.DepositModelsExtension.Length == 0)
            {
                dialogService.ShowNotification("Either the model was not selected or it was not given a name. ", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Either the model was not selected or it was not given a name.", "Error");
                return;
            }
            try
            {
                var modelDirPath = CurrentModel.ModelNames[CurrentModel.SelectedModelIndex];
                var modelDirInfo = new DirectoryInfo(CurrentModel.ModelNames[CurrentModel.SelectedModelIndex]);
                var selectedProjectFolder = Path.Combine(settingsService.RootPath, "DescModel", "SelectedResult");
                if (modelDirPath == selectedProjectFolder)
                {
                    dialogService.ShowNotification("SelectedResult folder cannot be selected. ", "Error");
                    return;
                }
                if (!Directory.Exists(selectedProjectFolder))
                {
                    Directory.CreateDirectory(selectedProjectFolder);
                }
                DirectoryInfo dir = new DirectoryInfo(selectedProjectFolder);
                // Deletes all files and directories before adding new files.
                foreach (FileInfo file in dir.GetFiles())
                {
                    file.Delete();
                }
                foreach (DirectoryInfo direk in dir.GetDirectories())
                {
                    direk.Delete(true);
                }
                // Get files from selected model root folder and add them into SelectedResult folder.
                foreach (FileInfo file2 in modelDirInfo.GetFiles())
                {
                    var destPath = Path.Combine(selectedProjectFolder, file2.Name);
                    var sourcePath = Path.Combine(modelDirPath, file2.Name);
                    if (File.Exists(destPath))
                    {
                        File.Delete(destPath);
                    }
                    File.Copy(sourcePath, destPath);  // Copy files to new Root folder.
                    if (CurrentModel.SaveToDepositModels == true)
                    {
                        var depositPath = Path.Combine(settingsService.DepositModelsPath, "DepositModels", "Descriptive", CurrentModel.DepositModelsExtension);
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
                // Get parameters of the selected project.
                DescriptiveInputParams inputParams = new DescriptiveInputParams();
                string projectFolder = Path.Combine(settingsService.RootPath, "DescModel");
                string param_json = Path.Combine(selectedProjectFolder, "descriptive_input_params.json");
                // Clear ResultTextBox list so that new results can be added.
                while (CurrentModel.ResultTextBoxList.Count != 0)
                {
                    CurrentModel.ResultTextBoxList.RemoveAt(0);
                }
                // Check if result files were moved into SelectedResult folder.
                if (File.Exists(param_json))
                {
                    inputParams.Load(param_json);
                    CurrentModel.UsedMethod = inputParams.Method;
                    if (File.Exists(Path.Combine(projectFolder, inputParams.Tab1ExtensionFolder, "DescriptiveModel(Chars).txt")))
                    {
                        CurrentModel.TextFile = Path.Combine(projectFolder, inputParams.Tab1ExtensionFolder, "DescriptiveModel(Chars).txt");
                        CurrentModel.Tab1ExtensionFolder = inputParams.Tab1ExtensionFolder;
                        CurrentModel.RunVisibilityTab1 = "Visible";
                        ReadFile();
                    }
                    if (File.Exists(Path.Combine(projectFolder, inputParams.Tab2ExtensionFolder, "DescriptiveNewModel(Chars).txt")))
                    {
                        CurrentModel.Tab2ExtensionFolder = inputParams.Tab2ExtensionFolder;
                        CurrentModel.RunVisibilityTab2 = "Visible";
                        LoadLastNewTabSession(Path.Combine(projectFolder, "DescriptiveNewModel(Chars).txt"));
                    }
                    // Create textfile containing name of selected model.
                    string modelNameFile = Path.Combine(selectedProjectFolder, "DescModelName.txt");
                    File.Create(modelNameFile).Close();
                    // Information for reporting tool about selected model.
                    if (CurrentModel.UsedMethod == "EditedFile")
                    {
                        viewModelLocator.ReportingViewModel.Model.DescModelPath = Path.Combine(selectedProjectFolder, "DescriptiveModel(docx).docx");
                        viewModelLocator.ReportingViewModel.Model.DescModelName = Path.GetFileName(CurrentModel.DepositModelsExtension);
                        viewModelLocator.ReportingViewModel.SaveInputs();
                        viewModelLocator.ReportingAssesmentViewModel.Model.DescModelPath = Path.Combine(selectedProjectFolder, "DescriptiveModel(docx).docx");
                        viewModelLocator.ReportingAssesmentViewModel.Model.DescModelName = Path.GetFileName(CurrentModel.DepositModelsExtension);
                        viewModelLocator.ReportingAssesmentViewModel.SaveInputs();                        
                        using (StreamWriter writeStream = new StreamWriter(new FileStream(modelNameFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default))
                        {
                            writeStream.Write(CurrentModel.DepositModelsExtension + "," + Path.Combine(selectedProjectFolder, "DescriptiveModel(docx).docx"));
                        }
                    }
                    else if (CurrentModel.UsedMethod == "NewFile")
                    {
                        viewModelLocator.ReportingViewModel.Model.DescModelPath = Path.Combine(selectedProjectFolder, "DescriptiveNewModel(docx).docx");
                        viewModelLocator.ReportingViewModel.Model.DescModelName = Path.GetFileName(CurrentModel.DepositModelsExtension);
                        viewModelLocator.ReportingViewModel.SaveInputs();
                        viewModelLocator.ReportingAssesmentViewModel.Model.DescModelPath = Path.Combine(selectedProjectFolder, "DescriptiveNewModel(docx).docx");
                        viewModelLocator.ReportingAssesmentViewModel.Model.DescModelName = Path.GetFileName(CurrentModel.DepositModelsExtension);
                        viewModelLocator.ReportingAssesmentViewModel.SaveInputs();
                        using (StreamWriter writeStream = new StreamWriter(new FileStream(modelNameFile, FileMode.Open, FileAccess.ReadWrite), Encoding.Default))
                        {
                            writeStream.Write(CurrentModel.DepositModelsExtension + "," + Path.Combine(selectedProjectFolder, "DescriptiveNewModel(docx).docx"));
                        }
                    }
                }              
                CurrentModel.DepositModelsExtension = "";
                CurrentModel.SaveToDepositModels = false;
                dialogService.ShowNotification("Model selected successfully", "Success");
                viewModelLocator.SettingsViewModel.WriteLogText("Model selected successfully in Descriptive model tool.", "Success");
            }
            catch (Exception ex)
            {
                logger.Trace(ex, "Error in Model Selection:");
                dialogService.ShowNotification("Failed to select model", "Error");
                viewModelLocator.SettingsViewModel.WriteLogText("Failed to select model in Descriptive model tool.", "Error");
            }
            var metroWindow = (Application.Current.MainWindow as MetroWindow);
            var dialog = metroWindow.GetCurrentDialogAsync<BaseMetroDialog>();
            metroWindow.HideMetroDialogAsync(dialog.Result);
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
                            CurrentModel.ModelNames.Add(model.FullName);
                        }
                    }
                }
            }
            // Goes also through the main folder.
            foreach (FileInfo file in projectFolderInfo.GetFiles())
            {
                if (file.Name == "descriptive_input_params.json")
                {
                    CurrentModel.ModelNames.Add(projectFolderInfo.FullName);
                }
            }
        }

        public void LoadResults(string selectedProjectFolder)
        {
            if (File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveWordModel(docx).docx")))
            {
                CurrentModel.RunStatus = 1;
            }
            else if (CurrentModel.UsedMethod == "WordFile")
            {
                CurrentModel.RunStatus = 0;
            }
            // If all the File -tab related files exist, then load the textfile update Success status.
            if (File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveModel(Chars).txt")) && File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveModel.txt"))
                && File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveModel(docx).docx")))
            {
                CurrentModel.TextFile = Path.Combine(selectedProjectFolder, "DescriptiveModel(Chars).txt");
                ReadFile();
                CurrentModel.RunStatus = 1;
            }
            // If all the files didn't exist and there have been a previous run in File -tab, then update error status.
            else if (CurrentModel.UsedMethod == "EditedFile")
            {
                CurrentModel.RunStatus = 0;
            }
            // If all the File -tab related files exist, then load the textfile and update Success status.
            if (File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveNewModel(Chars).txt")) && File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveNewModel.txt"))
                && File.Exists(Path.Combine(selectedProjectFolder, "DescriptiveNewModel(docx).docx")))
            {
                LoadLastNewTabSession(Path.Combine(selectedProjectFolder, "DescriptiveNewModel(Chars).txt"));
                if (CurrentModel.UsedMethod == "NewFile") // This makes sure that the last session was using New -tab.
                {
                    CurrentModel.RunStatus = 1;
                }
            }
            // If all the files didn't exist and there have been a previous run in New -tab, then update Error status.
            else if (CurrentModel.UsedMethod == "NewFile")
            {
                CurrentModel.RunVisibilityTab2 = "Collapsed";
                CurrentModel.RunStatus = 0;
            }
        }

        /// <summary>
        /// Check if tool can be executed (not busy).
        /// </summary>
        /// <returns>Boolean representing the state.</returns>
        public bool CanRunTool()
        {
            return !CurrentModel.IsBusy;
        }
    }
}
