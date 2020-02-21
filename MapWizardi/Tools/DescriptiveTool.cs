using System;
using System.IO;

namespace MapWizard.Tools
{
    /// <summary>
    /// Input parameters for Descriptive tool.
    /// </summary>
    public class DescriptiveInputParams : ToolParameters
    {
        /// <summary>
        /// Allows the user give the path to the text file containing the descriptive model. Each heading in the file must begin and end with the character #.
        /// Each subheading in the file must begin and end with the character ¤. 
        /// After the file is selected, the tool reads it and displays its contents in separate fields, whose contents can be edited.
        /// </summary>
        public string TextFile
        {
            get { return GetValue<string>("TextFile"); }
            set { Add<string>("TextFile", value); }
        }
        /// <summary>
        /// Determines if the tool is running in File or Edit -tab.
        /// </summary>
        public string Method
        {
            get { return GetValue<string>("Method"); }
            set { Add<string>("Method", value); }
        }
        /// <summary>
        /// If “Yes” is chosen in File -tab, the tool saves the descriptive model file in a specified subfolder of its root folder when “Run tool” is clicked.
        /// </summary>
        public string Tab1ExtensionFolder
        {
            get { return GetValue<string>("Tab1ExtensionFolder"); }
            set { Add<string>("Tab1ExtensionFolder", value); }
        }
        /// <summary>
        /// If “Yes” is chosen in Edit -tab, the tool saves the descriptive model file in a specified subfolder of its root folder when “Run tool” is clicked.
        /// </summary>
        public string Tab2ExtensionFolder
        {
            get { return GetValue<string>("Tab2ExtensionFolder"); }
            set { Add<string>("Tab2ExtensionFolder", value); }
        }
    }

    /// <summary>
    /// Output parameters for Monte Carlo Simulation -tool.
    /// </summary>
    public class DescriptiveResult : ToolResult
    {
        /// <summary>
        /// The model as a text file.
        /// </summary>
        public string OutputFile
        {
            get { return GetValue<string>("OutputFile"); }
            internal set { Add<string>("OutputFile", value); }
        }
        /// <summary>
        /// The model as a text file, containing the field and subfield control characters.
        /// </summary>
        public string CharOutputFile
        {
            get { return GetValue<string>("CharOutputFile"); }
            internal set { Add<string>("CharOutputFile", value); }
        }
        /// <summary>
        /// The model as a Word file.
        /// </summary>
        public string WordOutputFile
        {
            get { return GetValue<string>("WordOutputFile"); }
            internal set { Add<string>("WordOutputFile", value); }
        }
    }

    /// <summary>
    /// Descriptive model execution.
    /// </summary>
    public class DescriptiveTool : ITool
    {
        /// <summary>
        /// Excecutes tool and returns results as parameters.
        /// </summary>
        /// <param name="inputParams">Inputs.</param>
        /// <returns>DescriptiveResult.</returns>
        public ToolResult Execute(ToolParameters inputParams)
        {
            DescriptiveResult result = new DescriptiveResult();
            try
            { 
                var input = inputParams as DescriptiveInputParams;
                string descriptiveProject = Path.Combine(inputParams.Env.RootPath, "DescModel");

                // If tool was ran in Edit -tab.
                if (input.Method== "EditedFile")
                {
                    descriptiveProject = Path.Combine(descriptiveProject, input.Tab1ExtensionFolder);
                }
                // If tool was ran in New -tab.
                else if (input.Method == "NewFile")
                {
                    descriptiveProject = Path.Combine(descriptiveProject, input.Tab2ExtensionFolder);
                }
                if (!Directory.Exists(descriptiveProject))
                {
                    Directory.CreateDirectory(descriptiveProject);
                }
                input.Save(Path.Combine(descriptiveProject, "descriptive_input_params.json"));

                if (input.Method == "EditedFile")
                {
                    result.OutputFile = Path.Combine(descriptiveProject, "DescriptiveModel.txt");
                    result.CharOutputFile = Path.Combine(descriptiveProject, "DescriptiveModel(Chars).txt");
                    result.WordOutputFile = Path.Combine(descriptiveProject, "DescriptiveModel(docx).docx");
                }
                else if (input.Method == "NewFile")
                {
                    result.OutputFile = Path.Combine(descriptiveProject, "DescriptiveNewModel.txt");
                    result.CharOutputFile = Path.Combine(descriptiveProject, "DescriptiveNewModel(Chars).txt");
                    result.WordOutputFile = Path.Combine(descriptiveProject, "DescriptiveNewModel(docx).docx");
                }
            }
            catch (Exception ex)
            {
                result.OutputFile = ex.ToString();
                throw new Exception("Output file failed: " + result, ex);
            }

            return result;
        }
        }
}
