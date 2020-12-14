using System;
using System.Windows.Data;
using System.Globalization;

namespace MapWizard.Service
{
    public class ModelTypeToBooleanConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            //return "DarkGray";
            switch ((string)value)
            {
                case "GT":
                    return "True";
                case "gt":
                    return "True";
                case "MT":
                    return "False";
                case "mt":
                    return "False";
            }
            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
