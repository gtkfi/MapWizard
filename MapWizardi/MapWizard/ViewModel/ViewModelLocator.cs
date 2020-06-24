/*
  In App.xaml:
  <Application.Resources>
      <vm:ViewModelLocator xmlns:vm="clr-namespace:MapWizard"
                           x:Key="Locator" />
  </Application.Resources>
  
  In the View:
  DataContext="{Binding Source={StaticResource Locator}, Path=ViewModelName}"

  You can also use Blend to do all this with the tool's support.
  See http://www.galasoft.ch/mvvm
*/

using GalaSoft.MvvmLight.Ioc;
using MapWizard.Service;
using MapWizard.Tools.Settings;
using NLog;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// This class contains static references to all the view models in the
    /// application and provides an entry point for the bindings.
    /// </summary>
    public class ViewModelLocator
    {
        /// <summary>
        /// Initializes a new instance of the ViewModelLocator class.
        /// </summary>
        public ViewModelLocator()
        {
            CommonServiceLocator.ServiceLocator.SetLocatorProvider(() => SimpleIoc.Default);
            SimpleIoc.Default.Unregister<ILogger>(); 
            SimpleIoc.Default.Register<ILogger>(() => LogManager.GetCurrentClassLogger());
            SimpleIoc.Default.Register<ISettingsService, SettingsService>();
            SimpleIoc.Default.Register<SettingsViewModel>();
            SimpleIoc.Default.Register<MainViewModel>();
            SimpleIoc.Default.Register<IDialogService, DialogService>(); 
            SimpleIoc.Default.Register<TabViewModel>();
        }

        /// <summary>
        /// MainViewModel.
        /// </summary>
        /// @return MainViewModel.
        public MainViewModel Main
        {
            get
            {
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<MainViewModel>();                
            }
        }

        /// <summary>
        /// GradeTonnageViewModel.
        /// </summary>
        /// @return GradeTonnageViewModel.
        public GradeTonnageViewModel GradeTonnageViewModel
        {
            get
            {
                if (!SimpleIoc.Default.IsRegistered<GradeTonnageViewModel>())
                {
                    return null;
                }
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<GradeTonnageViewModel>();
            }
        }

        /// <summary>
        /// PermissiveTractViewModel.
        /// </summary>
        /// @return PermissiveTractViewModel.
        public PermissiveTractViewModel PermissiveTractViewModel
        {
            get
            {
                if (!SimpleIoc.Default.IsRegistered<PermissiveTractViewModel>())
                {
                    return null;
                }
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<PermissiveTractViewModel>();
            }
        }

        /// <summary>
        /// DepositDensityViewModel.
        /// </summary>
        /// @return DepositDensityViewModel.
        public DepositDensityViewModel DepositDensityViewModel
        {
            get
            {
                if (!SimpleIoc.Default.IsRegistered<DepositDensityViewModel>())
                {
                    return null;
                }
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<DepositDensityViewModel>();
            }
        }

        /// <summary>
        /// UndiscoveredDepositsViewModel.
        /// </summary>
        /// @return UndiscoveredDepositsViewModel.
        public UndiscoveredDepositsViewModel UndiscoveredDepositsViewModel
        {
            get
            {
                if (!SimpleIoc.Default.IsRegistered<UndiscoveredDepositsViewModel>())
                {
                    return null;
                }
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<UndiscoveredDepositsViewModel>();
            }
        }

        /// <summary>
        /// MonteCarloSimulationViewModel.
        /// </summary>
        /// @return MonteCarloSimulationViewModel.
        public MonteCarloSimulationViewModel MonteCarloSimulationViewModel
        {
            get
            {
                if (!SimpleIoc.Default.IsRegistered<MonteCarloSimulationViewModel>())
                {
                    return null;
                }
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<MonteCarloSimulationViewModel>();
            }
        }

        /// <summary>
        /// EconomicFilterViewModel.
        /// </summary>
        /// @return EconomicFilterViewModel.
        public EconomicFilterViewModel EconomicFilterViewModel
        {

            get
            {
                if (!SimpleIoc.Default.IsRegistered<EconomicFilterViewModel>())
                {
                    return null;
                }
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<EconomicFilterViewModel>();
            }
        }

        /// <summary>
        /// DescriptiveViewModel.
        /// </summary>
        /// @return DescriptiveViewModel.
        public DescriptiveViewModel DescriptiveViewModel
        {
            get
            {
                if (!SimpleIoc.Default.IsRegistered<DescriptiveViewModel>())
                {
                    return null;
                }
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<DescriptiveViewModel>();
            }
        }

        /// <summary>
        /// SettingsViewModel.
        /// </summary>
        /// @return SettingsViewModel.
        public SettingsViewModel SettingsViewModel
        {
            get
            {
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<SettingsViewModel>();
            }
        }

        /// <summary>
        /// TabViewModel.
        /// </summary>
        /// @return TabViewModel.
        public TabViewModel TabViewModel
        {
            get
            {
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<TabViewModel>();
            }
        }

        /// <summary>
        /// TractAggregationViewModel.
        /// </summary>
        /// @return TractAggregationViewModel.
        public TractAggregationViewModel TractAggregationViewModel
        {
            get
            {
                if (!SimpleIoc.Default.IsRegistered<TractAggregationViewModel>())
                {
                    return null;
                }
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<TractAggregationViewModel>();
            }
        }

        /// <summary>
        /// ReportingViewModel.
        /// </summary>
        /// @return ReportingViewModel.
        public ReportingViewModel ReportingViewModel
        {
            get
            {
                if (!SimpleIoc.Default.IsRegistered<ReportingViewModel>())
                {
                    return null;
                }
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<ReportingViewModel>();
            }
        }

        /// <summary>
        /// ReportingAssesmentViewModel.
        /// </summary>
        /// @return ReportingViewModel.
        public ReportingAssesmentViewModel ReportingAssesmentViewModel
        {
            get
            {
                if (!SimpleIoc.Default.IsRegistered<ReportingAssesmentViewModel>())
                {
                    return null;
                }
                return CommonServiceLocator.ServiceLocator.Current.GetInstance<ReportingAssesmentViewModel>();
            }
        }

        /// <summary>
        /// Unregister and then register all the tools. Settings will not be cleared.
        /// </summary>
        public void ClearTools()
        {
            SimpleIoc.Default.Unregister<GradeTonnageViewModel>();
            SimpleIoc.Default.Unregister<PermissiveTractViewModel>();
            SimpleIoc.Default.Unregister<DepositDensityViewModel>();
            SimpleIoc.Default.Unregister<UndiscoveredDepositsViewModel>();
            SimpleIoc.Default.Unregister<MonteCarloSimulationViewModel>();
            SimpleIoc.Default.Unregister<EconomicFilterViewModel>();
            SimpleIoc.Default.Unregister<DescriptiveViewModel>();
            SimpleIoc.Default.Unregister<TractAggregationViewModel>();
            SimpleIoc.Default.Unregister<ReportingViewModel>();
            SimpleIoc.Default.Unregister<ReportingAssesmentViewModel>();
            SimpleIoc.Default.Unregister<TabViewModel>();

            SimpleIoc.Default.Register<GradeTonnageViewModel>();
            SimpleIoc.Default.Register<PermissiveTractViewModel>();
            SimpleIoc.Default.Register<DepositDensityViewModel>();
            SimpleIoc.Default.Register<UndiscoveredDepositsViewModel>();
            SimpleIoc.Default.Register<MonteCarloSimulationViewModel>();
            SimpleIoc.Default.Register<EconomicFilterViewModel>();
            SimpleIoc.Default.Register<DescriptiveViewModel>();
            SimpleIoc.Default.Register<TractAggregationViewModel>();
            SimpleIoc.Default.Register<ReportingViewModel>();
            SimpleIoc.Default.Register<ReportingAssesmentViewModel>();
            SimpleIoc.Default.Register<TabViewModel>();           
        }
    }
}