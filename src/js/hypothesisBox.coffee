pnnBox = require './pnnBox'
ACHBar = require './ACHBar'

hypothesisBox = ->
	width = 400
	height = 400
	number = 0
	title = 'Anand Framed Roger Rabbit'

	hypothesis =
		positive:
			data: ["Evidence 1", "Evidence 2"]
		negative:
			data: ["Evidence 3", "Evidence 4"]
		neutral:
			data: ["Evidence 5", "Evidence 6"]

	headingButtons = 
		chevron: null
		label: null
		settings: null
		lineChart: null

	label = 5
	hideBody = false

	chart = (selection)->
		# console.log selection[0][0]
		selection.each (data)->
			div = d3.select(this)
				.attr(
					'class': 'panel panel-dark draggable'
					'data-box-type': 'hypothesis'
					'data-box-number': number)

			div
				.style
					width: width+'px'
					# height: height+'px'

			heading = div.append('div').attr 'class', 'panel-heading'
			heading.text title

			achBottomBar = ACHBar()
			bottomBar = div
						.append('div')
						.datum [10, 4, 2]
						.attr('class', 'ach-bar')
						.style
								display: 'none'
								visibility: 'hidden'
						.call achBottomBar

			body = div.append('div').attr 'class', 'panel-body'

			positiveBox = pnnBox().title('Positive').titleClass('panel-info').parentBox(number)
			negativeBox = pnnBox().title('Negative').titleClass('panel-danger').parentBox(number)
			neutralBox = pnnBox().title('Neutral').titleClass('panel-warning').parentBox(number)
			# negativeBox = hypothesisBox().title('Negative')
			# neutralBox = hypothesisBox().title('Neutral')

			# console.log [hypothesis.positive.data]
			positiveDiv = body
									.append('div')
									.data([hypothesis.positive.data])
									.call positiveBox

			negativeDiv = body
									.append('div')
									.data([hypothesis.negative.data])
									.call negativeBox

			neutralDiv = body
									.append('div')
									.data([hypothesis.neutral.data])
									.call neutralBox
			# margin = 5
			# domain = [0, 100]
			# cScale = d3.scale.linear()
			# 					.domain domain
			# 					.range ['#edd400', '#a40000']
			# rectangle = body.append('svg').append 'rect'
			# 			.attr
			# 				x: margin
			# 				y: margin*2
			# 				width: 100
			# 				height: 100
			# 				fill: cScale(70)

			headingButtons.chevron = heading
				.append 'i'
				.attr 'class', 'fa fa-chevron-up pull-right'
				.style
					'margin-top': '4px'
				.on 'click', (d)->

					if not hideBody
						body
							.style
								display: 'none'
								visibility: 'hidden'
						# div
						# 	.style 'height', 'auto'

						d3.select(this).attr 'class', 'fa fa-chevron-down pull-right'

						bottomBar
							.style
								display: 'block'
								visibility: 'visible'

						hideBody = true
					else
						body
							.style
								display: 'block'
								visibility: 'visible'

						# div
						# 	.style 'height', 'auto'

						d3.select(this).attr 'class', 'fa fa-chevron-up pull-right'

						bottomBar
							.style
								display: 'none'
								visibility: 'hidden'

						hideBody = false

			headingButtons.settings = heading
				.append 'i'
				.attr 'class', 'fa fa-cog pull-right'
				.style
					'margin': '4px 5px'

			headingButtons.lineChart = heading
				.append 'i'
				.attr 'class', 'fa fa-line-chart pull-right'
				.style
					'margin': '4px 5px'

			headingButtons.label = heading
				.append 'span'
				.attr 'class', 'label label-danger pull-right'
				.style
					'margin': '4px 5px'
				.text label

	chart.width = (value)->
		if !arguments.length then return width
		width = value
		chart

	chart.height = (value)->
		if !arguments.length then return height
		height = value
		chart

	chart.title = (value)->
		if !arguments.length then return title
		title = value
		chart

	chart.evidences = (value)->
		if !arguments.length then return evidences
		evidences = value
		chart

	chart.label = (value)->
		if !arguments.length then return label
		label = value
		chart

	chart.number = (value)->
		if !arguments.length then return number
		number = value
		chart	

	chart

module.exports = hypothesisBox