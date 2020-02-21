using Dragablz;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapWizard.ViewModel
{
    /// <summary>
    /// Class for creating and containing the InterTabClient that the View can bind to.
    /// </summary>
    /// <param name="_interTabClient">InterTabClient.</param>
    
    public class TabViewModel       
    {
        private readonly IInterTabClient _interTabClient;

        /// <summary>
        /// Create InterTabClient
        /// </summary>
        public TabViewModel()
        {
            _interTabClient = new MyInterTabClient();
        }
        /// <summary>
        /// Get InterTabClient.
        /// </summary>
        /// <returns>Returns InterTabClient.</returns>
        public IInterTabClient InterTabClient
        {
            get { return _interTabClient; }
        }
    }
}
