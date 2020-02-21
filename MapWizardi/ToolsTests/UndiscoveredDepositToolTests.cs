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
    public class UndiscoveredDepositToolTests
    {
        [TestMethod()]
        public void ExecuteUndiscoveredDepostisToolTest01()
        {
            UndiscoveredDepositsInputParams input = new UndiscoveredDepositsInputParams
            {
               // depositsCSVPath = "c:\\temp\\mapWizard\\generalCSV_wHeaders.csv"
            };

            UndiscoveredDepositsTool unDiscoveredTool = new UndiscoveredDepositsTool();
            var result = unDiscoveredTool.Execute(input);
            Assert.IsNotNull(result);
        }
    }
}
