using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Linq;

/// <summary>
/// Summary description for Directory
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
 [System.Web.Script.Services.ScriptService]
public class Directory : System.Web.Services.WebService {

    public Directory () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return jsonSerialize("Hello World");
    }

    [Serializable]
    public class GetDirHelper {

        public string dir { get; set; }
    }

    [Serializable]
    public class NodeObject
    {
        public string name { get; set; }
        public List<NodeObject> children {get;set;}
    }

    [WebMethod]
    public string GetDir(GetDirHelper data)
    {
        /*  this should be the return structure
{
 "name": "flare",
 "children": [
  {
   "name": "analytics",
   "children": []
   },
   {
   "name": "analytics",
   "children": []
   }
  ]
}
      
         */

        List<NodeObject> childAr = new List<NodeObject>();
        object retObj = new NodeObject{ 
            name = "rootDir",
            children = childAr
        };

        return jsonSerialize(data);
    }

    #region Private Methods

    private string jsonSerialize(object o)
    {
        
        JavaScriptSerializer js = new JavaScriptSerializer();
        return js.Serialize(o);
    }

    #endregion
}
