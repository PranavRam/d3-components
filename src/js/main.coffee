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