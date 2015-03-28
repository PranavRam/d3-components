pnnBox = require './pnnBox'

hypothesisBox = ->
	width = 350
	height = 400
	number = 0
	title = 'Anand Framed Roger Rabbit'
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
	hideBody = false
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
			div = d3.select(this)
				.attr(
					'class', 'panel panel-info draggable'
					'data-box-type': 'hypothesis'
					'data-box-number': number)

			div
				.style
					width: width+'px'
					# height: height+'px'

			heading = div.append('div').attr 'class', 'panel-heading'

			heading.text title

			body = div.append('div').attr 'class', 'panel-body'

			positiveBox = pnnBox().title('Positive').titleClass('panel-info')
			negativeBox = pnnBox().title('Negative').titleClass('panel-danger')
			neutralBox = pnnBox().title('Neutral').titleClass('panel-warning')
			# negativeBox = hypothesisBox().title('Negative')
			# neutralBox = hypothesisBox().title('Neutral')
			positiveDiv = body
									.append('div')
									.call positiveBox

			negativeDiv = body
									.append('div')
									.call negativeBox

			neutralDiv = body
									.append('div')
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