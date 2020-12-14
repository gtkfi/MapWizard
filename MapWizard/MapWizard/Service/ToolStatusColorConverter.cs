using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace MapWizard.Service
{
    public class ToolStatusColorConverter:IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            //return "DarkGray";
            switch ((Int32)(value))
            {
                case 0:
                    return "Red";
                case 1:
                    return "LimeGreen";
                case 2:
                    return "DarkGray";
            }
            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
