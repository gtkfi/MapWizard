using Dragablz;
using MapWizard.View;
using MapWizard.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace MapWizard.ViewModel
{
    class MyInterTabClient : IInterTabClient
    {
        /// <summary>
        /// Implementation of InterTabClient.
        /// To open dragged tabs in a different window class than they originated from.
        /// </summary>
        /// <param name="interTabClient">InterTabClient</param>
        /// <param name="partition">Partition</param>
        /// <param name="source">Source</param>
        /// <returns>Tab host.</returns>
        public INewTabHost<Window> GetNewHost(IInterTabClient interTabClient, object partition, TabablzControl source)
        {
            var view = new TabWindow();
            view.TabablzControl.Items.Clear();
            return new NewTabHost<Window>(view, view.TabablzControl); //TabablzControl is a names control in the XAML.
        }
        /// <summary>
        /// TabEmptiedHandler. Whether closing a tab should close whole window or not.
        /// </summary>
        /// <param name="tabControl">TabControl.</param>
        /// <param name="window">Window.</param>
        /// <returns>TabEmbtied response.</returns>
        public TabEmptiedResponse TabEmptiedHandler(TabablzControl tabControl, Window window)
        {
            if (window is TabWindow)
                return TabEmptiedResponse.CloseWindowOrLayoutBranch;
            return TabEmptiedResponse.DoNothing;
        }
    }
}
