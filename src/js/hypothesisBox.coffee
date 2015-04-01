pnnBox = require './pnnBox'
ACHBar = require './ACHBar'

hypothesisBox = ->
	width = 400
	height = 400
	number = 0
	title = 'Anand Framed Roger Rabbit'
	layers = 
		mainDiv: null
		body: null
		bottomBar: null

	hypothesis = null

	hideDivStyle = 
		display: 'none'
		visibility: 'hidden'
	showDivStyle =
		display: 'block'
		visibility: 'visible'

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
			if layers.mainDiv is null
				layers.mainDiv = d3.select(this)
					.attr(
						'class': 'panel panel-dark draggable'
						'data-box-type': 'hypothesis'
						'data-box-number': number)
					.style
						width: width+'px'

			layers.mainDiv.data [data]
			layers.mainDiv.call chart.initHeading
			layers.mainDiv.call chart.initBody
			layers.mainDiv.call chart.initBottomBar
			
	chart.initHeading = (selection)->
		heading = selection.select('.panel-heading')
		if heading.empty()
			heading = selection.append('div').attr 'class', 'panel-heading'

		heading.text title

		headingButtons.chevron = heading
			.append 'i'
			.attr 'class', 'fa fa-chevron-up pull-right'
			.style
				'margin-top': '4px'
			.on 'click', (d)->

				if not hideBody
					layers.body
						.style hideDivStyle

					d3.select(this).attr 'class', 'fa fa-chevron-down pull-right'

					layers.bottomBar
						.style showDivStyle

					hideBody = true
				else
					layers.body
						.style showDivStyle

					d3.select(this).attr 'class', 'fa fa-chevron-up pull-right'

					layers.bottomBar
						.style hideDivStyle

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


	chart.initBody = (selection)->
		layers.body = selection.select('.panel-body')
		if layers.body.empty()
			layers.body = selection.append('div').attr 'class', 'panel-body'

		layers.body.call chart.initPNNBoxes

	chart.initPNNBoxes = (selection)->
		selection.each (data)->
			hypothesis = data
			
			positiveBox = pnnBox().title('Positive').titleClass('panel-info').parentBox(number)
			negativeBox = pnnBox().title('Negative').titleClass('panel-danger').parentBox(number)
			neutralBox = pnnBox().title('Neutral').titleClass('panel-warning').parentBox(number)
			# negativeBox = hypothesisBox().title('Negative')
			# neutralBox = hypothesisBox().title('Neutral')
			sel = d3.select(this)
			positiveDiv = sel.select '.pnn.panel-info'
			if positiveDiv.empty()
				positiveDiv = sel.append('div')
			positiveDiv
				.data([hypothesis.positive.data])
				.call positiveBox

			negativeDiv = sel.select '.pnn.panel-danger'
			if negativeDiv.empty()
				negativeDiv = sel.append('div')
			negativeDiv
				.data([hypothesis.negative.data])
				.call negativeBox

			neutralDiv = sel.select '.pnn.panel-warning'
			if neutralDiv.empty()
				neutralDiv = sel.append('div')
			neutralDiv
				.data([hypothesis.neutral.data])
				.call neutralBox

	chart.initBottomBar = (selection)->
		achBottomBar = ACHBar()
		layers.bottomBar = selection.select '.ach-bar'

		if layers.bottomBar.empty()
			layers.bottomBar = selection.append('div')

		layers.bottomBar
			.datum [10, 4, 2]
			.attr('class', 'ach-bar')
			.style hideDivStyle
			.call achBottomBar
					

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

	chart.hypothesis = (value)->
		if !arguments.length then return hypothesis
		hypothesis = value
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