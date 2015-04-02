pnnBox = require './pnnBox'
ACHBar = require './ACHBar'

hypothesisBox = ->
	width = 400
	height = 400
	number = 0
	title = 'Anand Framed Roger Rabbit'
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
		selection.each (data)->
			# console.log this
			# if layers.mainDiv is null
			mainDiv = d3.select(this)
				.attr(
					'class': 'panel panel-dark draggable hypothesis'
					'data-box-type': 'hypothesis'
					'data-box-number': number)
				.style
					width: width+'px'
					position: 'absolute'

			mainDiv.data [data]
			mainDiv.call chart.initHeading
			mainDiv.call chart.initBody
			mainDiv.call chart.initBottomBar
			
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
					selection.select('.panel-body')
						.style hideDivStyle

					d3.select(this).attr 'class', 'fa fa-chevron-down pull-right'

					selection.select('.ach-bar')
						.style showDivStyle

					hideBody = true
				else
					selection.select('.panel-body')
						.style showDivStyle

					d3.select(this).attr 'class', 'fa fa-chevron-up pull-right'

					selection.select('.ach-bar')
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
		body = selection.select('.panel-body')
		if body.empty()
			body = selection.append('div').attr 'class', 'panel-body'

		body.call chart.initPNNBoxes

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
		bottomBar = selection.select '.ach-bar'

		if bottomBar.empty()
			bottomBar = selection.append('div')

		bottomBar
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