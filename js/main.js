$(function(){

// Bar Chart
var graph = new Rickshaw.Graph( {
  element: document.querySelector("#chart1"),
  renderer: 'bar',
  series: [{
    name: 'Football',
    data: [ { x: 0, y: 14 }, { x: 1, y: 15 }, { x: 2, y: 12 }, { x: 3, y: 11 } ],
    color: 'steelblue'
  }, {
    name: 'Non-Football',
    data: [ { x: 0, y: 140 }, { x: 1, y: 145 }, { x: 2, y: 120 }, { x: 3, y: 150 } ],
    color: '#a1003e'
  }]
});

graph.renderer.unstack = true;
graph.render();

var legend = new Rickshaw.Graph.Legend({
    graph: graph,
    element: document.querySelector('#legend')
});

var shelving = new Rickshaw.Graph.Behavior.Series.Toggle({
    graph: graph,
    legend: legend
});

var highlighter = new Rickshaw.Graph.Behavior.Series.Highlight({
    graph: graph,
    legend: legend
});

var xAxis = new Rickshaw.Graph.Axis.Time({
    graph: graph,
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT
});

// xAxis.render();

var yAxis = new Rickshaw.Graph.Axis.Y({
    graph: graph,
    orientation: 'left',
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT
});

yAxis.render();

// Line Chart
var graph2 = new Rickshaw.Graph({
        element: document.querySelector("#chart2"),
        renderer: 'line',
        series: [{
          data: [
          { x: 0, y: 10 }, { x: 1, y: 20 }, { x: 2, y: 38 }, { x: 3, y: 30 }, { x: 4, y: 32 }, { x: 5, y: 30 }, { x: 6, y: 15 },
          { x: 7, y: 25 }, { x: 8, y: 49 }, { x: 9, y: 38 }, { x: 10, y: 30 }, { x: 11, y: 32 }, { x: 12, y: 20 }, { x: 13, y: 30 }
           ],
          color: '#4682b4'
        }]
});

graph2.render();

var xAxis2 = new Rickshaw.Graph.Axis.Time({
    graph: graph2,
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT
});

xAxis2.render();

});
