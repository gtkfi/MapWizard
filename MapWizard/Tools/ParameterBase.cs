using System;
using System.Collections.Generic;
using System.IO;
using MapWizard.Tools.Settings;
using Newtonsoft.Json;

namespace MapWizard.Tools
{
  public abstract class ParameterBase
  {
    private Dictionary<string, object> paramDictionary;

    public ParameterBase()
    {
      this.paramDictionary = new Dictionary<string, object>();
    }

    protected Dictionary<string, object> Parameters
    {
      get { return paramDictionary; }
    }

    protected void Add<T>(string key, T value) where T : class
    {
      if (!paramDictionary.ContainsKey(key))
        paramDictionary.Add(key, value);
      else
        paramDictionary[key] = value;
    }

    protected T GetValue<T>(string key) where T : class
    {
      if (paramDictionary.ContainsKey(key))
        return paramDictionary[key] as T;
      else
        return default(T);
    }

    public void Save(string fileName)
    {
      try
      {
        string json = JsonConvert.SerializeObject(paramDictionary, Formatting.Indented);
        File.WriteAllText(fileName, json);
      }
      catch (Exception)
      {
        throw;
      }
      
    }

    public void Load(string fileName)
    {
      try
      {
        var json = File.ReadAllText(fileName);
        paramDictionary = JsonConvert.DeserializeObject<Dictionary<string, object>>(json);
      }
      catch (Exception)
      {
        throw;
      }
    }
  }

  public class ToolResult : ParameterBase
  {
        public ISettingsService Env { get; set; }
        public ToolResult()
        {
            Env = new SettingsService();
        }
    }

  public class ToolParameters : ParameterBase
  {
        public ISettingsService Env { get; set; }
        public ToolParameters()
        {
            Env = new SettingsService();            
        }
  }
}

