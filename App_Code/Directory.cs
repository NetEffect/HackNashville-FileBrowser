using System;
using System.IO;
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
public class Directory : System.Web.Services.WebService
{

    public Directory()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return jsonSerialize("Hello World");
    }

    [Serializable]
    public class GetDirHelper
    {

        public string dir { get; set; }
    }

    [Serializable]
    public class NodeObject
    {
        public string name { get; set; }
        public List<NodeObject> children { get; set; }
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
        DirectoryInfo rootDir = new DirectoryInfo("C:\\dell");
        NodeObject currentNode = new NodeObject();
        currentNode.name = rootDir.Name;
        currentNode.children = new List<NodeObject>();
        currentNode.children.Add(WalkDirectoryTree(rootDir, currentNode));



        return jsonSerialize(currentNode);
    }

    #region Private Methods

    private string jsonSerialize(object o)
    {

        JavaScriptSerializer js = new JavaScriptSerializer();
        return js.Serialize(o);
    }

    private NodeObject WalkDirectoryTree(DirectoryInfo root, NodeObject currentNode)
    {

        currentNode.children = new List<NodeObject>();

        FileInfo[] files = null;
        DirectoryInfo[] subDirs = null;
        // First, process all the files directly under this folder
        try
        {
            files = root.GetFiles("*.*");
        }
        // This is thrown if even one of the files requires permissions greater
        // than the application provides.
        catch (UnauthorizedAccessException e)
        {
            // Console.WriteLine(e.Message);
        }

        catch (System.IO.DirectoryNotFoundException e)
        {
            // Console.WriteLine(e.Message);
        }

        if (files != null)
        {
            foreach (System.IO.FileInfo fi in files)
            {
                // In this example, we only access the existing FileInfo object. If we
                // want to open, delete or modify the file, then
                // a try-catch block is required here to handle the case
                // where the file has been deleted since the call to TraverseTree().
                // Console.WriteLine(fi.Name);
                NodeObject obj = new NodeObject();
                obj.name = fi.Name;

                currentNode.children.Add(obj);


            }

            // Now find all the subdirectories under this directory.
            subDirs = root.GetDirectories();

            foreach (System.IO.DirectoryInfo dirInfo in subDirs)
            {
                // Resursive call for each subdirectory.
                // Console.WriteLine("{0}", dirInfo.Name);
                NodeObject obj = new NodeObject();
                obj.name = dirInfo.Name;
                obj.children = new List<NodeObject>();
                //currentNode.children.Add(obj);
                currentNode.children.Add(WalkDirectoryTree(dirInfo, obj));
                //WalkDirectoryTree(dirInfo, obj);

            }

        }
        return currentNode;
    }

    #endregion
}
