pnnBox = ->
	width = 200
	height = 200
	title = 'Positive'
	titleClass = 'panel-info'
	parentBox = -1
	mainDiv = null
	headingButtons = 
		chevron: null
		label: null
		settings: null
		lineChart: null

	label = 5

	removeItems = (d,i)->
		# body = d3.select(this.parentNode.parentNode)
		console.log mainDiv.data()
		data = mainDiv.data()[0]
		data.splice(i, 1)
		label--
		chart.update(data)

	appendPlusMinus = (selection)->
		# selection.each (data)->
		selection
			.append('i')
			.attr 'class', 'fa fa-minus pull-right'
			.style
				'margin-top': '4px'
				'margin-right': '1em'
			# .on 'click', removeItems

		selection
			.append('i')
			.attr 'class', 'fa fa-plus pull-right'
			.style
				'margin-top': '4px'
				'margin-right': '2px'
			# .on 'click', removeItems

	appendTrash = (selection)->
		# data selection.data()
		# selection.each (data)->
			# console.log data
			# console.log 'here'
		selection
			.append('i')
			.attr 'class', 'fa fa-trash pull-right'
			.style
				'margin-top': '4px'
			.on 'click', removeItems

	chart = (selection)->
		# console.log arguments
		selection.each (data)->
			# console.log data
			mainDiv = d3.select(this)
				.attr(
					'class': (d)-> "pnn panel #{titleClass}"
					'data-box-type': 'pnn'
					'data-parent-box': parentBox || 0
					'data-box-category': title)
				.style
					'min-width': 100+'%'
			# console.log data
			chart.update(data)
			# console.log div.attr('data-box-type', 'pnn')
			# evidences.text (d,i)-> i

			# if drag then setupInteract()

	chart.update = (data)->
		mainDiv.data [data]
		mainDiv.call chart.initHeading
		mainDiv.call chart.initBody

	chart.initHeading = (selection)->
		heading = selection.select('.panel-heading')
		if heading.empty()
			heading = selection.append('div').attr 'class', 'panel-heading'

		heading.text title

		headingButtons.label = heading
				.append 'span'
				.attr 'class', 'label label-default pull-right'
				.text label
				.style
					'margin': '2px 5px'

	chart.initBody = (selection)->
		body = selection.select('.panel-body')
		if body.empty()
			body = selection.append('div').attr 'class', 'panel-body'
		# selection.each (data)-> console.log data
		body.call chart.initEvidences

	chart.initEvidences = (selection)->
		selection.each (data)->
			# console.log data
			evidence = d3.select this
					.selectAll('div.evidence')
					.data data

			evidence
					.enter()
					.append('div')
					.attr 'class', 'evidence'
					.style
						margin: '5px 0'

			evidence
				.text (d)-> d

			evidence.exit().remove()

			trash = evidence.call appendTrash
			plusMinus = evidence.call appendPlusMinus

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

	chart.parentBox = (value)->
		if !arguments.length then return parentBox
		parentBox = value
		chart

	chart.label = (value)->
		if !arguments.length then return label
		label = value
		chart

	chart.titleClass = (value)->
		if !arguments.length then return titleClass
		titleClass = value
		chart	

	chart

module.exports = pnnBox