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

        private string state = "";


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

        private void CleanPolygonlist_MouseDown(object sender, MouseButtonEventArgs e)
        {
            if (tractboundarylistBox.SelectedItem != null)
            {
                //MessageBox.Show(tractboundarylistBox.SelectedItem.ToString());
                Process.Start(cleanPolygonlistBox.SelectedItem.ToString());
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

        private void FuzzyBtnClick(object sender, RoutedEventArgs e)
        {
            /*Deliniation.IsSelected = true;
            fuzzyL.IsSelected = true;*/
            classification_fuzzy.IsSelected = true;
            classification_fuzzy.Content = fuzzyL.Content;
            delRaster_header.Text = "Folder for classification raster:";
            state = "classification";
        }
        private void cl_fuzzy_Clicked(object sender, RoutedEventArgs e)
        {
            FuzzyBtnClick(sender, e);
            var viewModel = (PermissiveTractViewModel)DataContext;
            if (viewModel.ClassificationFuzzyCommand.CanExecute(null))
                viewModel.ClassificationFuzzyCommand.Execute(null);
        }

        private void de_fuzzy_Clicked(object sender, RoutedEventArgs e)
        {
            delRaster_header.Text = "Folder for saving delineation raster:";
        }


        private void WofeBtnClick(object sender, RoutedEventArgs e)
        {
            classification_wofe.IsSelected = true;
            classification_wofe.Content = Wofe.Content;
            delRasterWofe.Text = "Folder for classification raster:";
            state = "classification";
        }

        private void cl_wofe_Clicked(object sender, RoutedEventArgs e)
        {
            WofeBtnClick(sender, e);
            var viewModel = (PermissiveTractViewModel)DataContext;
            if (viewModel.ClassificationWofeCommand.CanExecute(null))
                viewModel.ClassificationWofeCommand.Execute(null);
        }


        private void de_wofe_Clicked(object sender, RoutedEventArgs e)
        {
            delRasterWofe.Text = "Folder for saving delineation raster:";
            var viewModel = (PermissiveTractViewModel)DataContext;
            if (viewModel.DelineationWofeCommand.CanExecute(null))
                viewModel.DelineationWofeCommand.Execute(null);
        }

        private void Button_Click_3(object sender, RoutedEventArgs e)
        {
            if ((bool)lastround.IsChecked == true && state == "classification")
            {
                Classification.IsSelected = true;
                classification_main.IsSelected = true;
                state = "";
                delRaster_header.Text = "Folder for saving delineation raster:";
            }

        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            if (state == "classification")
            {
                classification_main.IsSelected = true;
            }
            state = "";
            delRasterWofe.Text = "Folder for saving delineation raster:";
        }

        private void classification_Clicked(object sender, RoutedEventArgs e)
        {
            classification_main.IsSelected = true;
        }

        private void delineation_Clicked(object sender, RoutedEventArgs e)
        {
            InputLayer.IsSelected = true;
        }

        private void de_fuzzy_Clicked(object sender, MouseButtonEventArgs e)
        {
            var viewModel = (PermissiveTractViewModel)DataContext;
            if (viewModel.DelineationFuzzyCommand.CanExecute(null))
                viewModel.DelineationFuzzyCommand.Execute(null);
        }
    }


}
