using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapWizard.Tools
{
  interface ITool
  {
    ToolResult Execute(ToolParameters inputParams);
        //Name
        //ID
        //vaan getti ja internal set
        //työkalun konstruktorissa sitten asetetaan Name ja ID
        //
  }
}
