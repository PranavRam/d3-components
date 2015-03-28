(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var barcodeChart;

barcodeChart = function() {
  var chart, height, margin, svgInit, timeInterval, value, width;
  width = 400;
  height = 30;
  margin = {
    top: 5,
    right: 5,
    bottom: 5,
    left: 5
  };
  value = function(d) {
    return d.date;
  };
  timeInterval = d3.time.day;
  svgInit = function(svg) {
    var g;
    svg.attr({
      width: width,
      height: height
    });
    g = svg.append('g').attr({
      'class': 'chart-content',
      transform: "translate(" + margin.top + "," + margin.left + ")"
    });
    return g.append('rect').attr({
      width: width - margin.left - margin.right,
      height: height - margin.top - margin.bottom,
      fill: 'white'
    });
  };
  chart = function(selection) {
    return selection.each(function(data) {
      var bars, div, firstDate, g, lastDate, lines, svg, svgEnter, xScale;
      div = d3.select(this).attr('class', 'data-item');
      svg = div.selectAll('svg').data([data]);
      svgEnter = svg.enter();
      svgEnter.append('svg').call(svgInit);
      g = svg.select('g.chart-content');
      lines = g.selectAll('line');
      lastDate = d3.max(data, value);
      lastDate = lines.empty() ? lastDate : d3.max(lines.data(), value);
      firstDate = timeInterval.offset(lastDate, -1);
      xScale = d3.time.scale().domain([firstDate, lastDate]).range([0, width - margin.left - margin.right]);
      bars = g.selectAll('line').data(data, value);
      bars.enter().append('line').attr({
        x1: function(d) {
          return xScale(value(d));
        },
        x2: function(d) {
          return xScale(value(d));
        },
        y1: 0,
        y2: height - margin.top - margin.bottom,
        stroke: '#000',
        'stroke-opacity': 0.5
      });
      lastDate = d3.max(data, value);
      firstDate = timeInterval.offset(lastDate, -1);
      xScale.domain([firstDate, lastDate]);
      bars.transition().duration(300).attr({
        x1: function(d) {
          return xScale(value(d));
        },
        x2: function(d) {
          return xScale(value(d));
        }
      });
      return bars.exit().transition().duration(300).attr({
        'stroke-opacity': 0
      }).remove();
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.value = function(accessorFunction) {
    if (!arguments.length) {
      return value;
    }
    value = accessorFunction;
    return chart;
  };
  chart.timeInterval = function(value) {
    if (!arguments.length) {
      return timeInterval;
    }
    timeInterval = value;
    return chart;
  };
  return chart;
};

module.exports = barcodeChart;

},{}]},{},[1]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var bubbleChart;

bubbleChart = function() {
  var cScale, charge, chart, height, name, radiusExtent, usage, width;
  width = 700;
  height = 400;
  radiusExtent = [10, 50];
  cScale = d3.scale.category10();
  name = function(d) {
    return d.name;
  };
  usage = function(d) {
    return d.usage;
  };
  charge = function(d) {
    return -0.12 * d.r * d.r;
  };
  chart = function(selection) {
    return selection.each(function(data) {
      var bubbleDivs, containerDiv, force, items, nameList, rScale, uniqueList;
      containerDiv = d3.select(this).style({
        position: 'relative',
        width: width + 'px',
        height: height + 'px',
        padding: 0,
        'background-color': '#eeeeec'
      });
      items = data;
      nameList = items.map(name);
      uniqueList = d3.set(nameList).values();
      cScale.domain(uniqueList);
      rScale = d3.scale.sqrt().domain(d3.extent(items, usage)).range(radiusExtent);
      items.sort(function(a, b) {
        return usage(b) - usage(a);
      });
      items.forEach(function(d) {
        return d.r = rScale(usage(d));
      });
      force = d3.layout.force().nodes(items).links([]).size([width, height]).charge(charge).start();
      bubbleDivs = containerDiv.selectAll('div.bubble').data(items).enter().append('div').attr('class', 'bubble').style({
        position: 'absolute',
        width: function(d) {
          return (2 * d.r) + 'px';
        },
        height: function(d) {
          return (2 * d.r) + 'px';
        },
        'border-radius': function(d) {
          return d.r + 'px';
        },
        'background-color': function(d) {
          return cScale(name(d));
        }
      });
      return force.on('tick', function() {
        return bubbleDivs.style({
          top: function(d) {
            return (d.y - d.r) + 'px';
          },
          left: function(d) {
            return (d.x - d.r) + 'px';
          }
        });
      });
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.radiusExtent = function(value) {
    if (!arguments.length) {
      return radiusExtent;
    }
    radiusExtent = value;
    return chart;
  };
  chart.name = function(accessorFunction) {
    if (!arguments.length) {
      return name;
    }
    name = accessorFunction;
    return chart;
  };
  chart.usage = function(accessorFunction) {
    if (!arguments.length) {
      return usage;
    }
    usage = accessorFunction;
    return chart;
  };
  chart.charge = function(accessorFunction) {
    if (!arguments.length) {
      return charge;
    }
    charge = accessorFunction;
    return chart;
  };
  chart.colorScale = function(accessorFunction) {
    if (!arguments.length) {
      return cScale;
    }
    cScale = accessorFunction;
    return chart;
  };
  return chart;
};

module.exports = bubbleChart;

},{}]},{},[1]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var evidenceBox;

evidenceBox = function() {
  var chart, drag, evidences, headingButtons, height, hideBody, label, number, setupInteract, title, width;
  width = 250;
  height = 300;
  number = 0;
  title = 'Evidence 1 (110203.txt)';
  evidences = [
    {
      name: 'Anand',
      type: 'label-success'
    }, {
      name: 'GT',
      type: 'label-info'
    }, {
      name: '2011',
      type: 'label-warning'
    }
  ];
  headingButtons = {
    chevron: null,
    label: null
  };
  label = 4;
  hideBody = false;
  drag = true;
  setupInteract = function() {
    return interact('.draggable').draggable({
      inertia: true,
      restrict: {
        restriction: 'parent',
        endOnly: true,
        elementRect: {
          top: 0,
          left: 0,
          bottom: 1,
          right: 1
        }
      },
      onmove: function(event) {
        var target, x, y;
        target = event.target;
        x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
        y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;
        target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)';
        target.setAttribute('data-x', x);
        return target.setAttribute('data-y', y);
      },
      onend: function(event) {
        var textEl;
        textEl = event.target.querySelector('p');
        return textEl && (textEl.textContent = 'moved a distance of ' + (Math.sqrt(event.dx * event.dx + event.dy * event.dy) | 0) + 'px');
      }
    }).allowFrom('.panel-heading');
  };
  chart = function(selection) {
    return selection.each(function(data) {
      var body, div, evidenceDivs, heading;
      div = d3.select(this).attr('class', 'panel panel-primary draggable', {
        'data-box-type': 'evidence',
        'data-box-number': number
      });
      div.style({
        width: width + 'px'
      });
      heading = div.append('div').attr('class', 'panel-heading');
      heading.text(title);
      body = div.append('div').attr('class', 'panel-body dropzone');
      evidenceDivs = body.selectAll('span').data(evidences);
      evidenceDivs.enter().append('div').style('margin', '5px 0').append('span').attr('class', function(d, i) {
        return "label " + d.type;
      }).text(function(d) {
        return d.name;
      }).style({
        margin: '5px'
      });
      headingButtons.chevron = heading.append('i').attr('class', 'fa fa-chevron-up pull-right').style({
        'margin-top': '2px'
      }).on('click', function(d) {
        if (!hideBody) {
          body.style({
            display: 'none',
            visibility: 'hidden'
          });
          div.style('height', '43px');
          d3.select(this).attr('class', 'fa fa-chevron-down pull-right');
          return hideBody = true;
        } else {
          body.style({
            display: 'block',
            visibility: 'visible'
          });
          div.style('height', 'auto');
          d3.select(this).attr('class', 'fa fa-chevron-up pull-right');
          return hideBody = false;
        }
      });
      headingButtons.label = heading.append('span').attr('class', 'label label-danger pull-right').style({
        'margin-top': '2px'
      }).text(label);
      if (drag) {
        return setupInteract();
      }
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.title = function(value) {
    if (!arguments.length) {
      return title;
    }
    title = value;
    return chart;
  };
  chart.evidences = function(value) {
    if (!arguments.length) {
      return evidences;
    }
    evidences = value;
    return chart;
  };
  chart.label = function(value) {
    if (!arguments.length) {
      return label;
    }
    label = value;
    return chart;
  };
  chart.number = function(value) {
    if (!arguments.length) {
      return number;
    }
    number = value;
    return chart;
  };
  return chart;
};

module.exports = evidenceBox;

},{}]},{},[1]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var hypothesisBox, pnnBox;

