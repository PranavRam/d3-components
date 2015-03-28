legendChart = ->
	width = 200
	cScale = d3.scale.category20()
	key = (d)-> d.name
	label = (d)-> d.name

	chart = (selection)->
		selection.each (data)->
			containerDiv = d3.select(this)
								.style
									width: width+'px'

			containerDiv.selectAll('p.legend-title')
									.data([data])
									.enter()
									.append('p')
									.attr('class', 'legend-title')
									.text('Legend')

			itemDiv = containerDiv.selectAll('div.item')
									.data(data)
									.enter()
									.append('div')
									.attr('class', 'item')

			itemP = itemDiv.append('p')
								.style
									'line-height': '0.8em'
									'font-size': '11px'

			itemP.append('span')
						.text('..')
						.style
							color: (d)-> cScale(d.name)
							background: (d)-> cScale(d.name)

			itemP.append('text')
						.text(label)
	
	chart.colorScale = (value)->
		if !arguments.length then return cScale
		cScale = value
		chart

	chart

module.exports = legendChart