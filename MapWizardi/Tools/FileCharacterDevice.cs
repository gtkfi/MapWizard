using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RDotNet;
using RDotNet.Internals;
using System.IO;

namespace MapWizard.Tools
{
  class FileCharacterDevice : RDotNet.Devices.ICharacterDevice
  {
    public FileCharacterDevice(string fileName)
    {
      this.FileName = fileName;
    }

    public string FileName { get; internal set; }

    public void WriteConsole(string output, int length, ConsoleOutputType outputType)
    {
      using (var file = File.Open(FileName, FileMode.OpenOrCreate))
      {
        file.Seek(0, SeekOrigin.End);
        using (var stream = new StreamWriter(file))
          stream.WriteLine(output);
      }
    }
    public SymbolicExpression AddHistory(Language call, SymbolicExpression operation, Pairlist args, REnvironment environment)
    {
      throw new NotImplementedException();
    }

    public YesNoCancel Ask(string question)
    {
      throw new NotImplementedException();
    }

    public void Busy(BusyType which)
    {
      throw new NotImplementedException();
    }

    public void Callback()
    {
      
    }

    public string ChooseFile(bool create)
    {
      throw new NotImplementedException();
    }

    public void CleanUp(StartupSaveAction saveAction, int status, bool runLast)
    {
     
    }

    public void ClearErrorConsole()
    {
      
    }

    public void EditFile(string file)
    {
      
    }

    public void FlushConsole()
    {
     
    }

    public SymbolicExpression LoadHistory(Language call, SymbolicExpression operation, Pairlist args, REnvironment environment)
    {
      throw new NotImplementedException();
    }

    public string ReadConsole(string prompt, int capacity, bool history)
    {
      throw new NotImplementedException();
    }

    public void ResetConsole()
    {
      
    }

    public SymbolicExpression SaveHistory(Language call, SymbolicExpression operation, Pairlist args, REnvironment environment)
    {
      throw new NotImplementedException();
    }

    public bool ShowFiles(string[] files, string[] headers, string title, bool delete, string pager)
    {
      throw new NotImplementedException();
    }

    public void ShowMessage(string message)
    {
      throw new NotImplementedException();
    }

    public void Suicide(string message)
    {
      throw new NotImplementedException();
    }
  }
}
