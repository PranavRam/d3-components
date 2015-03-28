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

	label = 4
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
		selection.each (data)->
			div = d3.select(this)
				.attr(
					'class', 'panel panel-primary draggable'
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

			headingButtons.label = heading
				.append 'span'
				.attr 'class', 'label label-danger pull-right'
				.style
					'margin-top': '2px'
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

module.exports = evidenceBox