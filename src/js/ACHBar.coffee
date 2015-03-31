ACHBar = ->
	width = null
	height = 30
	color = d3.scale.linear()
					.domain [0, 1, 2]
					.range ["green", "red", "yellow"]

	chart = (selection)->
		selection.each (data)->
			div = d3.select this
			div
				.style
					height: height+'px'
					width: width || div.style('width')

			bars = div.selectAll('div.bar')
						.data data
						.enter()
						.append('div')
						.attr 'class', 'bar'
						.style
							width: (d)-> "#{(d / d3.sum(data)) * 100}%"
							display: 'inline-block'
							margin: 0
							height: height+'px'
							'background-color': (d, i)-> color(i)

			barCount = bars.text (d)-> d
										.style 'text-align', 'center'

	chart

module.exports = ACHBar