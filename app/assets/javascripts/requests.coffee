# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:load', ->

  show = false

  $('#import').click ->
    if show == false
      $('.hiddenAction').slideDown 100
      show = true
    else
      $('.hiddenAction').slideUp 100
      show = false
    return
  return
