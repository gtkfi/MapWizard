using System;
using System.Collections.Generic;
using System.Windows;

namespace MapWizard.Service
{
    /// <summary>
    /// Level of the notification
    /// </summary>
    public enum NotificationLevel
    {
        Information = 0,
        Good = 1,
        Warning = 2,
        Error = 3
    }

    /// <summary>
    /// IDialog Service.
    /// </summary>
    public interface IDialogService
    {
        string OpenFileDialog(string initialPath = "", string filter = "", bool checkFileExists = true, bool checkPathExists = true, string rootPath = "");
        List<string> OpenFilesDialog(string initialPath = "", string filter = "", bool checkFileExists = true, bool checkPathExists = true, string rootPath = "");
        string SelectFolderDialog(string selectedPath = "", Environment.SpecialFolder rootFolder = Environment.SpecialFolder.MyComputer);
        bool MessageBoxDialog();
        void ShowNotification(string message, string notificationType);
        void ShowMessageDialog();
        bool ConfirmationDialog(string message);
    }
}
