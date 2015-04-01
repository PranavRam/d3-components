evidenceBox = ->
	width = 250
	height = 300
	number = 0
	title = 'Evidence 1 (110203.txt)'
	layers =
		mainDiv: null

	hideDivStyle = 
		display: 'none'
		visibility: 'hidden'
	showDivStyle =
		display: 'block'
		visibility: 'visible'

	evidences = [{
		name:'Anand',
		type: 'label-success'
		}, {
		name: 'GT',
		type: 'label-info'
		},{
		name: '2011',
		type: 'label-warning'
	}]
	headingButtons = 
		chevron: null
		label: null
		add: null

	label = 4
	hideBody = false	

	chart = (selection)->
		selection.each (data)->
			layers.mainDiv = d3.select(this)
				.attr(
					'class': 'panel panel-primary draggable'
					'data-box-type': 'evidence'
					'data-box-number': number)
				.style
					width: width+'px'
					position: 'absolute'

			layers.mainDiv.data [data]
			layers.mainDiv.call chart.initHeading
			layers.mainDiv.call chart.initBody

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
					selection.select '.panel-body'
						.style hideDivStyle

					d3.select(this).attr 'class', 'fa fa-chevron-down pull-right'
					hideBody = true
				else
					selection.select '.panel-body'
						.style showDivStyle

					d3.select(this).attr 'class', 'fa fa-chevron-up pull-right'
					hideBody = false

		headingButtons.add = heading
													.append 'i'
													.attr 'class', 'fa fa-plus pull-right'
													.style
														'margin-top': '4px'

		headingButtons.label = heading
			.append 'span'
			.attr 'class', 'label label-danger pull-right'
			.style
				'margin-top': '4px'
			.text label

	chart.initBody = (selection)->
		body = selection.select('.panel-body')
		if body.empty()
			body = selection.append('div').attr 'class', 'panel-body dropzone'
		# selection.each (data)-> console.log data
		body.call chart.initEntities

	chart.initEntities = (selection)->
		selection.each (data)->
			sel = d3.select this
			entities = sel.selectAll('div.entity')
									.data evidences

			entityDiv = entities
									.enter()
									.append 'div'
									.attr 'class', 'entity'
									.style 
										'margin': '5px 0'
			entities.exit().remove()

			entityLabel = entityDiv.select 'span.label'
			if entityLabel.empty()
				entityLabel = entityDiv
												.append 'span'
			entityLabel
				.attr 'class', (d, i)-> "label #{d.type}"
				.text (d)-> d.name


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

module.exports = evidenceBox