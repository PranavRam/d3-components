evidenceBox = ->
	width = 250
	height = 300
	number = 0
	title = 'Evidence 1 (110203.txt)'
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
			div = d3.select(this)
				.attr(
					'class': 'panel panel-primary draggable'
					'data-box-type': 'evidence'
					'data-box-number': number)

			div
				.style
					width: width+'px'
					# height: height+'px'

			heading = div.append('div').attr 'class', 'panel-heading'

			heading.text title

			body = div.append('div').attr 'class', 'panel-body dropzone'

			evidenceDivs = body.selectAll('span').data(evidences)
			evidenceDivs.enter()
					.append('div')
					.style 'margin', '5px 0'
					.append('span')
					.attr 'class', (d, i)-> "label #{d.type}"
					.text (d)-> d.name
					.style
						margin: '5px'


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
						# 	.style 'height', '43px'

						d3.select(this).attr 'class', 'fa fa-chevron-down pull-right'
						hideBody = true
					else
						body
							.style
								display: 'block'
								visibility: 'visible'

						div
							.style 'height', 'auto'

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
			# console.log body

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