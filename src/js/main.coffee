sliderControl = require './sliderControl'
labColorPicker = require './labColorPicker'
evidenceBox = require './evidenceBox'
hypothesisBox = require './hypothesisBox'

width = 600
height = 60
margin = 20
offset = 30
###
svg = d3.select '#chart'
		.append 'svg'
		.attr
			width: width + 2*margin
			height: height + 3*margin

value = 70
domain = [0, 100]

cScale = d3.scale.linear()
					.domain domain
					.range ['#edd400', '#a40000']

rectangle = svg.append 'rect'
						.attr
							x: margin
							y: margin*2
							width: width
							height: height
							fill: cScale(value)

slider = sliderControl()
					.onSlide (selection)->
						selection.each (data)->
							rectangle.attr 'fill', cScale(data)

gSlider = svg.selectAll 'g'
						.data [value]
						.enter().append 'g'
						.attr
							transform: "translate(#{[margin,height/2]})"
						.call slider
						###

svg = d3.select '#chart'
				.append 'svg'
				.attr
					width: width
					height: height

picker = labColorPicker()
					.color '#a40000'

group = svg.append 'g'
					.attr
						transform: "translate(#{[offset, offset]})"
					.call picker

eBox = evidenceBox()
hBox = hypothesisBox()

box1 = d3.select '#evidence'
					.data [0]
					.call eBox

box2 = d3.select '#hypothesis'
					.data [0]
					.call hBox

setupDropzoneForEvidences = ->
	interact("[data-box-type='evidence']").dropzone
	  accept: '[data-type="entity"]'
	  overlap: 0.1
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
	  	x = event.interaction.startCoords.client.x - event.relatedTarget.originalPosX
	  	# x = event.interaction.startCoords.client.x - event.relatedTarget.offsetLeft
	  	# # y = event.dragEvent.dy * -1
	  	y = event.interaction.startCoords.client.y - event.relatedTarget.originalPosY
	  	# y = event.interaction.startCoords.client.y - event.relatedTarget.offsetTop - 10
	  	event.relatedTarget.style.webkitTransform = event.relatedTarget.style.transform = 'translate(' + x + 'px, ' + y + 'px)'
	  	# # update the posiion attributes
	  	event.relatedTarget.setAttribute 'data-x', x
	  	event.relatedTarget.setAttribute 'data-y', y
	  	# event.draggable.snap({ anchors: [prevLoc] })
	  	alert "added #{event.relatedTarget.getAttribute('entity-name')}"
	  	console.log event
	  ondropdeactivate: (event) ->
	    # remove active dropzone feedback
	    event.target.classList.remove 'drop-active'
	    event.target.classList.remove 'drop-target'

setupDropzoneForHypothesesPNN =  ->
	interact("[data-box-type='hypothesis'] [data-box-type='pnn']").dropzone
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
	  	# box = d3.select "[data-box-type='hypothesis'][data-parent-box='#{event.target.getAttribute('data-parent-box')}']"
	  	box = d3.select event.target
	  						.selectAll 'div.evidence'
	  	data = box
	  						.data()
	  	data.push 'Evidence 20'

	  	console.log box, data
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
	  	alert "Dropped #{event.relatedTarget.getAttribute('data-box-type')} in #{event.target.getAttribute('data-box-category')} under Hypothesis#{event.target.getAttribute('data-parent-box')}"
	  ondropdeactivate: (event) ->
	    # remove active dropzone feedback
	    event.target.classList.remove 'drop-active'
	    event.target.classList.remove 'drop-target'

setupDragForHypotheses = (sel)->
	interact("[data-box-type='hypothesis']")
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

setupDragForEvidences = ->
	interact("[data-box-type='evidence']")
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
	.on 'dragstart', (event)->
		console.log event
		event.target.originalPosX ||= event.pageX
		event.target.originalPosY ||= event.pageY

interact('.draggable.entity')
	.draggable
	  inertia: true
	  restrict:
	    # restriction: 'parent'
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
	    return
	  onend: (event) ->
	    textEl = event.target.querySelector('p')
	    # textEl and (textEl.textContent = 'moved a distance of ' + (Math.sqrt(event.dx * event.dx + event.dy * event.dy) | 0) + 'px')
	    return
  .on 'dragstart', (event)->
  	console.log event
  	event.target.originalPosX ||= event.pageX
  	event.target.originalPosY ||= event.pageY
  	# window.prevCoords = {}
  	# window.prevCoords =
  	# 	x : event.pageX - event.target.originalPosX
  	# 	y : event.pageY - event.target.originalPosY


setupDragForEvidences()
setupDragForHypotheses()
setupDropzoneForEvidences()
setupDropzoneForHypothesesPNN()

window.contentWidth = 2000
window.contentHeight = 2000

# Initialize layout
container = document.getElementById('container')
content = document.getElementById('content')
content.style.width = contentWidth + 'px'
content.style.height = contentHeight + 'px'