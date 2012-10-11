Selfstarter =
	firstTime: true
	validateEmail: ->
		# The regex we use for validating email
		# It probably should be a parser, but there isn't enough time for that (Maybe in the future though!)
		if /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/.test($("#email").val())
			$("#email").removeClass("highlight")
			$("#amazon_button").removeClass("disabled")
		else
			$("#email").addClass("highlight") unless Selfstarter.firstTime
			$("#amazon_button").addClass("disabled") unless $("#amazon_button").hasClass("disabled")
	init: ->
		$("#email").bind "textchange", ->
			Selfstarter.validateEmail()
		$("#email").bind "hastext", ->
			Selfstarter.validateEmail()
		# The first time they type in their email, we don't want it to throw a validation error
		$("#email").change ->
			Selfstarter.firstTime = false
$ ->
	Selfstarter.init()
	$("#email").focus()
		


	
		

