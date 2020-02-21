using System;
using System.Windows.Data;
using System.Globalization;

namespace MapWizard.Service
{
    class SelectedIndexToBooleanConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            switch ((int)value)
            {
                case 0:
                    return true;
                case 1:
                    return true;
                case 2:
                    return false;
            }
            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}