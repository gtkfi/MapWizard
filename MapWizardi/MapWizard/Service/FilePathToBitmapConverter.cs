using System;
using System.Globalization;
using System.Windows.Data;
using System.Windows.Media.Imaging;

namespace MapWizard.Service
{
    class FilePathToBitmapConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            //(Uri source)
                var imgUri = new Uri(value.ToString());
                var bitmap = new BitmapImage();
                bitmap.BeginInit();
                bitmap.UriSource = imgUri;
                bitmap.CreateOptions = BitmapCreateOptions.IgnoreImageCache; //Image cache must be ignored, to be able to update the images
                bitmap.CacheOption = BitmapCacheOption.OnLoad;
                bitmap.EndInit();
                bitmap.Freeze(); //Bitmap must be freezable, so it can be accessed from other threads.

                return bitmap;   
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
