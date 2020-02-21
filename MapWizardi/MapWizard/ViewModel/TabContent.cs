using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// Class for setting the content of dragable tabs.
    /// </summary>
    /// /// <param name="_header">Tab header.</param>
    /// <param name="_content">Tab content.</param>   
    class TabContent
    {
        private readonly string _header;
        private readonly object _content;

        /// <summary>
        /// Setting the tab content.
        /// </summary>             
        public TabContent(string header, object content)
        {
            _header = header;
            _content = content;
        }

        /// <summary>
        /// Get tab header.
        /// </summary>        
        /// <returns>Returns tab header.</returns>
        public string Header
        {
            get { return _header; }
        }

        /// <summary>
        /// Get tab content.
        /// </summary>        
        /// <returns>Returns tab content.</returns>
        public object Content
        {
            get { return _content; }
        }
    }
}
