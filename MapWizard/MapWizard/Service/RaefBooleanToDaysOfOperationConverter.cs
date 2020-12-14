using System;
using System.Globalization;
using System.Windows.Data;

namespace MapWizard.Service
{
    public class RaefBooleanToDaysOfOperationConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            switch ((int)value)
            {
                case 350:
                    return true;
                case 260:
                    return false;
            }
            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null)
            {
                return 350;
            }
            switch (value)
            {
                case true:
                    return 350;
                case false:
                    return 260;
            }
            return null;
            throw new NotImplementedException();
        }
    }
}