pnnBox = require('./pnnBox');

hypothesisBox = function() {
  var chart, drag, headingButtons, height, hideBody, hypothesis, label, number, setupInteract, title, width;
  width = 600;
  height = 400;
  number = 0;
  title = 'Anand Framed Roger Rabbit';
  hypothesis = {
    positive: {
      data: ["Evidence 1", "Evidence 2"]
    },
    negative: {
      data: ["Evidence 3", "Evidence 4"]
    },
    neutral: {
      data: ["Evidence 5", "Evidence 6"]
    }
  };
  headingButtons = {
    chevron: null,
    label: null,
    settings: null,
    lineChart: null
  };
  label = 5;
  hideBody = false;
  drag = true;
  setupInteract = function() {
    return interact('.draggable').draggable({
      inertia: true,
      restrict: {
        restriction: 'parent',
        endOnly: true,
        elementRect: {
          top: 0,
          left: 0,
          bottom: 1,
          right: 1
        }
      },
      onmove: function(event) {
        var target, x, y;
        target = event.target;
        x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
        y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;
        target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)';
        target.setAttribute('data-x', x);
        return target.setAttribute('data-y', y);
      },
      onend: function(event) {
        var textEl;
        textEl = event.target.querySelector('p');
        return textEl && (textEl.textContent = 'moved a distance of ' + (Math.sqrt(event.dx * event.dx + event.dy * event.dy) | 0) + 'px');
      }
    }).allowFrom('.panel-heading');
  };
  chart = function(selection) {
    return selection.each(function(data) {
      var body, div, heading, negativeBox, negativeDiv, neutralBox, neutralDiv, positiveBox, positiveDiv;
      div = d3.select(this).attr('class', 'panel panel-dark draggable', {
        'data-box-type': 'hypothesis',
        'data-box-number': number
      });
      div.style({
        width: width + 'px'
      });
      heading = div.append('div').attr('class', 'panel-heading');
      heading.text(title);
      body = div.append('div').attr('class', 'panel-body');
      positiveBox = pnnBox().title('Positive').titleClass('panel-info').width(width / 2 - 25);
      negativeBox = pnnBox().title('Negative').titleClass('panel-danger left-15').width(width / 2 - 25);
      neutralBox = pnnBox().title('Neutral').titleClass('panel-warning').width(width - 35);
      positiveDiv = body.append('div').data([hypothesis.positive.data]).call(positiveBox);
      negativeDiv = body.append('div').data([hypothesis.negative.data]).call(negativeBox);
      neutralDiv = body.append('div').data([hypothesis.neutral.data]).call(neutralBox);
      headingButtons.chevron = heading.append('i').attr('class', 'fa fa-chevron-up pull-right').style({
        'margin-top': '2px'
      }).on('click', function(d) {
        if (!hideBody) {
          body.style({
            display: 'none',
            visibility: 'hidden'
          });
          div.style('height', '43px');
          d3.select(this).attr('class', 'fa fa-chevron-down pull-right');
          return hideBody = true;
        } else {
          body.style({
            display: 'block',
            visibility: 'visible'
          });
          div.style('height', 'auto');
          d3.select(this).attr('class', 'fa fa-chevron-up pull-right');
          return hideBody = false;
        }
      });
      headingButtons.settings = heading.append('i').attr('class', 'fa fa-cog pull-right').style({
        'margin': '2px 5px'
      });
      headingButtons.lineChart = heading.append('i').attr('class', 'fa fa-line-chart pull-right').style({
        'margin': '2px 5px'
      });
      headingButtons.label = heading.append('span').attr('class', 'label label-danger pull-right').style({
        'margin': '2px 5px'
      }).text(label);
      if (drag) {
        return setupInteract();
      }
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.title = function(value) {
    if (!arguments.length) {
      return title;
    }
    title = value;
    return chart;
  };
  chart.evidences = function(value) {
    var evidences;
    if (!arguments.length) {
      return evidences;
    }
    evidences = value;
    return chart;
  };
  chart.label = function(value) {
    if (!arguments.length) {
      return label;
    }
    label = value;
    return chart;
  };
  chart.number = function(value) {
    if (!arguments.length) {
      return number;
    }
    number = value;
    return chart;
  };
  return chart;
};

module.exports = hypothesisBox;

},{"./pnnBox":2}],2:[function(require,module,exports){
var pnnBox;

pnnBox = function() {
  var chart, drag, evidences, headingButtons, height, label, setupInteract, title, titleClass, width;
  width = 200;
  height = 200;
  title = 'Positive';
  titleClass = 'panel-info';
  evidences = [
    {
      name: 'Anand',
      type: 'label-success'
    }, {
      name: 'GT',
      type: 'label-info'
    }, {
      name: '2011',
      type: 'label-warning'
    }
  ];
  headingButtons = {
    chevron: null,
    label: null,
    settings: null,
    lineChart: null
  };
  label = 5;
  drag = true;
  setupInteract = function() {
    return interact('.draggable').draggable({
      inertia: true,
      restrict: {
        restriction: 'parent',
        endOnly: true,
        elementRect: {
          top: 0,
          left: 0,
          bottom: 1,
          right: 1
        }
      },
      onmove: function(event) {
        var target, x, y;
        target = event.target;
        x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
        y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;
        target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)';
        target.setAttribute('data-x', x);
        return target.setAttribute('data-y', y);
      },
      onend: function(event) {
        var textEl;
        textEl = event.target.querySelector('p');
        return textEl && (textEl.textContent = 'moved a distance of ' + (Math.sqrt(event.dx * event.dx + event.dy * event.dy) | 0) + 'px');
      }
    }).allowFrom('.panel-heading');
  };
  chart = function(selection) {
    return selection.each(function(data) {
      var body, div, heading;
      console.log(data);
      div = d3.select(this).attr('class', function(d) {
        return "pnn panel " + titleClass + " dropzone";
      }, {
        'data-box-type': 'pnn'
      });
      div.style({
        'min-width': width + 'px'
      });
      heading = div.append('div').attr('class', 'panel-heading');
      heading.text(title);
      body = div.append('div').attr('class', 'panel-body dropzone');
      evidences = body.selectAll('div').data(data).enter().append('div').text(function(d) {
        return d;
      }).style({
        margin: '5px 0'
      });
      evidences.append('i').attr('class', 'fa fa-trash pull-right').style({
        'margin-top': '2px'
      }).on('click', function(d, i) {
        data.splice(i, 1);
        evidences = body.selectAll('div').data(data).exit().remove();
        return evidences.data(data).text(function(d) {
          return d;
        }).style({
          margin: '5px 0'
        });
      });
      return headingButtons.label = heading.append('span').attr('class', 'label label-default pull-right').style({
        'margin': '2px 5px'
      }).text(label);
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.title = function(value) {
    if (!arguments.length) {
      return title;
    }
    title = value;
    return chart;
  };
  chart.evidences = function(value) {
    if (!arguments.length) {
      return evidences;
    }
    evidences = value;
    return chart;
  };
  chart.label = function(value) {
    if (!arguments.length) {
      return label;
    }
    label = value;
    return chart;
  };
  chart.titleClass = function(value) {
    if (!arguments.length) {
      return titleClass;
    }
    titleClass = value;
    return chart;
  };
  return chart;
};

module.exports = pnnBox;

},{}]},{},[1]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var labColorPicker;

labColorPicker = function() {
  var chart, color, height, width;
  width = 30;
  height = 10;
  color = d3.lab(100, 0, 0);
  chart = function(selection) {
    return selection.each(function(data) {
      var group, onClick, rect;
      group = d3.select(this);
      rect = group.selectAll('rect');
      onClick = function(d) {
        var div;
        div = d3.select('body').selectAll('div.color-picker').data([d]);
        if (div.empty()) {
          return div.enter().append('div').attr('class', 'color-picker').style({
            position: 'absolute',
            width: '200px',
            height: '100px',
            border: 'solid 1px #555',
            left: (d3.event.pageX + width) + 'px',
            top: d3.event.pageY + 'px',
            'background-color': '#eee'
          });
        } else {
          return d3.select('body').selectAll('div.color-picker').remove();
        }
      };
      return rect.data([chart.color()]).enter().append('rect').attr({
        width: width,
        height: height,
        fill: function(d) {
          return d;
        },
        stroke: '#222',
        'stroke-width': 1
      }).on('click', onClick);
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.color = function(value) {
    if (!arguments.length) {
      return color;
    }
    color = d3.lab(value);
    return chart;
  };
  return chart;
};

module.exports = labColorPicker;

},{}]},{},[1]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

},{}]},{},[1]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var legendChart;

