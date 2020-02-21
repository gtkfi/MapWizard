using System;
using System.Globalization;
using System.IO;
using System.Windows.Data;

namespace MapWizard.Service
{
    class FilePathToFileNameConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {          
            if(value == null)
            {
                return value = "Choose file";
            }
            if(value.ToString()=="Choose file")
            {
                return value;
            }
            if (value.ToString() == "Choose *.csv file")
            {
                return value;
            }
            try
            { 
                var fileInfo=new FileInfo(value.ToString());            
                return fileInfo.Name;
            }
            catch
            {
                return ("");
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
