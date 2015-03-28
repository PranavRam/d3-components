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
	drag = true

	setupInteract = ->
		interact('.draggable')
		.draggable
		  inertia: true
		  restrict:
		    restriction: 'parent'
		    endOnly: true
		    elementRect:
		      top: 0
		      left: 0
		      bottom: 1
		      right: 1
		  onmove: (event) ->
		    target = event.target
		    x = (parseFloat(target.getAttribute('data-x')) or 0) + event.dx
		    y = (parseFloat(target.getAttribute('data-y')) or 0) + event.dy
		    # translate the element
		    target.style.webkitTransform = target.style.transform = 'translate(' + x + 'px, ' + y + 'px)'
		    # update the posiion attributes
		    target.setAttribute 'data-x', x
		    target.setAttribute 'data-y', y
		  onend: (event) ->
		    textEl = event.target.querySelector('p')
		    textEl and (textEl.textContent = 'moved a distance of ' + (Math.sqrt(event.dx * event.dx + event.dy * event.dy) | 0) + 'px')
		.allowFrom '.panel-heading'

	chart = (selection)->
		# console.log arguments
		selection.each (data)->
			# console.log data
			div = d3.select(this)
				.attr(
					'class': (d)-> "pnn panel #{titleClass}"
					'data-box-type': 'pnn')
			# console.log div.attr('data-box-type', 'pnn')
			div
				.style
					'min-width': width+'px'
					# height: height+'px'

			heading = div.append('div').attr 'class', 'panel-heading'

			heading.text title

			body = div.append('div').attr 'class', 'panel-body'
			# console.log body.data()
			evidences = body
										.selectAll('div')
										.data data
										.enter()
										.append('div')
										.text (d)-> d
										.style
											margin: '5px 0'
			
			evidences.append('i')
									.attr 'class', 'fa fa-trash pull-right'
									.style
										'margin-top': '2px'
									.on 'click', (d, i)->
										data.splice(i, 1)
										# console.log data, d, i
										evidences.data data
											.text (d)-> d
											.style
												margin: '5px 0'
										evidences = body
											.selectAll('div')
											.data data
											.exit().remove()


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