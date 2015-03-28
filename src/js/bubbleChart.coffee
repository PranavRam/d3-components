bubbleChart = ->
	width = 700
	height = 400

	radiusExtent = [10, 50]
	cScale = d3.scale.category10()

	name = (d)-> d.name
	usage = (d)-> d.usage
	charge = (d)-> -0.12 * d.r * d.r

	chart = (selection)->
		selection.each (data)->
			containerDiv = d3.select(this)
											.style
												position: 'relative'
												width: width + 'px'
												height: height + 'px'
												padding: 0
												'background-color': '#eeeeec'

			items = data

			nameList = items.map name
			uniqueList = d3.set(nameList).values()
			cScale.domain uniqueList

			rScale = d3.scale.sqrt()
		  					.domain d3.extent(items, usage)
		  					.range(radiusExtent)

			items.sort (a,b)-> usage(b) - usage(a)

			items.forEach (d)-> d.r = rScale(usage(d))

			force = d3.layout.force()
						.nodes items
						.links []
						.size [width, height]
						.charge charge
						.start()

			bubbleDivs = containerDiv.selectAll 'div.bubble'
										.data items
										.enter()
										.append 'div'
										.attr 'class', 'bubble'
										.style
											position: 'absolute'
											width: (d)->
												(2 * d.r) + 'px'
											height: (d)->
												(2 * d.r) + 'px'
											'border-radius': (d)->
												d.r + 'px'
											'background-color': (d)->
												cScale(name(d))

			force.on 'tick', ->
				bubbleDivs
					.style
						top: (d)->
							(d.y - d.r) + 'px'
						left: (d)->
							(d.x - d.r) + 'px'

	chart.width = (value)->
		if !arguments.length then return width
		width = value
		chart

	chart.height = (value)->
		if !arguments.length then return height
		height = value
		chart

	chart.radiusExtent = (value)->
		if !arguments.length then return radiusExtent
		radiusExtent = value
		chart

	chart.name = (accessorFunction)->
		if !arguments.length then return name
		name = accessorFunction
		chart

	chart.usage = (accessorFunction)->
		if !arguments.length then return usage
		usage = accessorFunction
		chart

	chart.charge = (accessorFunction)->
		if !arguments.length then return charge
		charge = accessorFunction
		chart

	chart.colorScale = (accessorFunction)->
		if !arguments.length then return cScale
		cScale = accessorFunction
		chart
		
	chart

module.exports = bubbleChart