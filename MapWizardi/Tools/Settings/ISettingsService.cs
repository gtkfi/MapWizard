namespace MapWizard.Tools.Settings

{  /// <summary>
   /// ISettings Service.
   /// </summary>
    public interface ISettingsService
    {
        SettingsDataModel Data { get; set; }
        string PythonPath { get; set; }
        string RPath { get; set; }
        string RootPath { get; set; }
        string DepositModelsPath { get; set; }
        void AddToRegistry(string MAPWfile);
        void SaveSettings(string json_file);
        void LoadSettings(string json_file);
    }
}
