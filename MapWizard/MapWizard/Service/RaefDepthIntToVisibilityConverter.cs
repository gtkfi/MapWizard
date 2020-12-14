using CommonServiceLocator;
using GalaSoft.MvvmLight.Ioc;
using MapWizard.ViewModel;
using System;
using System.Globalization;
using System.Windows.Data;
namespace MapWizard.Service
{
    class RaefDepthIntToVisibilityConverter : IValueConverter
    {

        
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null)
                return null;
            ServiceLocator.SetLocatorProvider(() => SimpleIoc.Default);
            int depthIntervals=ServiceLocator.Current.GetInstance<EconomicFilterViewModel>().Model.RaefDepthIntervals;

            if (int.Parse(parameter.ToString())<= depthIntervals)
                return "Visible";
            else
                return "Collapsed";
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
