using CsvHelper;
using NLog;
using System;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using Xceed.Words.NET;

namespace MapWizard.Tools
{
    /// <summary>
    /// Input parameters for Reporting tool.
    /// </summary>
    public class ReportingAssesmentInputParams : ToolParameters
    {
        /// <summary>
        /// Titlt of the assesment report.
        /// </summary>
        public string AssesmentTitle
        {
            get { return GetValue<string>("AssesmentTitle"); }
            set { Add<string>("AssesmentTitle", value); }
        }
        /// <summary>
        /// Select the tract for which the report will be generated from a drop-down list.
        /// </summary>
        public ObservableCollection<string> TractIDNames
        {
            get { return GetValue<ObservableCollection<string>>("TractIDNames"); }
            set { Add<ObservableCollection<string>>("TractIDNames", value); }
        }
        /// <summary>
        /// Collection of choices whether a spesific tracts TractReport file is chosen to the assesment report.
        /// </summary>
        public ObservableCollection<string> TractIDChoices
        {
            get { return GetValue<ObservableCollection<string>>("TractIDChoices"); }
            set { Add<ObservableCollection<string>>("TractIDChoices", value); }
        }
        /// <summary>
        /// Selected tract.
        /// </summary>
        public string SelectedTract
        {
            get { return GetValue<string>("SelectedTract"); }
            set { Add<string>("SelectedTract", value); }
        }
        /// <summary>
        /// Selected tract combination.
        /// </summary>
        public string SelectedTractCombination
        {
            get { return GetValue<string>("SelectedTractCombination"); }
            set { Add<string>("SelectedTractCombination", value); }
        }
        /// <summary>
        /// Input the names of authors for this Tract report.
        /// </summary>
        public string Authors
        {
            get { return GetValue<string>("Authors"); }
            set { Add<string>("Authors", value); }
        }
        /// <summary>
        /// Input the country in which the tract is located.
        /// </summary>
        public string Country
        {
            get { return GetValue<string>("Country"); }
            set { Add<string>("Country", value); }
        }
        /// <summary>
        /// The deposit type is automatically taken from the assessment project file.
        /// </summary>
        public string DepositType
        {
            get { return GetValue<string>("DepositType"); }
            set { Add<string>("DepositType", value); }
        }
        /// <summary>
        /// Path to the selected descriptive model.
        /// </summary>
        public string DescModel
        {
            get { return GetValue<string>("DescModel"); }
            set { Add<string>("DescModel", value); }
        }
        /// <summary>
        /// Name of the selected descriptive model.
        /// </summary>
        public string DescModelName
        {
            get { return GetValue<string>("DescModelName"); }
            set { Add<string>("DescModelName", value); }
        }
        /// <summary>
        /// Path to the selected grade-tonnage model.
        /// </summary>
        public string GTModel
        {
            get { return GetValue<string>("GTModel"); }
            set { Add<string>("GTModel", value); }
        }
        /// <summary>
        /// Name of the selected grade-tonnage model.
        /// </summary>
        public string GTModelName
        {
            get { return GetValue<string>("GTModelName"); }
            set { Add<string>("GTModelName", value); }
        }
        /// <summary>
        /// Path to the selected raef result file.
        /// </summary>
        public string RaefFile
        {
            get { return GetValue<string>("RaefFile"); }
            set { Add<string>("RaefFile", value); }
        }
        /// <summary>
        /// Name of the selected raef result file.
        /// </summary>
        public string RaefFileName
        {
            get { return GetValue<string>("RaefFileName"); }
            set { Add<string>("RaefFileName", value); }
        }
        /// <summary>
        /// If a descriptive model is associated with the project, it is listed here. The user can select whether to add the model as an appendix to the Assesment report.
        /// </summary>
        public string AddDescriptive
        {
            get { return GetValue<string>("AddDescriptive"); }
            set { Add<string>("AddDescriptive", value); }
        }
        /// <summary>
        /// The grade-tonnage model used in the assessment process is shown here. The user can select whether to add the model as an appendix to the Assesment report.
        /// </summary>
        public string AddGradeTon
        {
            get { return GetValue<string>("AddGradeTon"); }
            set { Add<string>("AddGradeTon", value); }
        }
        /// <summary>
        /// Raef result used in the assessment process is shown here. The user can select whether to add the model as an appendix to the Assesment report.
        /// </summary>
        public string AddRaef
        {
            get { return GetValue<string>("AddRaef"); }
            set { Add<string>("AddRaef", value); }
        }
        /// <summary>
        /// Determines if the user is able to choose descriptive model.
        /// </summary>
        public string EnableDescCheck
        {
            get { return GetValue<string>("EnableDescCheck"); }
            set { Add<string>("EnableDescCheck", value); }
        }
        /// <summary>
        /// Determines if the user is able to choose grade tonnage model.
        /// </summary>
        public string EnableGTCheck
        {
            get { return GetValue<string>("EnableGTCheck"); }
            set { Add<string>("EnableGTCheck", value); }
        }
        /// <summary>
        /// Determines if the user is able to choose raef result file.
        /// </summary>
        public string EnableRaefCheck
        {
            get { return GetValue<string>("EnableRaefCheck"); }
            set { Add<string>("EnableRaefCheck", value); }
        }
        /// <summary>
        /// Location of an image showing the location of the tract. Accepted formats are jpeg, tiff and png.
        /// </summary>
        public string TractImageFile
        {
            get { return GetValue<string>("TractImageFile"); }
            set { Add<string>("TractImageFile", value); }
        }
        /// <summary>
        /// Input assessment date/assessment report date.
        /// </summary>
        public string AsDate
        {
            get { return GetValue<string>("AsDate"); }
            set { Add<string>("AsDate", value); }
        }
        /// <summary>
        /// Input the depth limit of the assessment.
        /// </summary>
        public string AsDepth
        {
            get { return GetValue<string>("AsDepth"); }
            set { Add<string>("AsDepth", value); }
        }
        /// <summary>
        /// Input the name of the assessment team leader.
        /// </summary>
        public string AsLeader
        {
            get { return GetValue<string>("AsLeader"); }
            set { Add<string>("AsLeader", value); }
        }
        /// <summary>
        /// Input names of other assessment team members.
        /// </summary>
        public string AsTeamMembers
        {
            get { return GetValue<string>("AsTeamMembers"); }
            set { Add<string>("AsTeamMembers", value); }
        }
        /// <summary>
        /// The results of the Undiscovered deposits tool are automatically included in the Tract report.
        /// </summary>
        public string IsUndiscDepDone
        {
            get { return GetValue<string>("IsUndiscDepDone"); }
            set { Add<string>("IsUndiscDepDone", value); }
        }
        /// <summary>
        /// If results of a RAEF run have been selected in the Economic filter tool, they will automatically be included in the Tract report.
        /// </summary>
        public string IsRaefDone
        {
            get { return GetValue<string>("IsRaefDone"); }
            set { Add<string>("IsRaefDone", value); }
        }
        /// <summary>
        /// If results of a Screener run have been selected in the Economic filter tool, they will automatically be included in the Tract report.
        /// </summary>
        public string IsScreenerDone
        {
            get { return GetValue<string>("IsScreenerDone"); }
            set { Add<string>("IsScreenerDone", value); }
        }
    }

