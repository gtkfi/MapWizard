using System.Windows;
using Hummingbird.UI;
using Microsoft.Win32;
using MapWizard.ViewModel;
using System;
using MapWizard.Service;
using System.Windows.Controls;
using System.Collections.Generic;
using System.Windows.Data;
using System.Windows.Input;
using System.Diagnostics;

namespace MapWizard
{
    /// <summary>
    /// Interaction logic for PermissiveTractView.xaml
    /// </summary>
    public partial class PermissiveTractView : UserControl
    {
        //private IDialogService dialogService;

        public PermissiveTractView()
        {
            InitializeComponent();

        }

        private void OnButtonClick(object sender, RoutedEventArgs e)
        {
            if (listBox2.SelectedItem != null)
            {
                listBox.Items.Add(listBox2.SelectedItem);
            }
            BindingOperations.GetBindingExpression(listBox, ItemsControl.ItemsSourceProperty).UpdateSource();
        }

        private void UploadRasters(object sender, RoutedEventArgs e)
        {
            try
            {
                IDialogService dialogService = new DialogService();
                List<string> files = dialogService.OpenFilesDialog("", "All files (*.*)|*.*", true, true);

                if (!string.IsNullOrEmpty(files.ToString()))
                {
                    foreach (string f in files)
                    {
                        listBox2.Items.Add(f);
                    }
                }
            }
            catch (Exception ex)
            {
                //logger.Error(ex, "Failed to show OpenFilesDialog");
            }
            finally
            {
            }
        }

        private void TextBlock_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (tractboundarylistBox.SelectedItem != null)
            {
                //MessageBox.Show(tractboundarylistBox.SelectedItem.ToString());
                Process.Start(tractboundarylistBox.SelectedItem.ToString());
            }

        }

        private void RasterList_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (classifiedRasterlistBox.SelectedItem != null)
            {
                //MessageBox.Show(tractboundarylistBox.SelectedItem.ToString());
                Process.Start(classifiedRasterlistBox.SelectedItem.ToString());
            }

        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {

        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {

        }
    }


}
