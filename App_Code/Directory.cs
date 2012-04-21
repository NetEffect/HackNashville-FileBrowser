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




    #region Private Methods

    private string jsonSerialize(object o)
    {
        
        JavaScriptSerializer js = new JavaScriptSerializer();
        return js.Serialize(o);
    }

    #endregion
}