    /// <summary>
    /// Output parameters for Reporting tool.
    /// </summary>
    public class ReportingAssesmentResult : ToolResult
    {
        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();

        /// <summary>
        /// Output document file of Reporting Assesment tool. 
        /// </summary>
        public string OutputDocument
        {
            get { return GetValue<string>("OutputDocument"); }
            internal set { Add<string>("OutputDocument", value); }
        }
    }

    /// <summary>
    /// Report excecution.
    /// </summary>
    public class ReportingAssesmentTool : ITool
    {
        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();

        /// <summary>
        /// Excecutes tool and returns results as parameters.
        /// </summary>
        /// <param name="inputParams">Inputs.</param>
        /// <returns>AssesmentReportResult.</returns>
        public ToolResult Execute(ToolParameters inputParams)
        {
            ReportingAssesmentInputParams input = inputParams as ReportingAssesmentInputParams;
            string outputFolder = Path.Combine(inputParams.Env.RootPath, "Reporting");
            if (!Directory.Exists(outputFolder))
            {
                Directory.CreateDirectory(outputFolder);
            }
            input.Save(Path.Combine(outputFolder, "assesment_report_input_params.json"));
            ReportingAssesmentResult result = new ReportingAssesmentResult(); // This should return the output file.
            try
            {
                if (!Directory.Exists(Path.Combine(outputFolder, input.SelectedTractCombination)))
                {
                    Directory.CreateDirectory(Path.Combine(outputFolder, input.SelectedTractCombination));
                }
                string docOutputFile = Path.Combine(outputFolder, input.SelectedTractCombination, "AssesmentReport" + input.SelectedTractCombination + ".docx");
                using (var document = DocX.Create(docOutputFile))
                {
                    document.PageLayout.Orientation = Orientation.Portrait;
                    WriteInputs(input, document);
                    WriteUndiscoveredDeposits(input, document);
                    WriteMonteCarlo(input, document);
                    WriteEconomicFilter(input, document);
                    WriteAppendixes(input, document);
                    document.Save();
                }
                result.OutputDocument = docOutputFile;
            }
            catch (Exception ex)
            {
                throw new Exception("Word file creation failed: ", ex);
            }
            return result;
        }

