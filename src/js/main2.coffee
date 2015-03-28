bubbleChart = require './bubbleChart'
legendChart = require './legendChart'

chart = bubbleChart()

d3.json 'data/browsers.json', (error, data)->
	if(error) then console.error 'Not good'

	d3.select '#chart'
		.data([data.values])
		.style
			float: 'left'
			margin: '2px'
		.call(chart)

	browsers = d3.map()
	data.values.forEach (d)->
		item = browsers.get(d.name)
		if item
			browsers.set d.name,
				name: d.name
				usage: d.usage + item.usage
		else
			browsers.set d.name,
				name: d.name
				usage: d.usage

	browserItems = browsers.values()
										.sort (a,b)->
											b.usage - a.usage

	# console.log legendChart().colorScale									
	legend = legendChart()
						.colorScale(chart.colorScale())
						# .label (d)->
						# 	" #{d.name} (#{d.usage.toFixed(2)}%)"

	legendDiv = d3.select('#legend')
								.data([browserItems])
								.style
									float: 'left'
									margin: '2px'
								.call legend

width = 600
height = 300

containerDiv = d3.select '#canvasg-demo'
svg = containerDiv.append 'svg'
					.attr
						width: width
						height: height

data = []
for k in [0...60]
	for j in [0...30]
		data.push
			x: 5 + 10*k
			y: 5 + 10*j
			z: (k - 50)+(20-j)

rScale = d3.scale.sqrt()
						.domain d3.extent(data, (d)-> d.z)
						.range([3,5])

cScale = d3.scale.linear()
					.domain d3.extent(data, (d)-> d.z)
					.range(['#204a87', '#cc0000'])

svg.selectAll 'circle'
		.data data
		.enter()
		.append('circle')
		.attr
			cx: (d)-> d.x
			cy: (d)-> d.y
			r: (d)-> rScale(d.z)
			fill: (d)-> cScale(d.z)
			'fill-opacity': 0.9