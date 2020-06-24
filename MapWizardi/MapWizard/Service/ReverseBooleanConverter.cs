using System;
using System.Windows.Data;
using System.Globalization;

namespace MapWizard.Service
{
    class ReverseBooleanConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if(value == null)
            {
                return "false";
            }
            switch (value)
            {
                case true:
                    return "false";
                case false:
                    return "true";
            }
            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null)
            {
                return false;
            }
            switch (value)
            {
                case true:
                    return "false";
                case false:
                    return "true";
            }
            return null;
            throw new NotImplementedException();
        }
    }
}
