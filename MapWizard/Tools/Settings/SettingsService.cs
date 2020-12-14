using Microsoft.Win32;
using NLog;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace MapWizard.Tools.Settings
{
    /// <summary>
    /// Settings service class.
    /// </summary>
    public class SettingsService : ISettingsService
    {
        public string SelectedProjectPath { get; set; }
        private string settings_json;
        private readonly ILogger logger = NLog.LogManager.GetCurrentClassLogger();
        private SettingsDataModel data = new SettingsDataModel();

        public SettingsService()
        {
            // Path to settings_json: C:\ProgramData\MapWizard\settings.json
            string SettingsDirectory = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), "MapWizard");
            if (!Directory.Exists(SettingsDirectory))
            {
                Directory.CreateDirectory(SettingsDirectory);
            }
            settings_json = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData), "MapWizard", "settings.json");
            if (!File.Exists(settings_json) || new FileInfo(settings_json).Length == 0)
            {
                //SetupPythonPath();
                //string pythonPath =  "C:\\Program Files\\ArcGIS\\Pro\\bin\\Python\\envs\\arcgispro-py3\\pythonw.exe";
                SettingsInitialization();
                SaveSettings(settings_json);
            }
            else
            {
                LoadSettings(settings_json);  // If the settings file exist then the settings will be loaded.
            }
        }

        /// <summary>
        /// Save Settings.
        /// </summary>
        /// <param name="json_file">File to be saved.</param>
        public void SaveSettings(string json_file)
        {
            Data.Save(json_file);
        }

        /// <summary>
        /// Load Settings.
        /// </summary>
        /// <param name="json_file">File to be loaded.</param>
        public void LoadSettings(string json_file)
        {
            try
            {                
                Data.Load(json_file);
                // Default paths should always be the same, so they will always be initialized to be same paths.
                Data.PythonPathDefault = "C:\\Python27\\ArcGIS10.6\\pythonw.exe";  //Propably needs a better way to get the path.                                                                             // rPath = SetupRPath();
                Data.RPathDefault = Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "scripts", "R-3.6.3", "bin", "rscript.exe");
                Data.DepModelsFolderPathDefault = Path.Combine(Path.GetPathRoot(Environment.SystemDirectory), "Temp", "MapWizard");  // This path might be changed in the future.                
                //CheckSettingsValidation(); // Will be added or removed in future releases.
                //Data.Load(json_file);
            }
            catch (Exception ex)
            {
                SettingsInitialization();
                SaveSettings(json_file);
                logger.Error(ex, "Error in Model Selection"); // Might need dialog notification.
                throw;
            }
        }

        public void SettingsInitialization()
        {
            string pythonPath = "C:\\Python27\\ArcGIS10.6\\pythonw.exe";  //Propably needs a better way to get the path.
            // rPath = SetupRPath();
            string defaultRPath= Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "scripts", "R-3.6.3", "bin", "rscript.exe");
            string rootPath = Path.Combine(Path.GetPathRoot(Environment.SystemDirectory), "Temp", "MapWizard");  // This path might be changed in the future.
            Data = new SettingsDataModel()
            {
                PythonPathDefault = pythonPath,
                PythonPathCustom = pythonPath,
                PythonLocationDefault = "true",
                RPathDefault = defaultRPath,
                RPathCustom = defaultRPath,
                RLocationDefault = "true",
                DepModelsFolderPathDefault = rootPath,
                DepModelsFolderPathCustom = rootPath,
                DepModelsLocationDefault = "true",
                SelectedProjectName = "",
                SelectedProjectPath = ""
            };
        }
        /*  Not used in this version.
                /// <summary>
                ///Checks if settings are valid.
                /// </summary>
                private void CheckSettingsValidation()
                {
                    string rPath = SetupRPath();
                    string rootPath = Path.Combine(Path.GetPathRoot(Environment.SystemDirectory), "Temp", "MapWizard");
                    string depModFolders = Path.Combine(rootPath, "DepositModels");
                    if (Data.PythonEXEPath == null)
                    {
                        Data.PythonEXEPath = "C:\\Python27\\ArcGIS10.6\\pythonw.exe";
                    }
                    if (Data.REXEPath == null)
                    {
                        Data.REXEPath = rPath;
                    }
                    if (Data.DepModFolderPath == null)
                    {
                        Data.DepModFolderPath = rootPath;
                    }
                    if (Data.REXEPathDefault == null)
                    {
                        Data.REXEPathDefault = rPath;
                    }
                    if (Data.PyEXEPathDefault == null)
                    {
                        Data.PyEXEPathDefault = "C:\\Python27\\ArcGIS10.6\\pythonw.exe";
                    }
                    if (Data.DepModFolderPathDefault == null)
                    {
                        Data.DepModFolderPathDefault = rootPath;
                    }
                    if (Data.DefaultPythonLocation != "true" && Data.DefaultPythonLocation != "false" && Data.DefaultPythonLocation != "True" && Data.DefaultPythonLocation != "False")
                    {
                        Data.DefaultPythonLocation = "true";
                    }
                    if (Data.CustomPythonLocation != "true" && Data.CustomPythonLocation != "false" && Data.CustomPythonLocation != "True" && Data.CustomPythonLocation != "False")
                    {
                        Data.CustomPythonLocation = "false";
                    }
                    if (Data.PyButtonVisibility != "true" && Data.PyButtonVisibility != "false" && Data.PyButtonVisibility != "True" && Data.PyButtonVisibility != "False")
                    {
                        Data.PyButtonVisibility = "false";
                    }
                    if (Data.DefaultRLocation != "true" && Data.DefaultRLocation != "false" && Data.DefaultRLocation != "True" && Data.DefaultRLocation != "False")
                    {
                        Data.DefaultRLocation = "true";
                    }
                    if (Data.CustomRLocation != "true" && Data.CustomRLocation != "false" && Data.CustomRLocation != "True" && Data.CustomRLocation != "False")
                    {
                        Data.CustomRLocation = "false";
                    }
                    if (Data.RButtonVisibility != "true" && Data.RButtonVisibility != "false" && Data.RButtonVisibility != "True" && Data.RButtonVisibility != "False")
                    {
                        Data.RButtonVisibility = "false";
                    }
                    if (Data.DefaultDepModLocation != "true" && Data.DefaultDepModLocation != "false" && Data.DefaultDepModLocation != "True" && Data.DefaultDepModLocation != "False")
                    {
                        Data.DefaultDepModLocation = "true";
                    }
                    if (Data.CustomDepModLocation != "true" && Data.CustomDepModLocation != "false" && Data.CustomDepModLocation != "True" && Data.CustomDepModLocation != "False")
                    {
                        Data.CustomDepModLocation = "false";
                    }
                    if (Data.DepModButtonVisibility != "true" && Data.DepModButtonVisibility != "false" && Data.DepModButtonVisibility != "True" && Data.DepModButtonVisibility != "False")
                    {
                        Data.DepModButtonVisibility = "false";
                    }
                    if (Data.SelectedProjectName == null)
                    {
                        Data.SelectedProjectName = "";
                    }
                    if (Data.SelectedProjectPath == null)
                    {
                        Data.SelectedProjectPath = "";
                    }
                    SaveSettings(settings_json);
                }
        */
        /// <summary>
        ///Get R path from the registry.
        /// </summary>
        /// <returns>R path.</returns>
        private string SetupRPath()
        {
            try
            {
                RegistryKey regKey = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\R-core\R");
                string[] nameList = regKey.GetSubKeyNames();
                RegistryKey subKey = regKey.OpenSubKey(nameList[0]);
                string rInstallationFolder = subKey.GetValue("InstallPath").ToString();
                return rInstallationFolder + "\\bin\\RScript.exe";
            }
            catch (Exception ex)
            {
                logger.Trace(ex, "Error in Model Selection");
                return "";
            }
        }

        /// <summary>
        /// Python path.
        /// </summary>
        /// <returns>Python path.</returns>
        public string PythonPath
        {
            get
            {
                if (data.PythonLocationDefault == "True")
                {
                    return data.PythonPathDefault;
                }
                else
                {
                    return data.PythonPathCustom;
                }
            }
            set
            {
                if (data.PythonPathDefault == value)
                {
                    data.PythonLocationDefault = "True";
                    return;
                }
                data.PythonLocationDefault = "False";
                data.PythonPathCustom = value;
            }
        }

        /// <summary>
        /// R path.
        /// </summary>
        /// <returns>R path.</returns>
        public string RPath
        {
            get
            {
                if (data.RLocationDefault == "True")
                {
                    return data.RPathDefault;
                }
                else
                {
                    return data.RPathCustom;
                }
            }
            set
            {
                if (data.RPathDefault == value)
                {
                    data.RLocationDefault = "True";
                    return;
                }
                data.RLocationDefault = "False";
                data.RPathCustom = value;
            }
        }

        /// <summary>
        /// Root path.
        /// </summary>
        /// <returns>Root path.</returns>
        public string RootPath
        {
            get
            {
                return data.RootFolderPath;
            }
            set
            {
                if (data.RootFolderPath == value)
                {
                    return;
                }
                data.RootFolderPath = value;
            }
        }
        /// <summary>
        /// Deposit Models folder path.
        /// </summary>
        /// <returns>Deposit Models folder path.</returns>
        public string DepositModelsPath
        {
            get
            {
                if (data.DepModelsLocationDefault == "True")
                {
                    return data.DepModelsFolderPathDefault;
                }
                else
                {
                    return data.DepModelsFolderPathCustom;
                }
            }
            set
            {
                if (data.DepModelsFolderPathDefault == value)
                {
                    data.DepModelsLocationDefault = "True";
                    return;
                }
                data.DepModelsLocationDefault = "False";
                data.DepModelsFolderPathCustom = value;
            }
        }

        /// <summary>
        /// Add project's path to registry.
        /// </summary>
        /// <param name="MAPWfile">File to be added.</param>
        public void AddToRegistry(string MAPWfile)
        {
            try
            {
                RegistryKey RegKey = Registry.CurrentUser.CreateSubKey(@"SOFTWARE\MapProjects");
                if (RegKey.GetValue("ProjectList") != null)
                {
                    string[] nameArray = (string[])RegKey.GetValue("ProjectList");
                    List<string> ProjectList = nameArray.ToList();
                    List<string> NewProjectList = new List<string>();
                    // Checks if the file is already in the registry.
                    foreach (string item in ProjectList)
                    {
                        if (item != MAPWfile)
                        {
                            NewProjectList.Add(item);
                        }
                    }
                    ProjectList = NewProjectList;
                    // Only keeps the five last projects. List have to be reversed before adding the path, so that it is added correctly.
                    if (nameArray.Length == 5)
                    {
                        ProjectList.Reverse();
                        ProjectList.Add(MAPWfile);
                        ProjectList.RemoveAt(0);
                        ProjectList.Reverse();
                    }
                    else
                    {
                        ProjectList.Reverse();
                        ProjectList.Add(MAPWfile);
                        ProjectList.Reverse();
                    }
                    RegKey.SetValue("ProjectList", ProjectList.ToArray());
                }
                // If there's no project list in the registry then it will be created.
                else
                {
                    RegKey.SetValue("ProjectList", new string[] { MAPWfile });
                }
            }
            catch (Exception ex)
            {
                logger.Trace(ex, "Error in Model Selection");
            }
        }

        /// <summary>
        ///Model for SettingsDataModel.
        /// </summary>
        /// <returns>SettingsDataModel.</returns>
        public SettingsDataModel Data
        {
            get
            {
                return data;
            }
            set
            {
                data = value;
            }
        }
    }
}
