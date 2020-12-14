using Microsoft.VisualStudio.TestTools.UnitTesting;
using MapWizard.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace MapWizard.Tests
{
  [TestClass()]
  public class GradeTonnageInputParamsTest
  {
    public static  GradeTonnageInputParams loadedParams;
    public static readonly string test_json_file_good = @"testdata\ToolParam\grade_tonnage_input_params.json";
    public static readonly string test_json_file_bad1 =  @"testdata\ToolParam\not_found.json";
    public static readonly string test_json_file_bad2 = @"testdata\ToolParam_not_found\not_found.json";
    public static readonly string output_json_file1 = @"testdata\ToolParam\output_test.json";

    [ClassInitialize()]
    public static void ClassInit(TestContext context)
    {
      loadedParams = new GradeTonnageInputParams();
      loadedParams.Load(test_json_file_good);
    }

    [ClassCleanup()]
    public static void ClassCleanup()
    {
      try
      {
        File.Delete(output_json_file1);
      }
      catch (Exception) { }
    }

    [TestMethod()]
    [ExpectedException(typeof(System.IO.FileNotFoundException), 
      "File should be not found")]
    public void LoadNonExisting1()
    {
      GradeTonnageInputParams input = new GradeTonnageInputParams();
      input.Load(@"testdata\ToolParam\not_found.json");
    }

    [TestMethod()]
    [ExpectedException(typeof(System.IO.DirectoryNotFoundException),
      "File should be not found")]
    public void LoadNonExisting2()
    {
      GradeTonnageInputParams input = new GradeTonnageInputParams();
      input.Load(@"testdata\ToolParam_not_found\not_found.json");
    }


    [TestMethod()]
    public void LoadValidFromFile()
    {
      GradeTonnageInputParams input = new GradeTonnageInputParams();
      input.Load(test_json_file_good);

      Assert.AreEqual(@"'e:/data/ExampleGatm.csv'", input.CSVPath);
      Assert.AreEqual("TRUE", input.IsTruncated);
      Assert.AreEqual("3", input.MinDepositCount);
      Assert.AreEqual("'normal'", input.PDFType);
      Assert.AreEqual("100", input.RandomSampleCount);
      Assert.AreEqual("3", input.Seed);
    }

    [TestMethod()]
    public void SaveTestSeed()
    {
      GradeTonnageInputParams input = new GradeTonnageInputParams();
      input.Seed = "123";
      input.Save(output_json_file1);
      input.Seed = "";
      input.Load(output_json_file1);
      Assert.AreEqual("123", input.Seed);
    }

    [TestMethod()]
    public void SaveTestPDFType()
    {
      GradeTonnageInputParams input = new GradeTonnageInputParams();
      input.PDFType = "normal";
      input.Save(output_json_file1);
      input.PDFType = "";
      input.Load(output_json_file1);
      Assert.AreEqual("normal", input.PDFType);
    }

    [TestMethod()]
    public void SaveTestRandomSampleCount()
    {
      GradeTonnageInputParams input = new GradeTonnageInputParams();
      input.RandomSampleCount = "555";
      input.Save(output_json_file1);
      input.RandomSampleCount = "";
      input.Load(output_json_file1);
      Assert.AreEqual("555", input.RandomSampleCount);
    }

    [TestMethod()]
    public void SaveTestMinDepositCount()
    {
      GradeTonnageInputParams input = new GradeTonnageInputParams();
      input.MinDepositCount = "1000";
      input.Save(output_json_file1);
      input.MinDepositCount = "";
      input.Load(output_json_file1);
      Assert.AreEqual("1000", input.MinDepositCount);
    }

    [TestMethod()]
    public void SaveTestIsTruncated()
    {
      GradeTonnageInputParams input = new GradeTonnageInputParams();
      input.IsTruncated = "TRUE";
      input.Save(output_json_file1);
      input.IsTruncated = "";
      input.Load(output_json_file1);
      Assert.AreEqual("TRUE", input.IsTruncated);
    }

    [TestMethod()]
    public void SaveTestCSVPath()
    {
      GradeTonnageInputParams input = new GradeTonnageInputParams();
      input.CSVPath = @"c:\path\to\file.json";
      input.Save(output_json_file1);
      input.CSVPath = "";
      input.Load(output_json_file1);
      Assert.AreEqual(@"c:\path\to\file.json", input.CSVPath);
    }


    [TestMethod()]
    public void SaveTestComplete()
    {
      loadedParams.Save(output_json_file1);
      GradeTonnageInputParams second = new GradeTonnageInputParams();
      second.Load(output_json_file1);

      Assert.AreEqual(loadedParams.CSVPath, second.CSVPath);
      Assert.AreEqual(loadedParams.IsTruncated, second.IsTruncated);
      Assert.AreEqual(loadedParams.MinDepositCount, second.MinDepositCount);
      Assert.AreEqual(loadedParams.PDFType, second.PDFType);
      Assert.AreEqual(loadedParams.RandomSampleCount, second.RandomSampleCount);
      Assert.AreEqual(loadedParams.Seed, second.Seed);
    }
  }
}