legendChart = function() {
  var cScale, chart, key, label, width;
  width = 200;
  cScale = d3.scale.category20();
  key = function(d) {
    return d.name;
  };
  label = function(d) {
    return d.name;
  };
  chart = function(selection) {
    return selection.each(function(data) {
      var containerDiv, itemDiv, itemP;
      containerDiv = d3.select(this).style({
        width: width + 'px'
      });
      containerDiv.selectAll('p.legend-title').data([data]).enter().append('p').attr('class', 'legend-title').text('Legend');
      itemDiv = containerDiv.selectAll('div.item').data(data).enter().append('div').attr('class', 'item');
      itemP = itemDiv.append('p').style({
        'line-height': '0.8em',
        'font-size': '11px'
      });
      itemP.append('span').text('..').style({
        color: function(d) {
          return cScale(d.name);
        },
        background: function(d) {
          return cScale(d.name);
        }
      });
      return itemP.append('text').text(label);
    });
  };
  chart.colorScale = function(value) {
    if (!arguments.length) {
      return cScale;
    }
    cScale = value;
    return chart;
  };
  return chart;
};

module.exports = legendChart;

},{}]},{},[1]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var evidenceBox;

evidenceBox = function() {
  var chart, drag, evidences, headingButtons, height, hideBody, label, number, setupInteract, title, width;
  width = 250;
  height = 300;
  number = 0;
  title = 'Evidence 1 (110203.txt)';
  evidences = [
    {
      name: 'Anand',
      type: 'label-success'
    }, {
      name: 'GT',
      type: 'label-info'
    }, {
      name: '2011',
      type: 'label-warning'
    }
  ];
  headingButtons = {
    chevron: null,
    label: null
  };
  label = 4;
  hideBody = false;
  drag = true;
  setupInteract = function() {
    return interact('.draggable').draggable({
      inertia: true,
      restrict: {
        restriction: 'parent',
        endOnly: true,
        elementRect: {
          top: 0,
          left: 0,
          bottom: 1,
          right: 1
        }
      },
      onmove: function(event) {
        var target, x, y;
        target = event.target;
        x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
        y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;
        target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)';
        target.setAttribute('data-x', x);
        return target.setAttribute('data-y', y);
      },
      onend: function(event) {
        var textEl;
        textEl = event.target.querySelector('p');
        return textEl && (textEl.textContent = 'moved a distance of ' + (Math.sqrt(event.dx * event.dx + event.dy * event.dy) | 0) + 'px');
      }
    }).allowFrom('.panel-heading');
  };
  chart = function(selection) {
    return selection.each(function(data) {
      var body, div, evidenceDivs, heading;
      div = d3.select(this).attr('class', 'panel panel-primary draggable', {
        'data-box-type': 'evidence',
        'data-box-number': number
      });
      div.style({
        width: width + 'px'
      });
      heading = div.append('div').attr('class', 'panel-heading');
      heading.text(title);
      body = div.append('div').attr('class', 'panel-body dropzone');
      evidenceDivs = body.selectAll('span').data(evidences);
      evidenceDivs.enter().append('div').style('margin', '5px 0').append('span').attr('class', function(d, i) {
        return "label " + d.type;
      }).text(function(d) {
        return d.name;
      }).style({
        margin: '5px'
      });
      headingButtons.chevron = heading.append('i').attr('class', 'fa fa-chevron-up pull-right').style({
        'margin-top': '2px'
      }).on('click', function(d) {
        if (!hideBody) {
          body.style({
            display: 'none',
            visibility: 'hidden'
          });
          div.style('height', '43px');
          d3.select(this).attr('class', 'fa fa-chevron-down pull-right');
          return hideBody = true;
        } else {
          body.style({
            display: 'block',
            visibility: 'visible'
          });
          div.style('height', 'auto');
          d3.select(this).attr('class', 'fa fa-chevron-up pull-right');
          return hideBody = false;
        }
      });
      headingButtons.label = heading.append('span').attr('class', 'label label-danger pull-right').style({
        'margin-top': '2px'
      }).text(label);
      if (drag) {
        return setupInteract();
      }
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.title = function(value) {
    if (!arguments.length) {
      return title;
    }
    title = value;
    return chart;
  };
  chart.evidences = function(value) {
    if (!arguments.length) {
      return evidences;
    }
    evidences = value;
    return chart;
  };
  chart.label = function(value) {
    if (!arguments.length) {
      return label;
    }
    label = value;
    return chart;
  };
  chart.number = function(value) {
    if (!arguments.length) {
      return number;
    }
    number = value;
    return chart;
  };
  return chart;
};

module.exports = evidenceBox;

},{}],2:[function(require,module,exports){
var hypothesisBox, pnnBox;

pnnBox = require('./pnnBox');

hypothesisBox = function() {
  var chart, drag, headingButtons, height, hideBody, hypothesis, label, number, setupInteract, title, width;
  width = 600;
  height = 400;
  number = 0;
  title = 'Anand Framed Roger Rabbit';
  hypothesis = {
    positive: {
      data: ["Evidence 1", "Evidence 2"]
    },
    negative: {
      data: ["Evidence 3", "Evidence 4"]
    },
    neutral: {
      data: ["Evidence 5", "Evidence 6"]
    }
  };
  headingButtons = {
    chevron: null,
    label: null,
    settings: null,
    lineChart: null
  };
  label = 5;
  hideBody = false;
  drag = true;
  setupInteract = function() {
    return interact('.draggable').draggable({
      inertia: true,
      restrict: {
        restriction: 'parent',
        endOnly: true,
        elementRect: {
          top: 0,
          left: 0,
          bottom: 1,
          right: 1
        }
      },
      onmove: function(event) {
        var target, x, y;
        target = event.target;
        x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
        y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;
        target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)';
        target.setAttribute('data-x', x);
        return target.setAttribute('data-y', y);
      },
      onend: function(event) {
        var textEl;
        textEl = event.target.querySelector('p');
        return textEl && (textEl.textContent = 'moved a distance of ' + (Math.sqrt(event.dx * event.dx + event.dy * event.dy) | 0) + 'px');
      }
    }).allowFrom('.panel-heading');
  };
  chart = function(selection) {
    return selection.each(function(data) {
      var body, div, heading, negativeBox, negativeDiv, neutralBox, neutralDiv, positiveBox, positiveDiv;
      div = d3.select(this).attr('class', 'panel panel-dark draggable', {
        'data-box-type': 'hypothesis',
        'data-box-number': number
      });
      div.style({
        width: width + 'px'
      });
      heading = div.append('div').attr('class', 'panel-heading');
      heading.text(title);
      body = div.append('div').attr('class', 'panel-body');
      positiveBox = pnnBox().title('Positive').titleClass('panel-info').width(width / 2 - 25);
      negativeBox = pnnBox().title('Negative').titleClass('panel-danger left-15').width(width / 2 - 25);
      neutralBox = pnnBox().title('Neutral').titleClass('panel-warning').width(width - 35);
      positiveDiv = body.append('div').data([hypothesis.positive.data]).call(positiveBox);
      negativeDiv = body.append('div').data([hypothesis.negative.data]).call(negativeBox);
      neutralDiv = body.append('div').data([hypothesis.neutral.data]).call(neutralBox);
      headingButtons.chevron = heading.append('i').attr('class', 'fa fa-chevron-up pull-right').style({
        'margin-top': '2px'
      }).on('click', function(d) {
        if (!hideBody) {
          body.style({
            display: 'none',
            visibility: 'hidden'
          });
          div.style('height', '43px');
          d3.select(this).attr('class', 'fa fa-chevron-down pull-right');
          return hideBody = true;
        } else {
          body.style({
            display: 'block',
            visibility: 'visible'
          });
          div.style('height', 'auto');
          d3.select(this).attr('class', 'fa fa-chevron-up pull-right');
          return hideBody = false;
        }
      });
      headingButtons.settings = heading.append('i').attr('class', 'fa fa-cog pull-right').style({
        'margin': '2px 5px'
      });
      headingButtons.lineChart = heading.append('i').attr('class', 'fa fa-line-chart pull-right').style({
        'margin': '2px 5px'
      });
      headingButtons.label = heading.append('span').attr('class', 'label label-danger pull-right').style({
        'margin': '2px 5px'
      }).text(label);
      if (drag) {
        return setupInteract();
      }
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.title = function(value) {
    if (!arguments.length) {
      return title;
    }
    title = value;
    return chart;
  };
  chart.evidences = function(value) {
    var evidences;
    if (!arguments.length) {
      return evidences;
    }
    evidences = value;
    return chart;
  };
  chart.label = function(value) {
    if (!arguments.length) {
      return label;
    }
    label = value;
    return chart;
  };
  chart.number = function(value) {
    if (!arguments.length) {
      return number;
    }
    number = value;
    return chart;
  };
  return chart;
};

module.exports = hypothesisBox;

},{"./pnnBox":5}],3:[function(require,module,exports){
var labColorPicker;

labColorPicker = function() {
  var chart, color, height, width;
  width = 30;
  height = 10;
  color = d3.lab(100, 0, 0);
  chart = function(selection) {
    return selection.each(function(data) {
      var group, onClick, rect;
      group = d3.select(this);
      rect = group.selectAll('rect');
      onClick = function(d) {
        var div;
        div = d3.select('body').selectAll('div.color-picker').data([d]);
        if (div.empty()) {
          return div.enter().append('div').attr('class', 'color-picker').style({
            position: 'absolute',
            width: '200px',
            height: '100px',
            border: 'solid 1px #555',
            left: (d3.event.pageX + width) + 'px',
            top: d3.event.pageY + 'px',
            'background-color': '#eee'
          });
        } else {
          return d3.select('body').selectAll('div.color-picker').remove();
        }
      };
      return rect.data([chart.color()]).enter().append('rect').attr({
        width: width,
        height: height,
        fill: function(d) {
          return d;
        },
        stroke: '#222',
        'stroke-width': 1
      }).on('click', onClick);
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.color = function(value) {
    if (!arguments.length) {
      return color;
    }
    color = d3.lab(value);
    return chart;
  };
  return chart;
};

module.exports = labColorPicker;

},{}],4:[function(require,module,exports){
var box1, box2, eBox, evidenceBox, group, hBox, height, hypothesisBox, labColorPicker, margin, offset, picker, sliderControl, svg, width;

sliderControl = require('./sliderControl');

labColorPicker = require('./labColorPicker');

evidenceBox = require('./evidenceBox');

hypothesisBox = require('./hypothesisBox');

width = 600;

height = 60;

margin = 20;

offset = 30;


/*
svg = d3.select '#chart'
		.append 'svg'
		.attr
			width: width + 2*margin
			height: height + 3*margin

value = 70
domain = [0, 100]

cScale = d3.scale.linear()
					.domain domain
					.range ['#edd400', '#a40000']

rectangle = svg.append 'rect'
						.attr
							x: margin
							y: margin*2
							width: width
							height: height
							fill: cScale(value)

slider = sliderControl()
					.onSlide (selection)->
						selection.each (data)->
							rectangle.attr 'fill', cScale(data)

gSlider = svg.selectAll 'g'
						.data [value]
						.enter().append 'g'
						.attr
							transform: "translate(#{[margin,height/2]})"
						.call slider
 */

svg = d3.select('#chart').append('svg').attr({
  width: width,
  height: height
});

picker = labColorPicker().color('#a40000');

group = svg.append('g').attr({
  transform: "translate(" + [offset, offset] + ")"
}).call(picker);

eBox = evidenceBox();

hBox = hypothesisBox();

box1 = d3.select('#evidence').data([0]).call(eBox);

box2 = d3.select('#hypothesis').data([0]).call(hBox);

interact('.dropzone').dropzone({
  accept: '#yes-drop',
  overlap: 0.1,
  ondropactivate: function(event) {
    return event.target.classList.add('drop-active');
  },
  ondragenter: function(event) {
    var draggableElement, dropzoneElement;
    draggableElement = event.relatedTarget;
    dropzoneElement = event.target;
    dropzoneElement.classList.add('drop-target');
    return draggableElement.classList.add('can-drop');
  },
  ondragleave: function(event) {
    console.log('left');
    event.target.classList.remove('drop-target');
    return event.relatedTarget.classList.remove('can-drop');
  },
  ondrop: function(event) {
    var x, y;
    event.target.classList.add(event.relatedTarget.getAttribute('entity-name'));
    event.relatedTarget.classList.add('Dropped');
    x = event.interaction.startCoords.client.x - event.relatedTarget.offsetLeft;
    y = event.interaction.startCoords.client.y - event.relatedTarget.offsetTop - 10;
    event.relatedTarget.style.webkitTransform = event.relatedTarget.style.transform = 'translate(' + x + 'px, ' + y + 'px)';
    event.relatedTarget.setAttribute('data-x', x);
    event.relatedTarget.setAttribute('data-y', y);
    return console.log(event);
  },
  ondropdeactivate: function(event) {
    event.target.classList.remove('drop-active');
    return event.target.classList.remove('drop-target');
  }
});

interact('.draggable.entity').draggable({
  inertia: true,
  restrict: {
    endOnly: true,
    elementRect: {
      top: 0,
      left: 0,
      bottom: 1,
      right: 1
    }
  },
  onmove: function(event) {
    var target, x, y;
    target = event.target;
    x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
    y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;
    target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)';
    target.setAttribute('data-x', x);
    target.setAttribute('data-y', y);
  },
  onend: function(event) {
    var textEl;
    textEl = event.target.querySelector('p');
  }
});

},{"./evidenceBox":1,"./hypothesisBox":2,"./labColorPicker":3,"./sliderControl":6}],5:[function(require,module,exports){
var pnnBox;

pnnBox = function() {
  var chart, drag, evidences, headingButtons, height, label, setupInteract, title, titleClass, width;
  width = 200;
  height = 200;
  title = 'Positive';
  titleClass = 'panel-info';
  evidences = [
    {
      name: 'Anand',
      type: 'label-success'
    }, {
      name: 'GT',
      type: 'label-info'
    }, {
      name: '2011',
      type: 'label-warning'
    }
  ];
  headingButtons = {
    chevron: null,
    label: null,
    settings: null,
    lineChart: null
  };
  label = 5;
  drag = true;
  setupInteract = function() {
    return interact('.draggable').draggable({
      inertia: true,
      restrict: {
        restriction: 'parent',
        endOnly: true,
        elementRect: {
          top: 0,
          left: 0,
          bottom: 1,
          right: 1
        }
      },
      onmove: function(event) {
        var target, x, y;
        target = event.target;
        x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
        y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;
        target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)';
        target.setAttribute('data-x', x);
        return target.setAttribute('data-y', y);
      },
      onend: function(event) {
        var textEl;
        textEl = event.target.querySelector('p');
        return textEl && (textEl.textContent = 'moved a distance of ' + (Math.sqrt(event.dx * event.dx + event.dy * event.dy) | 0) + 'px');
      }
    }).allowFrom('.panel-heading');
  };
  chart = function(selection) {
    return selection.each(function(data) {
      var body, div, heading;
      console.log(data);
      div = d3.select(this).attr('class', function(d) {
        return "pnn panel " + titleClass + " dropzone";
      }, {
        'data-box-type': 'pnn'
      });
      div.style({
        'min-width': width + 'px'
      });
      heading = div.append('div').attr('class', 'panel-heading');
      heading.text(title);
      body = div.append('div').attr('class', 'panel-body dropzone');
      evidences = body.selectAll('div').data(data).enter().append('div').text(function(d) {
        return d;
      }).style({
        margin: '5px 0'
      });
      evidences.append('i').attr('class', 'fa fa-trash pull-right').style({
        'margin-top': '2px'
      }).on('click', function(d, i) {
        data.splice(i, 1);
        evidences = body.selectAll('div').data(data).exit().remove();
        return evidences.data(data).text(function(d) {
          return d;
        }).style({
          margin: '5px 0'
        });
      });
      return headingButtons.label = heading.append('span').attr('class', 'label label-default pull-right').style({
        'margin': '2px 5px'
      }).text(label);
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.title = function(value) {
    if (!arguments.length) {
      return title;
    }
    title = value;
    return chart;
  };
  chart.evidences = function(value) {
    if (!arguments.length) {
      return evidences;
    }
    evidences = value;
    return chart;
  };
  chart.label = function(value) {
    if (!arguments.length) {
      return label;
    }
    label = value;
    return chart;
  };
  chart.titleClass = function(value) {
    if (!arguments.length) {
      return titleClass;
    }
    titleClass = value;
    return chart;
  };
  return chart;
};

module.exports = pnnBox;

},{}],6:[function(require,module,exports){
var sliderControl;

sliderControl = function() {
  var chart, domain, onSlide, width;
  width = 600;
  domain = [0, 100];
  onSlide = function(selection) {};
  chart = function(selection) {
    return selection.each(function(data) {
      var drag, group, handle, moveHandle, posScale;
      moveHandle = function(d) {
        var cx;
        cx = +d3.select(this).attr('cx') + d3.event.dx;
        if (0 < cx && cx < width) {
          return d3.select(this).data([posScale.invert(cx)]).attr({
            cx: cx
          }).call(onSlide);
        }
      };
      group = d3.select(this);
      group.selectAll('line').data([data]).enter().append('line').call(chart.initLine);
      handle = group.selectAll('circle').data([data]).enter().append('circle').call(chart.initHandle);
      posScale = d3.scale.linear().domain(domain).range([0, width]);
      handle.attr({
        cx: function(d) {
          return posScale(d);
        }
      });
      drag = d3.behavior.drag().on('drag', moveHandle);
      return handle.call(drag);
    });
  };
  chart.initLine = function(selection) {
    return selection.attr({
      x1: 2,
      x2: width - 4,
      stroke: '#777',
      'stroke-width': 4,
      'stroke-linecap': 'round'
    });
  };
  chart.initHandle = function(selection) {
    return selection.attr({
      cx: function(d) {
        return width / 2;
      },
      r: 6,
      fill: '#aaa',
      stroke: '#222',
      'stroke-width': 2
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.domain = function(value) {
    if (!arguments.length) {
      return domain;
    }
    domain = value;
    return chart;
  };
  chart.onSlide = function(onSliderFunction) {
    if (!arguments.length) {
      return onSlide;
    }
    onSlide = onSliderFunction;
    return chart;
  };
  return chart;
};

module.exports = sliderControl;

},{}]},{},[4]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var pnnBox;

pnnBox = function() {
  var chart, drag, evidences, headingButtons, height, label, setupInteract, title, titleClass, width;
  width = 200;
  height = 200;
  title = 'Positive';
  titleClass = 'panel-info';
  evidences = [
    {
      name: 'Anand',
      type: 'label-success'
    }, {
      name: 'GT',
      type: 'label-info'
    }, {
      name: '2011',
      type: 'label-warning'
    }
  ];
  headingButtons = {
    chevron: null,
    label: null,
    settings: null,
    lineChart: null
  };
  label = 5;
  drag = true;
  setupInteract = function() {
    return interact('.draggable').draggable({
      inertia: true,
      restrict: {
        restriction: 'parent',
        endOnly: true,
        elementRect: {
          top: 0,
          left: 0,
          bottom: 1,
          right: 1
        }
      },
      onmove: function(event) {
        var target, x, y;
        target = event.target;
        x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
        y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;
        target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)';
        target.setAttribute('data-x', x);
        return target.setAttribute('data-y', y);
      },
      onend: function(event) {
        var textEl;
        textEl = event.target.querySelector('p');
        return textEl && (textEl.textContent = 'moved a distance of ' + (Math.sqrt(event.dx * event.dx + event.dy * event.dy) | 0) + 'px');
      }
    }).allowFrom('.panel-heading');
  };
  chart = function(selection) {
    return selection.each(function(data) {
      var body, div, heading;
      console.log(data);
      div = d3.select(this).attr('class', function(d) {
        return "pnn panel " + titleClass + " dropzone";
      }, {
        'data-box-type': 'pnn'
      });
      div.style({
        'min-width': width + 'px'
      });
      heading = div.append('div').attr('class', 'panel-heading');
      heading.text(title);
      body = div.append('div').attr('class', 'panel-body dropzone');
      evidences = body.selectAll('div').data(data).enter().append('div').text(function(d) {
        return d;
      }).style({
        margin: '5px 0'
      });
      evidences.append('i').attr('class', 'fa fa-trash pull-right').style({
        'margin-top': '2px'
      }).on('click', function(d, i) {
        data.splice(i, 1);
        evidences = body.selectAll('div').data(data).exit().remove();
        return evidences.data(data).text(function(d) {
          return d;
        }).style({
          margin: '5px 0'
        });
      });
      return headingButtons.label = heading.append('span').attr('class', 'label label-default pull-right').style({
        'margin': '2px 5px'
      }).text(label);
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.height = function(value) {
    if (!arguments.length) {
      return height;
    }
    height = value;
    return chart;
  };
  chart.title = function(value) {
    if (!arguments.length) {
      return title;
    }
    title = value;
    return chart;
  };
  chart.evidences = function(value) {
    if (!arguments.length) {
      return evidences;
    }
    evidences = value;
    return chart;
  };
  chart.label = function(value) {
    if (!arguments.length) {
      return label;
    }
    label = value;
    return chart;
  };
  chart.titleClass = function(value) {
    if (!arguments.length) {
      return titleClass;
    }
    titleClass = value;
    return chart;
  };
  return chart;
};

module.exports = pnnBox;

},{}]},{},[1]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var radialLayout;

radialLayout = function() {
  var endAngle, layout, startAngle, value;
  startAngle = 0;
  endAngle = 2 * Math.PI;
  value = function(d) {
    return d.date;
  };
  layout = function(data) {
    var d, gmap, groups, h, hour, hours, i, itemAngle, j, len, len1, val;
    hours = d3.range(0, 24);
    gmap = d3.map();
    groups = [];
    itemAngle = (endAngle - startAngle) / 24;
    for (i = 0, len = hours.length; i < len; i++) {
      h = hours[i];
      gmap.set(h, {
        hour: h,
        startAngle: startAngle + h * itemAngle,
        endAngle: startAngle + (h + 1) * itemAngle,
        count: 0
      });
    }
    for (j = 0, len1 = data.length; j < len1; j++) {
      d = data[j];
      hour = value(d).getHours();
      val = gmap.get(hour);
      val.count += 1;
      gmap.set(hour, val);
    }
    groups = gmap.values();
    groups.sort(function(a, b) {
      if (a.hour > b.hour) {
        return 1;
      } else {
        return -1;
      }
    });
    return groups;
  };
  layout.value = function(accessorFunction) {
    if (!arguments.length) {
      value;
    }
    value = accessorFunction;
    return layout;
  };
  layout.angleExtent = function(value) {
    if (!arguments.length) {
      return [startAngle, endAngle];
    }
    startAngle = value[0];
    endAngle = value[1];
    return layout;
  };
  return layout;
};

module.exports = radialLayout;

},{}]},{},[1]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var sliderControl;

sliderControl = function() {
  var chart, domain, onSlide, width;
  width = 600;
  domain = [0, 100];
  onSlide = function(selection) {};
  chart = function(selection) {
    return selection.each(function(data) {
      var drag, group, handle, moveHandle, posScale;
      moveHandle = function(d) {
        var cx;
        cx = +d3.select(this).attr('cx') + d3.event.dx;
        if (0 < cx && cx < width) {
          return d3.select(this).data([posScale.invert(cx)]).attr({
            cx: cx
          }).call(onSlide);
        }
      };
      group = d3.select(this);
      group.selectAll('line').data([data]).enter().append('line').call(chart.initLine);
      handle = group.selectAll('circle').data([data]).enter().append('circle').call(chart.initHandle);
      posScale = d3.scale.linear().domain(domain).range([0, width]);
      handle.attr({
        cx: function(d) {
          return posScale(d);
        }
      });
      drag = d3.behavior.drag().on('drag', moveHandle);
      return handle.call(drag);
    });
  };
  chart.initLine = function(selection) {
    return selection.attr({
      x1: 2,
      x2: width - 4,
      stroke: '#777',
      'stroke-width': 4,
      'stroke-linecap': 'round'
    });
  };
  chart.initHandle = function(selection) {
    return selection.attr({
      cx: function(d) {
        return width / 2;
      },
      r: 6,
      fill: '#aaa',
      stroke: '#222',
      'stroke-width': 2
    });
  };
  chart.width = function(value) {
    if (!arguments.length) {
      return width;
    }
    width = value;
    return chart;
  };
  chart.domain = function(value) {
    if (!arguments.length) {
      return domain;
    }
    domain = value;
    return chart;
  };
  chart.onSlide = function(onSliderFunction) {
    if (!arguments.length) {
      return onSlide;
    }
    onSlide = onSliderFunction;
    return chart;
  };
  return chart;
};

module.exports = sliderControl;

},{}]},{},[1]);
