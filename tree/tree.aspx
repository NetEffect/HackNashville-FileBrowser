﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="tree.aspx.cs" Inherits="tree_tree" %>

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

    </script>
  </body>
</html>
