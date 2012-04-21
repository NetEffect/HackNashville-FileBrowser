<%@ Page Language="C#" AutoEventWireup="true" CodeFile="tree.aspx.cs" Inherits="tree_tree" %>

<!--
/webservices/tree_ws.asmx/GetDirectory
parms:
currentDir
-->


<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <title>Node-Link Tree</title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
    <script type="text/javascript" src='<%= Page.ResolveUrl("~/d3/d3.v2.js") %>'></script>
    <style type="text/css">

.node circle {
  cursor: pointer;
  fill: #fff;
  stroke: steelblue;
  stroke-width: 1.5px;
}

.node text {
  font: 10px sans-serif;
}

path.link {
  fill: none;
  stroke: #ccc;
  stroke-width: 1.5px;
}

    </style>
  </head>
  <body>
    <div id="chart"></div>
    <script type="text/javascript">

        //call webservice method
        var call_ws = function (dir) {
            if (typeof (dir) === 'undefined') {
                dir = "/";
            }

            var dataOut = {
                "dir": dir
            };

            var $ = jQuery;
            dataOut = $.toJSON({ data: dataOut });

            //call web service
            var request = $.ajax({
                url: '<%= Page.ResolveUrl("~/Directory.asmx/GetDir") %>',
                contentType: "application/json; charset=utf-8",
                type: "POST",
                data: dataOut,
                dataType: "json",
                success: function (data) {

                    var thisData = $.parseJSON(data.d);
                    $.log("thisData");
                    $.log(thisData);

                }
            });

        };


        $(function () {

            //sample call web service
            call_ws();
            var margin = { top: 20, right: 120, bottom: 20, left: 120 },
    width = 1280 - margin.right - margin.left,
    height = 800 - margin.top - margin.bottom,
    i = 0,
    duration = 500,
    root;

            var tree = d3.layout.tree()
    .size([height, width]);

            var diagonal = d3.svg.diagonal()
    .projection(function (d) { return [d.y, d.x]; });

            var vis = d3.select("#chart").append("svg")
    .attr("width", width + margin.right + margin.left)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

            d3.json('<%= Page.ResolveUrl("~/d3/examples/data/flare.json") %>', function (json) {
                root = json;
                root.x0 = height / 2;
                root.y0 = 0;

                function collapse(d) {
                    if (d.children) {
                        d._children = d.children;
                        d._children.forEach(collapse);
                        d.children = null;
                    }
                }

                root.children.forEach(collapse);
                update(root);
            });

            function update(source) {

                // Compute the new tree layout.
                var nodes = tree.nodes(root).reverse();

                // Normalize for fixed-depth.
                nodes.forEach(function (d) { d.y = d.depth * 180; });

                // Update the nodes…
                var node = vis.selectAll("g.node")
      .data(nodes, function (d) { return d.id || (d.id = ++i); });

                // Enter any new nodes at the parent's previous position.
                var nodeEnter = node.enter().append("g")
      .attr("class", "node")
      .attr("transform", function (d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
      .on("click", click);

                nodeEnter.append("circle")
      .attr("r", 1e-6)
      .style("fill", function (d) { return d._children ? "lightsteelblue" : "#fff"; });

                nodeEnter.append("text")
      .attr("x", function (d) { return d.children || d._children ? -10 : 10; })
      .attr("dy", ".35em")
      .attr("text-anchor", function (d) { return d.children || d._children ? "end" : "start"; })
      .text(function (d) { return d.name; })
      .style("fill-opacity", 1e-6);

                // Transition nodes to their new position.
                var nodeUpdate = node.transition()
      .duration(duration)
      .attr("transform", function (d) { return "translate(" + d.y + "," + d.x + ")"; });

                nodeUpdate.select("circle")
      .attr("r", 4.5)
      .style("fill", function (d) { return d._children ? "lightsteelblue" : "#fff"; });

                nodeUpdate.select("text")
      .style("fill-opacity", 1);

                // Transition exiting nodes to the parent's new position.
                var nodeExit = node.exit().transition()
      .duration(duration)
      .attr("transform", function (d) { return "translate(" + source.y + "," + source.x + ")"; })
      .remove();

                nodeExit.select("circle")
      .attr("r", 1e-6);

                nodeExit.select("text")
      .style("fill-opacity", 1e-6);

                // Update the links…
                var link = vis.selectAll("path.link")
      .data(tree.links(nodes), function (d) { return d.target.id; });

                // Enter any new links at the parent's previous position.
                link.enter().insert("path", "g")
      .attr("class", "link")
      .attr("d", function (d) {
          var o = { x: source.x0, y: source.y0 };
          return diagonal({ source: o, target: o });
      });

                // Transition links to their new position.
                link.transition()
      .duration(duration)
      .attr("d", diagonal);

                // Transition exiting nodes to the parent's new position.
                link.exit().transition()
      .duration(duration)
      .attr("d", function (d) {
          var o = { x: source.x, y: source.y };
          return diagonal({ source: o, target: o });
      })
      .remove();

                // Stash the old positions for transition.
                nodes.forEach(function (d) {
                    d.x0 = d.x;
                    d.y0 = d.y;
                });
            }

            // Toggle children on click.
            function click(d) {
                if (d.children) {
                    d._children = d.children;
                    d.children = null;
                } else {
                    d.children = d._children;
                    d._children = null;
                }
                update(d);
            }
        });

        /**
        * Copyright (C) 2009 Jonathan Azoff <jon@azoffdesign.com>
        * jQuery.log v1.0.0 - A jQuery plugin that unifies native console logging across browsers
        */
        (function (a) { a.extend({ log: function () { if (arguments.length > 0) { var b = (arguments.length > 1) ? Array.prototype.join.call(arguments, " ") : arguments[0]; try { console.log(b); return true } catch (c) { try { opera.postError(b); return true } catch (c) { } } return false } } }) })(jQuery);


        /* JQUERY JSON */
        (function ($) {
            var escapeable = /["\\\x00-\x1f\x7f-\x9f]/g, meta = { '\b': '\\b', '\t': '\\t', '\n': '\\n', '\f': '\\f', '\r': '\\r', '"': '\\"', '\\': '\\\\' }; $.toJSON = typeof JSON === 'object' && JSON.stringify ? JSON.stringify : function (o) {
                if (o === null) { return 'null'; }
                var type = typeof o; if (type === 'undefined') { return undefined; }
                if (type === 'number' || type === 'boolean') { return '' + o; }
                if (type === 'string') { return $.quoteString(o); }
                if (type === 'object') {
                    if (typeof o.toJSON === 'function') { return $.toJSON(o.toJSON()); }
                    if (o.constructor === Date) {
                        var month = o.getUTCMonth() + 1, day = o.getUTCDate(), year = o.getUTCFullYear(), hours = o.getUTCHours(), minutes = o.getUTCMinutes(), seconds = o.getUTCSeconds(), milli = o.getUTCMilliseconds(); if (month < 10) { month = '0' + month; }
                        if (day < 10) { day = '0' + day; }
                        if (hours < 10) { hours = '0' + hours; }
                        if (minutes < 10) { minutes = '0' + minutes; }
                        if (seconds < 10) { seconds = '0' + seconds; }
                        if (milli < 100) { milli = '0' + milli; }
                        if (milli < 10) { milli = '0' + milli; }
                        return '"' + year + '-' + month + '-' + day + 'T' +
hours + ':' + minutes + ':' + seconds + '.' + milli + 'Z"';
                    }
                    if (o.constructor === Array) {
                        var ret = []; for (var i = 0; i < o.length; i++) { ret.push($.toJSON(o[i]) || 'null'); }
                        return '[' + ret.join(',') + ']';
                    }
                    var name, val, pairs = []; for (var k in o) {
                        type = typeof k; if (type === 'number') { name = '"' + k + '"'; } else if (type === 'string') { name = $.quoteString(k); } else { continue; }
                        type = typeof o[k]; if (type === 'function' || type === 'undefined') { continue; }
                        val = $.toJSON(o[k]); pairs.push(name + ':' + val);
                    }
                    return '{' + pairs.join(',') + '}';
                } 
            }; $.evalJSON = typeof JSON === 'object' && JSON.parse ? JSON.parse : function (src) { return eval('(' + src + ')'); }; $.secureEvalJSON = typeof JSON === 'object' && JSON.parse ? JSON.parse : function (src) { var filtered = src.replace(/\\["\\\/bfnrtu]/g, '@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']').replace(/(?:^|:|,)(?:\s*\[)+/g, ''); if (/^[\],:{}\s]*$/.test(filtered)) { return eval('(' + src + ')'); } else { throw new SyntaxError('Error parsing JSON, source is not valid.'); } }; $.quoteString = function (string) {
                if (string.match(escapeable)) {
                    return '"' + string.replace(escapeable, function (a) {
                        var c = meta[a]; if (typeof c === 'string') { return c; }
                        c = a.charCodeAt(); return '\\u00' + Math.floor(c / 16).toString(16) + (c % 16).toString(16);
                    }) + '"';
                }
                return '"' + string + '"';
            };
        })(jQuery);

    </script>
  </body>
</html>
