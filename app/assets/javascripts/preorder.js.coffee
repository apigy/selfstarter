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
    checkoutOffset = $('body').height() - 101 #needs to be done upon init
    $("#email").bind "textchange", ->
      Selfstarter.validateEmail()
    $("#email").bind "hastext", ->
      Selfstarter.validateEmail()
    # The first time they type in their email, we don't want it to throw a validation error
    $("#email").change ->
      Selfstarter.firstTime = false

    # if they are using the optional payment options section on the checkout page, need to conditional fix the email
    # field and button to the bottom of the page so it's displayed after selecting a radio button
    if $('.payment_options').length > 0
      onScroll = () ->
        wrapper = $('.checkout_controls_wrapper')
        if $(window).scrollTop() + $(window).height() < checkoutOffset
          wrapper.addClass('fix_to_bottom')
        else if wrapper.hasClass("fix_to_bottom")
          wrapper.removeClass('fix_to_bottom')

      $(window).on "scroll", ->
        onScroll()

      # the radio button selection should bring up the email field and button
      $('.payment_radio').on "click", ->
        onScroll()
        $('.checkout_controls_wrapper').addClass "checkout_ready"
$ ->
  Selfstarter.init()
  $("#email").focus() if $('.payment_options').length == 0
