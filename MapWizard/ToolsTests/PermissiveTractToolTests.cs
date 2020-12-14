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
  public class PermissiveTractToolTest
  {
    [TestMethod()]
    public void ExecuteTest01()
    {
      Int32 unixTimestamp = (Int32)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;

      // Hard coded parameters (for now)
      string pythonPath = "C:\\Program Files\\ArcGIS\\Pro\\bin\\Python\\envs\\arcgispro-py3\\pythonw.exe";
      List<String> inRasterList = new List<string>{ };
      string scriptPath = "..\\..\\..\\Tools\\scripts\\FuzzyOverlay.pyw";
      string EnvPath = "";
      string OutRaster = "../../../ToolsTests/testdata/MAP/TestOutput/FuzzyOverlayTest_" + unixTimestamp.ToString();

      PermissiveTractInputParams inputParams = new PermissiveTractInputParams
      {
        PythonPath = pythonPath,
        ScriptPath = scriptPath,
        EnvPath = EnvPath,
        InRasterList = inRasterList,
        OutRaster = OutRaster
      };

      PermissiveTractTool permissiveTractTool = new PermissiveTractTool();
      var result = permissiveTractTool.Execute(inputParams);
      
      Assert.AreNotEqual("Value received from script: ", result);
    }
  }
}