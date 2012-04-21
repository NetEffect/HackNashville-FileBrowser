<%@ Page Language="C#" AutoEventWireup="true" CodeFile="tree.aspx.cs" Inherits="tree_tree" %>

<!doctype html>
<!--[if IEMobile 7 ]><html class="no-js iem7" manifest="/ASC/default.appcache"><![endif]--> 
<!--[if lt IE 7 ]><html class="no-js ie6" lang="en"><![endif]--> 
<!--[if IE 7 ]><html class="no-js ie7" lang="en"><![endif]--> 
<!--[if IE 8 ]><html class="no-js ie8" lang="en"><![endif]--> 
<!--[if (gte IE 9)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!--><html class="no-js" lang="en"><!--<![endif]-->
<html>
<head>
    <meta charset="UTF-8"> 
    <title>Node-Link Tree</title>

    <%--
    Set up global 'App' object - DO THIS FIRST
    --%>
    <script type="text/javascript">
        // Set up globals
        (function (win) {
            win.App = (function () {
                /*@ PRIVATE */

                // Global AppPath variable - resolves and normalizes the current App/Virtual path
                var _appPath = '<%= Page.ResolveUrl("~/").TrimEnd('/') %>';

                /*@ PUBLIC */
                return {
                    AppPath: _appPath
                };
            })();
        })(window);
    </script>

    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
    <script type="text/javascript" src='<%= Page.ResolveUrl("~/d3/d3.v2.js") %>'></script>
    <script type="text/javascript" src='<%= Page.ResolveUrl("~/js/plugins.js") %>'></script>
    <script type="text/javascript" src='<%= Page.ResolveUrl("~/js/app_utils.js") %>'></script>
    <script type="text/javascript" src='<%= Page.ResolveUrl("~/js/app_main.js") %>'></script>

    <link type="text/css" rel="stylesheet" href="<%= Page.ResolveUrl("~/css/main.css") %>" />
</head>

<body>
    <div id="chart">Loading...</div>
</body>
</html>
