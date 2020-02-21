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
    public class DepositDensityToolTests
    {
        [TestMethod()]
        public void ExecuteTest01()
        {
            DepositDensityInputParams input = new DepositDensityInputParams
            {
                DepositTypeId = "xxx",
                MedianTonnage = "0.5",
                AreaOfTrack = "3228",
                NumbOfKnownDeposits = "",
                ExistingDepositDensityModelID = "General",
                CSVPath = "c:\\temp\\mapWizard\\generalCSV_wHeaders.csv"
            };

            DepositDensityTool DepositDensityTool = new DepositDensityTool();
            var result = DepositDensityTool.Execute(input);
            Assert.IsNotNull(result);
        }

        [TestMethod()]
        public void ExecuteTest02()
        {
            DepositDensityInputParams input = new DepositDensityInputParams
            {
                DepositTypeId = "xxx",
                MedianTonnage = "0.5",
                AreaOfTrack = "3228",
                NumbOfKnownDeposits = "2",
                ExistingDepositDensityModelID = "General",
                CSVPath = "c:\\temp\\mapWizard\\generalCSV_wHeaders.csv"
            };

            DepositDensityTool DepositDensityTool = new DepositDensityTool();
            var result = DepositDensityTool.Execute(input);
            Assert.IsNotNull(result);
        }

        [TestMethod()]
        public void PorCuCalculation()
        {
            DepositDensityInputParams input = new DepositDensityInputParams
            {
                DepositTypeId = "xxx",
                MedianTonnage = "0.5",
                AreaOfTrack = "10000",
                NumbOfKnownDeposits = "0",
                ExistingDepositDensityModelID = "PorCu",
                CSVPath = "c:\\temp\\mapWizard\\PorCuCSV_wHeaders.csv"
            };

            DepositDensityTool DepositDensityTool = new DepositDensityTool();
            var result = DepositDensityTool.Execute(input);
            Assert.IsNotNull(result);
        }

        [TestMethod()]
        public void SaveTestCSVPath()
        {
            string output_json_file1 = @"C:\Temp\mapWizard\DepositDensity\output\output_test.json";
            GradeTonnageInputParams input = new GradeTonnageInputParams();
            input.CSVPath = @"c:\path\to\file.json";
            input.Save(output_json_file1);
            input.CSVPath = "";
            input.Load(output_json_file1);
            Assert.AreEqual(@"c:\path\to\file.json", input.CSVPath);
        }

    }
}