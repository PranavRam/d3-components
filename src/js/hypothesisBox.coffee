pnnBox = require './pnnBox'

hypothesisBox = ->
	width = 600
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
	drag = true

	setupDropzone =  ->
		interact("[data-box-type='hypothesis'][data-box-number='#{number}'] [data-box-type='pnn']").dropzone
		  accept: '[data-box-type="evidence"]'
		  overlap: 0.3
		  ondropactivate: (event) ->
		    # add active dropzone feedback
		    event.target.classList.add 'drop-active'
		  ondragenter: (event) ->
		    draggableElement = event.relatedTarget
		    dropzoneElement = event.target
		    # feedback the possibility of a drop
		    dropzoneElement.classList.add 'drop-target'
		    draggableElement.classList.add 'can-drop'
		    # draggableElement.textContent = 'Dragged in'
		  ondragleave: (event) ->
		    # remove the drop feedback style
		    console.log 'left'
		    event.target.classList.remove 'drop-target'
		    event.relatedTarget.classList.remove 'can-drop'
		    # event.relatedTarget.textContent = 'Dragged out'
		  ondrop: (event) ->
		  	event.target.classList.add event.relatedTarget.getAttribute 'entity-name'
		  	event.relatedTarget.classList.add 'Dropped'

		  	# x = event.dragEvent.dx * -1
		  	console.log event.interaction
		  	x = event.interaction.startCoords.client.x - event.relatedTarget.originalPosX
		  	# # y = event.dragEvent.dy * -1
		  	y = event.interaction.startCoords.client.y - event.relatedTarget.originalPosY
		  	zoom = scroller.getValues().zoom
		  	scroller.zoomTo(1)
		  	event.relatedTarget.style.webkitTransform = event.relatedTarget.style.transform = 'translate(' + x + 'px, ' + y + 'px)'
		  	scroller.zoomTo(zoom)
		  	# # update the posiion attributes
		  	event.relatedTarget.setAttribute 'data-x', x
		  	event.relatedTarget.setAttribute 'data-y', y
		  	# event.draggable.snap({ anchors: [prevLoc] })
		  	# console.log event.target
		  	console.log "Dropped in #{event.target.getAttribute('data-box-category')}"
		  ondropdeactivate: (event) ->
		    # remove active dropzone feedback
		    event.target.classList.remove 'drop-active'
		    event.target.classList.remove 'drop-target'

	setupInteract = (sel)->
		interact("[data-box-type='hypothesis'][data-box-number='#{number}']")
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
		    translateFactor = 1
		    if scroller and scroller.__zoomLevel < 1
		    	translateFactor = 1.5
		    x = (parseFloat(target.getAttribute('data-x')) or 0) + event.dx * translateFactor 
		    y = (parseFloat(target.getAttribute('data-y')) or 0) + event.dy * translateFactor
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

			body = div.append('div').attr 'class', 'panel-body'

			positiveBox = pnnBox().title('Positive').titleClass('panel-info').width(width/2 - 25)
			negativeBox = pnnBox().title('Negative').titleClass('panel-danger left-15').width(width/2 - 25)
			neutralBox = pnnBox().title('Neutral').titleClass('panel-warning').width(width - 35)
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
					'margin-top': '2px'
				.on 'click', (d)->

					if not hideBody
						body
							.style
								display: 'none'
								visibility: 'hidden'
						div
							.style 'height', '43px'

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

			headingButtons.settings = heading
				.append 'i'
				.attr 'class', 'fa fa-cog pull-right'
				.style
					'margin': '2px 5px'

			headingButtons.lineChart = heading
				.append 'i'
				.attr 'class', 'fa fa-line-chart pull-right'
				.style
					'margin': '2px 5px'

			headingButtons.label = heading
				.append 'span'
				.attr 'class', 'label label-danger pull-right'
				.style
					'margin': '2px 5px'
				.text label

			if drag then setupInteract()
			setupDropzone()

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