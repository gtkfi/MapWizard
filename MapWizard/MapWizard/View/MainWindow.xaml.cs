using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
//using Hummingbird.UI;
using MahApps.Metro.Controls;
using MapWizard.ViewModel;
using MapWizard.View;
using MahApps.Metro.Controls.Dialogs;


namespace MapWizard
{
  /// <summary>
  /// Interaction logic for MainWindow.xaml
  /// </summary>
  public partial class MainWindow : MetroWindow
  {

    public MainWindow()
    {
      NavigateToView();
      InitializeComponent();     
    }

        public void Button_Click(object sender, RoutedEventArgs e)
    {
        var flyout = (Flyout)this.Flyouts.Items[0];
        flyout.Position = Position.Right;
        this.ToggleFlyout(0);

    }

    public void ToggleFlyout(int index)
    {
        var flyout = this.Flyouts.Items[index] as Flyout;
        if (flyout == null)
        {
            return;
        }

        flyout.IsOpen = !flyout.IsOpen;
    }

    public void NavigateToView()
    {
        //MainArea.Content = new OldMainWindowView();
    }


        private void AppBarButton_Click1(object sender, RoutedEventArgs e)
    {
      //ShowToastNotification("This is error", NotificationLevel.Error);
      //ShowToastNotification("This is warning", NotificationLevel.Warning);
      //ShowToastNotification("This is good", NotificationLevel.Good);
      //ShowToastNotification("This is information", NotificationLevel.Information);
    }

        //public async void ShowMessageDialog(object sender, RoutedEventArgs e)
        //{
        //    var mySettings = new MetroDialogSettings()
        //    {
        //        AffirmativeButtonText="Back",
        //        NegativeButtonText = "No"
                
        //    };
        //    MessageDialogResult result = await this.ShowMessageAsync("Choose model", "", MessageDialogStyle.Affirmative,mySettings);
        //}


  }
}
