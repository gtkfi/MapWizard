using MahApps.Metro.Controls;
using MapWizard.ViewModel;
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

namespace MapWizard.View
{
    /// <summary>
    /// Interaction logic for OldMainWindowView.xaml
    /// </summary>
    public partial class OldMainWindowView : UserControl
    {
        public OldMainWindowView()
        {
            InitializeComponent();
            
        }
        private void Button_Click(object sender, RoutedEventArgs e)
            {
            MainWindow mainView = new MainWindow();
            mainView.Button_Click(sender, e);
        }



        private void ToggleFlyout(Flyout settingsFlyout)
        {
            var flyout = settingsFlyout;
            if (flyout == null)
            {
                return;
            }

            flyout.IsOpen = !flyout.IsOpen;
        }

    }
}
