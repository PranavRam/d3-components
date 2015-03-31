sliderControl = require './sliderControl'

labColorPickerWindow = ->
	margin = 10
	labelWidth = 20
	sliderWidth = 80
	squareSize = 60
	width = 3 * margin + labelWidth + sliderWidth + squareSize
	height = 2 * margin + squareSize

	onColorChange = (color)-> return

	chart = (selection)->
		selection.each (data)->
			updateColor = (color)->
				colorSquare.attr
					fill: color
				divContent.data [color]
					.call onColorChange

			vScale = d3.scale.ordinal()
								.domain [0, 1, 2]
								.rangePoints [0, squareSize], 1

			divContent = d3.select this
										.style
											width: width+'px'
											height: height+'px'
											border: 'solid 1px #555'
											'background-color': '#eee'

			svg = divContent.selectAll 'svg'
							.data [data]
							.append 'svg'
							.attr
								width: width
								height: height

			colorSquare = svg.append 'rect'
											.attr
												x: 2 * margin + sliderWidth + labelWidth
												y: margin
												width: squareSize
												height: squareSize
												fill: data

			svg.selectAll 'text'
				.data ['L', 'a', 'b']
				.enter()
				.append 'text'
				.attr
					x: margin
					y: (d, i)-> margin+vScale(i)
				.text: (d)-> d