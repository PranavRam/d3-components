barcodeChart = ->
	width = 400
	height = 30
	margin =
		top: 5
		right: 5
		bottom: 5
		left: 5

	value = (d)->
		d.date

	timeInterval = d3.time.day

	svgInit = (svg)->
		svg.attr
			width: width
			height: height

		g = svg.append 'g'
					.attr
						'class': 'chart-content'
						transform: "translate(#{margin.top},#{margin.left})"

		g.append 'rect'
			.attr
				width: width - margin.left - margin.right
				height: height - margin.top - margin.bottom
				fill: 'white'

	chart = (selection)->
		selection.each (data)->
			div = d3.select(this).attr 'class', 'data-item'
			svg = div.selectAll('svg').data([data])
			svgEnter = svg.enter()

			svgEnter
				.append 'svg'
				.call svgInit

			g = svg.select 'g.chart-content'
			lines = g.selectAll 'line'

			lastDate = d3.max(data, value)

			lastDate = if lines.empty() then lastDate else d3.max(lines.data(), value)
			firstDate = timeInterval.offset(lastDate, -1)

			xScale = d3.time.scale()
								.domain [firstDate, lastDate]
								.range [0, width - margin.left - margin.right]

			bars = g.selectAll 'line'
							.data data, value

			bars.enter()
					.append 'line'
					.attr
						x1: (d)->
							xScale(value(d))
						x2: (d)->
							xScale(value(d))
						y1: 0
						y2: height - margin.top - margin.bottom
						stroke: '#000'
						'stroke-opacity': 0.5

			lastDate = d3.max(data, value)
			firstDate = timeInterval.offset(lastDate, -1)

			xScale.domain [firstDate, lastDate]

			bars.transition()
					.duration 300
					.attr
						x1: (d)->
							xScale value(d)
						x2: (d)->
							xScale value(d)

			bars.exit()
					.transition()
					.duration 300
					.attr
						'stroke-opacity': 0
					.remove()
					

	chart.width = (value)->
		if !arguments.length then return width
		width = value
		chart

	chart.height = (value)->
		if !arguments.length then return height
		height = value
		chart

	chart.value = (accessorFunction)->
		if !arguments.length then return value
		value = accessorFunction
		chart

	chart.timeInterval = (value)->
		if !arguments.length then return timeInterval
		timeInterval = value
		chart

	chart

module.exports = barcodeChart
