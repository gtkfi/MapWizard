using System.Windows;
using Hummingbird.UI;
using Microsoft.Win32;
using MapWizard.ViewModel;
using System;
using MapWizard.Service;
using System.Windows.Controls;

namespace MapWizard
{
  /// <summary>
  /// Interaction logic for GradeTonnageView.xaml
  /// </summary>
  public partial class GradeTonnageView : UserControl
    {
    public GradeTonnageView()
    {
      InitializeComponent();
    }

        private void gradecheckbox_Checked(object sender, RoutedEventArgs e)
        {
            if (gradetonnagecheckbox != null)
            gradetonnagecheckbox.IsChecked = false;
        }

        private void tonnagecheckbox_Checked(object sender, RoutedEventArgs e)
        {
            if (gradetonnagecheckbox != null)
                gradetonnagecheckbox.IsChecked = false;
        }

        private void gradetonnagecheckbox_Checked(object sender, RoutedEventArgs e)
        {
            gradecheckbox.IsChecked = false;
            tonnagecheckbox.IsChecked = false;
        }
    }
}
