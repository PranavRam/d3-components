labColorPicker = ->
	width = 30
	height = 10

	color = d3.lab 100, 0, 0

	chart = (selection)->
		selection.each (data)->
			group = d3.select this
			rect = group.selectAll 'rect'

			onClick = (d)->
				div = d3.select 'body'
								.selectAll 'div.color-picker'
								.data [d]

				if div.empty()
					div.enter()
						.append 'div'
						.attr 'class','color-picker'
						.style
							position: 'absolute'
							width: '200px'
							height: '100px'
							border: 'solid 1px #555'
							left: (d3.event.pageX + width) + 'px'
							top: d3.event.pageY + 'px'
							'background-color': '#eee'
				else
					d3.select('body').selectAll('div.color-picker').remove()

			rect
				.data [chart.color()]
				.enter()
				.append 'rect'
				.attr
					width: width
					height: height
					fill: (d)-> d
					stroke: '#222'
					'stroke-width': 1
				.on 'click', onClick

	chart.width = (value)->
		if !arguments.length then return width
		width = value
		chart

	chart.height = (value)->
		if !arguments.length then return height
		height = value
		chart

	chart.color = (value)->
		if !arguments.length then return color
		color = d3.lab value
		chart

	chart

module.exports = labColorPicker