        /// <summary>
        /// Writes given inputs into a document.
        /// </summary>
        /// <param name="input">Inputs</param>
        /// <param name="document">Word document</param>
        /// <param name="tractID">Selected tractID</param>
        private void WriteInputs(ReportingAssesmentInputParams input, DocX document)
        {
            string paragraph = input.SelectedTractCombination;
            document.InsertParagraph(paragraph).FontSize(16).Bold().Alignment = Alignment.center;
            if (File.Exists(input.TractImageFile))
            {
                var p = document.InsertParagraph("");
                p.Alignment = Alignment.center;
                var image = document.AddImage(input.TractImageFile);
                var picture = image.CreatePicture();
                // Check if the image is too big.
                if (picture.Height > 670 || picture.Width > 600)
                {
                    // Shrinks the image so that it retains right proportions.
                    while (picture.Height > 670 || picture.Width > 600)
                    {
                        picture.Height = picture.Height - 10;
                        picture.Width = picture.Width - 7;
                    }
                }
                p.AppendPicture(picture);
                p.SpacingBefore(50);
                p.SpacingAfter(10);
            }
            Paragraph severalParagraphs = document.InsertParagraph("Figure 1. ").Bold();
            severalParagraphs.Append("Location of tract " + input.SelectedTractCombination + ".");
            document.InsertParagraph().InsertPageBreakAfterSelf();
            //paragraph = input.DepositType + " ASSESMENT FOR TRACT " + "\'" + input.SelectedTract + "\' " + input.Country + "\r\n";
            //document.InsertParagraph(paragraph).FontSize(16).Bold();
            paragraph = input.AssesmentTitle + "\r\n";
            document.InsertParagraph(paragraph).FontSize(16).Bold();
            paragraph = input.Authors + "\r\n";
            document.InsertParagraph(paragraph).FontSize(11);
            paragraph = "Deposit type: " + input.DepositType;
            document.InsertParagraph(paragraph).FontSize(11);
            paragraph = "Descriptive model: " + input.DescModelName;
            document.InsertParagraph(paragraph).FontSize(11);
            paragraph = "Grade-tonnage model: " + input.GTModelName + "\r\n";
            
            document.InsertParagraph(paragraph).FontSize(11);
            paragraph = "List of permissive tracts:";//tracts included in the assessment:";
            document.InsertParagraph(paragraph).FontSize(11);
            string tractFile = Path.Combine(input.Env.RootPath, "TractDelineation", "Tracts", input.SelectedTractCombination, "TractsAggregated.csv");
            if (File.Exists(tractFile))
            {
                string tractText = File.ReadAllText(tractFile);
                string[] tractList = tractText.Split(',');
                foreach (var tract in tractList)
                {
                    paragraph = tract;
                    document.InsertParagraph(paragraph).FontSize(11);
                }
            }
            paragraph = "\r\n\r\n";
            document.InsertParagraph(paragraph).FontSize(11);
            paragraph = "Assessment date: " + input.AsDate;
            document.InsertParagraph(paragraph).FontSize(11);
            paragraph = "Assessment depth: " + input.AsDepth;
            document.InsertParagraph(paragraph).FontSize(11);
            paragraph = "Assessment team leader: " + input.AsLeader;
            document.InsertParagraph(paragraph).FontSize(11);
            paragraph = "Assessment team members: " + input.AsTeamMembers + "\r\n";

            document.InsertParagraph(paragraph);
            paragraph = "Estimated number of undiscovered deposits" + "\r\n";
            document.InsertParagraph(paragraph).FontSize(14).Bold();
        }

