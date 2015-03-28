barcodeChart = require('./barcodeChart')
radialLayout = require('./radialLayout')

barcode = barcodeChart()
layout = radialLayout()
					.value (d)->
						d.date
					# .angleExtent([Math.PI / 3, 2 * Math.PI / 3])

randomInterval = (avgSeconds)->
	Math.floor(-Math.log(Math.random()) * 1000 * avgSeconds)

addData = (data, numItems, avgSeconds)->
	n = data.length
	t = if (n > 0) then data[n - 1].date else new Date()

	for i in [0...numItems]
		t = new Date(t.getTime()+randomInterval(avgSeconds))
		data.push {date: t}

	data

# data = addData [], 150, 300
data = addData([], 300, 20 * 60)
output = layout data
console.log output
d3.select '#btn-update'
	.on 'click', ->
		data = addData(data, 30, 3*60)
		d3.select '#chart'
			.selectAll 'div.data-item'
			.data([data])
			.call(barcode)

divChart = d3.select '#chart'
			.selectAll 'div.data-item'
			.data [data]
			.enter()
			.append 'div'
			.attr 'class', 'data-item'
			.call barcode

width = 400
height = 200
innerRadius = 30
outerRadius = 100

svg = d3.select '#radial-chart'
				.append 'svg'
				.attr
					width: width
					height: height

g = svg.append 'g'
			.attr
				transform: "translate(#{width/2},#{height/2})"

rScale = d3.scale.sqrt()
					.domain([0, d3.max(output, (d)-> d.count)])
					.range([2, outerRadius - innerRadius])

arc = d3.svg.arc()
			.innerRadius(innerRadius)
			.outerRadius (d)->
				innerRadius + rScale(d.count)

g.selectAll 'path'
	.data(output)
	.enter()
	.append 'path'
	.attr
		d: (d)->
			arc(d)
		fill: 'grey'
		stroke: 'white'
		'stroke-width': 1