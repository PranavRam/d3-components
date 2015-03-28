sliderControl = ->
	width = 600
	domain = [0, 100]
	onSlide = (selection)-> return

	chart = (selection)->
		selection.each (data)->
			moveHandle = (d)->
				cx = +d3.select(this).attr('cx') + d3.event.dx

				if 0 < cx and cx < width
					d3.select this
							.data [posScale.invert cx]
							.attr
								cx: cx
							.call onSlide

			group = d3.select this
			group.selectAll 'line'
					.data [data]
					.enter().append 'line'
					.call chart.initLine

			handle = group.selectAll 'circle'
									.data [data]
									.enter().append 'circle'
									.call chart.initHandle

			posScale = d3.scale.linear()
									.domain domain
									.range [0, width]

			handle
				.attr
					cx: (d)-> posScale(d)

			drag = d3.behavior.drag().on 'drag', moveHandle

			handle.call drag

	chart.initLine = (selection)->
		selection
			.attr
				x1: 2
				x2: width - 4
				stroke: '#777'
				'stroke-width': 4
				'stroke-linecap': 'round'

	chart.initHandle = (selection)->
		selection
			.attr
				cx: (d)-> width/2
				r: 6
				fill: '#aaa'
				stroke: '#222'
				'stroke-width': 2

	chart.width = (value)->
		if !arguments.length then return width
		width = value
		chart

	chart.domain = (value)->
		if !arguments.length then return domain
		domain = value
		chart

	chart.onSlide = (onSliderFunction)->
		if !arguments.length then return onSlide
		onSlide = onSliderFunction
		chart

	chart

module.exports = sliderControl