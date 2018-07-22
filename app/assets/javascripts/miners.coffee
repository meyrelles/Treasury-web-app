# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

refreshChart = ->
  if $("#chartdata").data("parameter") != ""
    chart = Chartkick.charts['chart-id2']
    chart.updateData [{name: "Real Time", data: $("#chartdata").data("parameter")}, {name: "5 minutes", data: $("#chartdata2").data("parameter")}]

    chart3 = Chartkick.charts['chart-id3']
    chart3.updateData [{name: "60 Minutes", data: $("#chartdata3").data("parameter")}]

    chart3 = Chartkick.charts['chart-payments']
    chart3.updateData [{name: "Ppayments", data: $("#chartpayments").data("parameter")}]

    setTimeout refreshChart, 30000

executeQuery = ->
  $.ajax success: (data) ->
    $('#dynamicLoadingPanel').load '/miners #dynamicLoadingPanel'
    setTimeout executeQuery, 30000


jQuery ->
#Form control
  $(document).on 'turbolinks:load', ->
    if $("#Stettingsbody").data("controller") == 'miners'
      $(document).ready ->
        setTimeout executeQuery, 10000
        setTimeout refreshChart, 30000
        #setTimeout refreshChart2, 10000
