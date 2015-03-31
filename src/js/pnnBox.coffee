pnnBox = ->
	width = 200
	height = 200
	title = 'Positive'
	titleClass = 'panel-info'
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
		settings: null
		lineChart: null

	label = 5

	chart = (selection)->
		# console.log arguments
		selection.each (data)->
			# console.log data

			removeItems = (d,i)->
				data.splice(i, 1)
				# console.log data, d, i
				evidences.data data
					.text (d)-> d
					.style
						margin: '5px 0'
				# console.log evidences
				evidences = body
					.selectAll('div.evidence')
					.data data
				trash = evidences.call appendTrash
				plusMinus = evidences.call appendPlusMinus
				
				# console.log evidences	
				evidences.exit().remove()

			appendPlusMinus = (selection)->
				selection.each (data)->
					d3.select this
						.append('i')
						.attr 'class', 'fa fa-minus pull-right'
						.style
							'margin-top': '4px'
							'margin-right': '1em'
						# .on 'click', removeItems

					d3.select this
						.append('i')
						.attr 'class', 'fa fa-plus pull-right'
						.style
							'margin-top': '4px'
							'margin-right': '2px'
						# .on 'click', removeItems

			appendTrash = (selection)->
				selection.each (data)->
					d3.select this
						.append('i')
						.attr 'class', 'fa fa-trash pull-right'
						.style
							'margin-top': '4px'
						.on 'click', removeItems

			div = d3.select(this)
				.attr(
					'class': (d)-> "pnn panel #{titleClass}"
					'data-box-type': 'pnn'
					'data-box-category': title)
			# console.log div.attr('data-box-type', 'pnn')
			div
				.style
					'min-width': 100+'%'
					# height: height+'px'

			heading = div.append('div').attr 'class', 'panel-heading'

			heading.text title

			body = div.append('div').attr 'class', 'panel-body'
			# console.log body.data()
			evidences = body
										.selectAll('div.evidence')
										.data data
										.enter()
										.append('div')
										.attr 'class', 'evidence'
										.text (d)-> d
										.style
											margin: '5px 0'

			trash = evidences.call appendTrash
			plusMinus = evidences.call appendPlusMinus


			headingButtons.label = heading
				.append 'span'
				.attr 'class', 'label label-default pull-right'
				.style
					'margin': '2px 5px'
				.text label

			# if drag then setupInteract()

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

	chart.titleClass = (value)->
		if !arguments.length then return titleClass
		titleClass = value
		chart	

	chart

module.exports = pnnBox