using Microsoft.VisualStudio.TestTools.UnitTesting;
using MapWizard.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace MapWizard.Tests
{
    [TestClass()]
    public class EconomicFilterToolTests
    {
        [TestMethod()]
        public void EconFilterTest01()
        {
            EconomicFilterInputParams input = new EconomicFilterInputParams
            {
              MCResults = "c:\\temp\\mapWizard\\MCSim\\Tract_05_SIM_EF.csv"
            };

            EconomicFilterTool EconomicFilterTool = new EconomicFilterTool();
            var result = EconomicFilterTool.Execute(input);
            Assert.IsNotNull(result);
        }

       

    }
}