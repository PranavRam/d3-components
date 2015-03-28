radialLayout = ->

	startAngle = 0
	endAngle = 2 * Math.PI

	value = (d)->
		d.date

	layout = (data)->
		hours = d3.range 0, 24
		gmap = d3.map()
		groups = []

		itemAngle = (endAngle - startAngle) / 24

		for h in hours
			gmap.set(h, {
				hour: h, 
				startAngle: startAngle + h * itemAngle,
				endAngle: startAngle + (h + 1) * itemAngle,
				count: 0
			})
		
		for d in data
			hour = value(d).getHours()
			val = gmap.get(hour)
			val.count += 1
			gmap.set hour, val

		groups = gmap.values()
		groups.sort (a,b)->
			if a.hour > b.hour then 1 else -1

		groups

	layout.value = (accessorFunction)->
		if !arguments.length then value
		value = accessorFunction
		layout

	layout.angleExtent = (value)->
		if !arguments.length then return [startAngle, endAngle]
		startAngle = value[0]
		endAngle = value[1]
		layout

	layout

module.exports = radialLayout