        /// <summary>
        /// Writes given inputs into a document.
        /// </summary>
        /// <param name="input">Inputs.</param>
        /// <param name="document">Word document.</param>
        /// <param name="tractID">Selected tractID.</param>
        private void WriteUndiscoveredDeposits(ReportingAssesmentInputParams input, DocX document)
        {
            string paragraph = "";
            Paragraph severalParagraphs = null;
            string depEst = "";
            if ((input.IsUndiscDepDone == "Yes (NegativeBinomial)" && File.Exists(depEst = Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "nDepEst.csv"))) || //käydään läpi että onko depEst tiedostoa olemassa missään muodossa
                (input.IsUndiscDepDone == "Yes (MARK3)" && File.Exists(depEst = Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "nDepEstMiddle.csv"))) ||
                (input.IsUndiscDepDone == "Yes (Custom)" && File.Exists(depEst = Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "nDepEstCustom.csv"))))
            {
                severalParagraphs = document.InsertParagraph("Table 1. ").Bold();
                severalParagraphs.Append("Estimated numbers of deposits at 90, 50 and 10 percentile levels of confidence" + "\r\n");
                string value;
                using (TextReader fileReader = File.OpenText(depEst))
                {
                    using (var csv = new CsvReader(fileReader))
                    {
                        csv.Configuration.HasHeaderRecord = false;
                        csv.Configuration.Delimiter = ";";
                        Table t = null;
                        if (depEst == Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "nDepEst.csv"))
                        {
                            t = document.AddTable(1, 5);
                        }
                        else if (depEst == Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "nDepEstMiddle.csv"))
                        {
                            t = document.AddTable(1, 6);
                        }
                        else //(depEst == Path.Combine(input.Env.RootPath, "UndiscDep", "SelectedResult", "nDepEstCustom.csv"))
                        {
                            t = document.AddTable(1, 2);
                        }
                        bool addToFirstRow = true;
                        var r = t.Rows[0];
                        int cellNumber = 1;
                        // Inserts the data from CSV file corrctly into a table.
                        while (csv.Read())
                        {
                            for (int i = 0; csv.TryGetField<string>(i, out value); i++)
                            {
                                if (depEst == Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "nDepEstMiddle.csv"))
                                {

                                    if (addToFirstRow == true)
                                    {
                                        r = t.Rows[0];

                                        addToFirstRow = false;
                                        r.Cells[0].Paragraphs[0].Append("TractID");
                                        r.Cells[1].Paragraphs[0].Append("N90");
                                        r.Cells[2].Paragraphs[0].Append("N50");
                                        r.Cells[3].Paragraphs[0].Append("N10");
                                        r.Cells[4].Paragraphs[0].Append("N05");
                                        r.Cells[5].Paragraphs[0].Append("N01");
                                        r = t.InsertRow();
                                        r.Cells[cellNumber].Paragraphs[0].Append(value);
                                        cellNumber++;
                                    }
                                    else
                                    {
                                        r = t.Rows[1];
                                        r.Cells[cellNumber].Paragraphs[0].Append(value);
                                        cellNumber++;
                                    }
                                }
                                else
                                {
                                    r = t.Rows[0];
                                    if (addToFirstRow == true)
                                    {
                                        r = t.Rows[0];
                                        addToFirstRow = false;
                                        value = value.Replace("Name", "Estimator");
                                    }
                                    else
                                    {
                                        r = t.InsertRow();
                                    }
                                    string[] cellArray = value.Split(',');
                                    int cellIndex = 0;
                                    for (int k = 0; k < cellArray.Length; k++)
                                    {
                                        r.Cells[cellIndex].Paragraphs[0].Append(cellArray[k]).ReplaceText("\"", "");
                                        cellIndex++;
                                    }
                                }
                            }
                        }
                        document.InsertTable(t);  // Insert table into the document.
                    }
                    document.InsertParagraph("\r\n");
                }
            }
            if (File.Exists(Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "summary.txt")) && input.IsUndiscDepDone != "No")
            {
                severalParagraphs = document.InsertParagraph("Table 2. ").Bold();
                severalParagraphs.Append(File.ReadAllText(Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "summary.txt")) + "\r\n");
            }
            string file = Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "TractPmf.csv");
            if (File.Exists(file) && input.IsUndiscDepDone != "No")
            {
                severalParagraphs = document.InsertParagraph("Table 3. ").Bold();
                severalParagraphs.Append("Number of deposits and associated probability for the estimated pmf");
                using (TextReader fileReader = File.OpenText(file))
                {
                    using (var csv = new CsvReader(fileReader))
                    {
                        csv.Configuration.HasHeaderRecord = false;
                        csv.Configuration.Delimiter = ";";
                        var t = document.AddTable(1, 3);
                        bool addToFirstRow = true;
                        paragraph = "";
                        // Inserts the data from CSV file correctly into a table.
                        while (csv.Read())
                        {
                            for (int i = 0; csv.TryGetField<string>(i, out paragraph); i++)
                            {
                                string[] cellArray = paragraph.Split(',');
                                var r = t.Rows[0];
                                if (addToFirstRow == true)
                                {
                                    r = t.Rows[0];
                                    addToFirstRow = false;
                                }
                                else
                                {
                                    r = t.InsertRow();
                                }
                                int cellIndex = 0;
                                for (int k = 0; k < cellArray.Length; k++)
                                {
                                    r.Cells[cellIndex].Paragraphs[0].Append(cellArray[k]);
                                    cellIndex++;
                                }
                            }
                        }
                        document.InsertTable(t);  // Insert table into the document.
                    }
                    document.InsertParagraph("\r\n");
                }
            }
            if (File.Exists(Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "plot.jpeg")) && input.IsUndiscDepDone != "No")
            {
                var img = document.AddImage(Path.Combine(input.Env.RootPath, "UndiscDep", input.SelectedTractCombination, "SelectedResult", "plot.jpeg"));
                Picture p = img.CreatePicture(600, 605);
                paragraph = "\r\n";
                Paragraph par = document.InsertParagraph(paragraph);
                par.AppendPicture(p);
                par.Append("\r\n");

                severalParagraphs = document.InsertParagraph("Figure 2. ").Bold();
                severalParagraphs.Append("A. Negative binomial probability mass function representing the number of undiscovered deposits" +
                    " in the permissive tracts. B. Probability mass function recast as elicitation percentiles (black dots) and" +
                    " compared to the estimated numbers of undiscovered deposits (red circles). The size of a red circle indicates how many" +
                    " assessment team members picked the same number of undiscovered deposits." + "\r\n\r\n");
            }
        }

        /// <summary>
        /// Writes information from the Monte Carlo tool's files.
        /// </summary>
        /// <param name="input">Inputs.</param>
        /// <param name="document">Word document.</param>
        /// <param name="tractID">Selected tractID.</param>
        private void WriteEconomicFilter(ReportingAssesmentInputParams input, DocX document)
        {
            //string paragraph = "Estimated total undiscovered resources in the permissive tracts" + "\r\n";
            string paragraph = "Estimated economic portion of the total undiscovered resources" + "\r\n";
            Paragraph severalParagraphs = null;
            document.InsertParagraph(paragraph).FontSize(14).Bold();
            if (Directory.Exists(Path.Combine(input.Env.RootPath, "EconFilter", "RAEF", input.SelectedTractCombination, "SelectedResult")))
            {
                DirectoryInfo di = new DirectoryInfo(Path.Combine(input.Env.RootPath, "EconFilter", "RAEF", input.SelectedTractCombination, "SelectedResult"));
                foreach (FileInfo file in di.GetFiles())
                {
                    if (input.IsRaefDone == "Yes" && file.Name.Contains("EF_04_Contained_Stats_")) //Path.Combine(input.Env.RootPath, "EconFilter", "RAEF", "SelectedResult", "EF_04_Contained_Stats_C.csv")
                    {
                        severalParagraphs = document.InsertParagraph("Table 5. ").FontSize(11).Bold();
                        severalParagraphs.Append("Estimated economic portion of the undiscovered resources" + "\r\n");
                        paragraph = "";
                        using (TextReader fileReader = File.OpenText(file.FullName)) //Path.Combine(input.Env.RootPath, "EconFilter", "RAEF", "SelectedResult", "EF_04_Contained_Stats_C.csv")
                        {
                            using (var csv = new CsvReader(fileReader))
                            {
                                csv.Configuration.HasHeaderRecord = false;
                                csv.Configuration.BadDataFound = null;
                                csv.Configuration.Delimiter = ";";
                                var t = document.AddTable(1, 9);
                                bool addToFirstRow = true;
                                while (csv.Read())
                                {
                                    for (int i = 0; csv.TryGetField<string>(i, out paragraph); i++)
                                    {
                                        string[] cellArray = paragraph.Split(',');
                                        var r = t.Rows[0];

                                        if (addToFirstRow == true)
                                        {
                                            r = t.Rows[0];
                                            addToFirstRow = false;
                                        }
                                        else
                                        {
                                            r = t.InsertRow();
                                        }
                                        int cellIndex = 0;
                                        // Remove " -chars.
                                        r.Cells[0].Paragraphs[0].Append(cellArray[0]).ReplaceText("\"", "");
                                        r.Cells[1].Paragraphs[0].Append(cellArray[6]).ReplaceText("\"", "");
                                        r.Cells[2].Paragraphs[0].Append(cellArray[7]).ReplaceText("\"", "");
                                        r.Cells[3].Paragraphs[0].Append(cellArray[11]).ReplaceText("\"", "");
                                        r.Cells[4].Paragraphs[0].Append(cellArray[15]).ReplaceText("\"", "");
                                        r.Cells[5].Paragraphs[0].Append(cellArray[16]).ReplaceText("\"", "");
                                        r.Cells[6].Paragraphs[0].Append(cellArray[1]).ReplaceText("\"", "");
                                        r.Cells[7].Paragraphs[0].Append(cellArray[17]).ReplaceText("\"", "");
                                        r.Cells[8].Paragraphs[0].Append(cellArray[18]).ReplaceText("\"", "");
                                        cellIndex++;
                                    }
                                }
                                document.InsertTable(t);
                            }
                        }
                        document.InsertParagraph("\r\n");
                        paragraph = "The parameters used in the economic filter are given in Appendix 3. " + "\r\n";
                        document.InsertParagraph(paragraph);
                    }
                }
            }
            else
            {
                //paragraph = "Estimated economic portion of the total undiscovered resources in " + input.SelectedTractCombination + " permissive tract. " + "\r\n";
                document.InsertParagraph(paragraph);
                paragraph = "Economic filter was not run for the tract. " + "\r\n";
                document.InsertParagraph(paragraph);
            }
        }

        /// <summary>
        /// Writes Descriptive and Grade-Tonnage tool's appendixes.
        /// </summary>
        /// <param name="input">Inputs.</param>
        /// <param name="document">Word document.</param>
        private void WriteAppendixes(ReportingAssesmentInputParams input, DocX document)
        {
            string paragraph = "";
            if (input.AddDescriptive == "True" && File.Exists(input.DescModel))
            {
                document.InsertParagraph().InsertPageBreakAfterSelf();
                paragraph = "Appendix 1" + "\r\n";
                document.InsertParagraph(paragraph).FontSize(14).Bold();
                paragraph = "Desciptive model for " + input.DepositType + "(" + input.DescModelName + ")\r\n";
                document.InsertParagraph(paragraph).FontSize(14).Bold();

                if (File.Exists(input.DescModel))
                {
                    using (var reportDocument = DocX.Load(input.DescModel))
                    {
                        document.InsertDocument(reportDocument, true);
                    }
                }
                //if (File.Exists(input.DescModel))
                //{
                //    using (var paraDocument = DocX.Load(input.DescModel))
                //    {
                //        if (paraDocument != null)
                //        {
                //            foreach (var para in paraDocument.Paragraphs)
                //            {
                //                document.InsertParagraph(para);
                //            }
                //        }
                //    }
                //}
            }
            if (input.AddGradeTon == "True" && Directory.Exists(input.GTModel))
            {
                document.InsertParagraph().InsertPageBreakAfterSelf();
                paragraph = "Appendix 2" + "\r\n";
                document.InsertParagraph(paragraph).FontSize(14).Bold();
                paragraph = "Grade-tonnage model for " + input.DepositType + "(" + input.GTModelName + ")\r\n";
                document.InsertParagraph(paragraph).FontSize(14).Bold();
                paragraph = Path.Combine(input.GTModel, "grade_summary.txt");
                if (File.Exists(paragraph))
                {
                    paragraph = File.ReadAllText(paragraph);
                    document.InsertParagraph(paragraph).FontSize(11).Font(new Font("Calibri"));
                }
                paragraph = Path.Combine(input.GTModel, "grade_plot.jpeg");
                if (File.Exists(paragraph))
                {
                    var img = document.AddImage(paragraph);
                    Picture p = img.CreatePicture(600, 605);
                    paragraph = "";
                    Paragraph par = document.InsertParagraph(paragraph);
                    par.AppendPicture(p);
                    par.Append("\r\n");
                    paragraph = "Histogram (A) and cumulative distribution function (B) that are calculated from the probability density" +
                        " function representing the grades. In A, the vertical red lines at the plot bottom represent the log-ratios" +
                        " calculated from the grade and tonnage model. In B, the red dots constitute empirical cumulative distribution" +
                        " function for the log-ratios calculated from the grade and tonnage model." + "\r\n";
                    document.InsertParagraph(paragraph).FontSize(11);
                }
                paragraph = Path.Combine(input.GTModel, "tonnage_summary.txt");
                if (File.Exists(paragraph))
                {
                    paragraph = File.ReadAllText(paragraph);
                    document.InsertParagraph(paragraph).FontSize(11).Font(new Font("Calibri"));
                }
                paragraph = Path.Combine(input.GTModel, "tonnage_plot.jpeg");
                if (File.Exists(paragraph))
                {
                    var img = document.AddImage(paragraph);
                    Picture p = img.CreatePicture(600, 605);
                    paragraph = "";
                    Paragraph par = document.InsertParagraph(paragraph);
                    par.AppendPicture(p);
                    par.Append("\r\n");

                    paragraph = "A: Probability density function that represents the ore tonnage in an undiscovered deposit.The vertical" +
                        " lines at the bottom represent the ore tonnages from the grade and tonnage model. B: Corresponding cumulative " +
                        "distribution function(solid line). The red dots constitute the empirical cumulative distribution function " +
                        "for the ore tonnages from the grade and tonnage model." + "\r\n";
                    document.InsertParagraph(paragraph).FontSize(11);
                }
            }
            if (Directory.Exists(Path.Combine(input.Env.RootPath, "EconFilter", "RAEF", input.SelectedTractCombination, "SelectedResult")))
            {
                DirectoryInfo di = new DirectoryInfo(Path.Combine(input.Env.RootPath, "EconFilter", "RAEF", input.SelectedTractCombination, "SelectedResult"));
                foreach (FileInfo file in di.GetFiles())
                {
                    if (input.AddRaef == "True" && file.Name.Contains("EF_01_Parameters_")) //Path.Combine(input.Env.RootPath, "EconFilter", "RAEF", "SelectedResult", "EF_01_Parameters_C.csv")
                    {
                        paragraph = "Appendix 3";
                        document.InsertParagraph(paragraph).FontSize(14).Bold();
                        paragraph = "";
                        using (TextReader fileReader = File.OpenText(file.FullName))
                        {
                            using (var csv = new CsvReader(fileReader))
                            {
                                csv.Configuration.HasHeaderRecord = false;
                                csv.Configuration.BadDataFound = null;
                                csv.Configuration.Delimiter = ";";
                                var t = document.AddTable(1, 2);
                                bool addToFirstRow = true;

                                while (csv.Read())
                                {
                                    // Gets information from CSV file.
                                    for (int i = 0; csv.TryGetField<string>(i, out paragraph); i++)
                                    {
                                        char[] valueArray = paragraph.ToArray();
                                        int j = 0;
                                        while (valueArray[j] != '"')
                                        {
                                            paragraph = paragraph.Remove(0, 1);
                                            j++;
                                        }
                                        string[] cellArray = paragraph.Split(',');
                                        var r = t.Rows[0];
                                        if (addToFirstRow == true)
                                        {
                                            r = t.Rows[0];
                                            addToFirstRow = false;
                                        }
                                        else
                                        {
                                            r = t.InsertRow();
                                        }
                                        r.Cells[0].Paragraphs[0].Append(cellArray[0]).ReplaceText("\"", "");
                                        r.Cells[1].Paragraphs[0].Append(cellArray[1]).ReplaceText("\"", "");
                                        r.Cells[1].Paragraphs[0].Alignment = Alignment.right;
                                    }
                                }
                                document.InsertTable(t);  // Add table into a document.
                            }
                        }
                        document.InsertParagraph("\r\n");
                    }
                }
            }

            // Add chosed tractReports
            if (input.TractIDNames != null && input.TractIDChoices != null)
            {
                foreach (var name in input.TractIDNames)
                {
                    if (input.TractIDChoices.Count > input.TractIDNames.IndexOf(name) && input.TractIDNames.IndexOf(name) != -1)
                    {
                        if (input.TractIDChoices[input.TractIDNames.IndexOf(name)] == "True" && name != null)
                        {
                            string report = Path.Combine(input.Env.RootPath, "Reporting", name, "TractReport" + name + ".docx");
                            if (File.Exists(report))
                            {
                                using (var reportDocument = DocX.Load(report))
                                {
                                    document.InsertParagraph().InsertPageBreakAfterSelf();
                                    document.InsertDocument(reportDocument, true);
                                }
                            }
                        }
                    }
                }
            }
        }

        private void WriteMonteCarlo(ReportingAssesmentInputParams input, DocX document)
        {
            
            string paragraph = "Estimated total undiscovered resources in '" + input.SelectedTractCombination + "' permissive tract" + "\r\n";
            Paragraph severalParagraphs = null;
            document.InsertParagraph(paragraph).FontSize(14).Bold();
            if (File.Exists(Path.Combine(input.Env.RootPath, "MCSim", input.SelectedTractCombination, "SelectedResult", "summary.txt")))
            {
                severalParagraphs = document.InsertParagraph("Table 4. ").Bold();
                severalParagraphs.Append(File.ReadAllText(Path.Combine(input.Env.RootPath, "MCSim", input.SelectedTractCombination, "SelectedResult", "summary.txt")) + "\r\n").Font(new Font("Consolas")).FontSize(10);
            }
            if (File.Exists(Path.Combine(input.Env.RootPath, "MCSim", input.SelectedTractCombination, "SelectedResult", "plot.jpeg")))
            {
                var img = document.AddImage(Path.Combine(input.Env.RootPath, "MCSim", input.SelectedTractCombination, "SelectedResult", "plot.jpeg"));
                Picture p = img.CreatePicture(600, 605);
                paragraph = "";
                Paragraph par = document.InsertParagraph(paragraph);
                par.AppendPicture(p);
                par.Append("\r\n");
                severalParagraphs = document.InsertParagraph("Figure 3. ").Bold();
                severalParagraphs.Append("Univariate, marginal, probability density functions(A) and univariate, marginal, complementary" +
                    " cumulative distribution functions (B) for the total ore and mineral resource tonnages in all " +
                    "undiscovered deposits within the permissive tract '" + input.SelectedTractCombination + "'." + "\r\n");
            }
            if (File.Exists(Path.Combine(input.Env.RootPath, "MCSim", input.SelectedTractCombination, "SelectedResult", "plotMarginals.jpeg")))
            {
                var img = document.AddImage(Path.Combine(input.Env.RootPath, "MCSim", input.SelectedTractCombination, "SelectedResult", "plotMarginals.jpeg"));
                Picture p = img.CreatePicture(600, 605);
                paragraph = "";
                Paragraph par = document.InsertParagraph(paragraph);
                par.AppendPicture(p);
                par.Append("\r\n");
                severalParagraphs = document.InsertParagraph("Figure 4. ").FontSize(11).Bold();
                severalParagraphs.Append("Univariate and bivariate marginal distributions for the ore and mineral resource tonnages" +
                    " in all undiscovered deposits within the permissive tract '" + input.SelectedTractCombination + "'." + "\r\n");
            }
        }
    }
}