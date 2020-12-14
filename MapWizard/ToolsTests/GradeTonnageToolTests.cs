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
  public class GradeTonnageToolTests
  {
    [TestMethod()]
    public void ExecuteTest01()
    {
      GradeTonnageInputParams input = new GradeTonnageInputParams { CSVPath = "'../../../ToolsTests/testdata/TonnagePDF/ExampleGatm.csv'", IsTruncated = "TRUE", MinDepositCount = "3", PDFType ="'normal'", RandomSampleCount = "100", Seed = "3" };
      GradeTonnageTool tool = new GradeTonnageTool();
      var result = tool.Execute(input);
      Assert.IsNotNull(result);
    }
  }
}