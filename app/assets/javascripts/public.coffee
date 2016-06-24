# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:load', ->

  $('#showGroups').click ->
    $('.groupsList').animate 'right': '70%'
    $('.groupsList .button').animate 'right': '73%'
    $('html').animate 'scrollTop': '0px'
    return

  $('#close').click ->
    $('.groupsList').animate 'right': '100%'
    $('.groupsList .button').animate 'right': '100%'
    return

  return
