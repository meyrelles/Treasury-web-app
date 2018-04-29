# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#Example to put message in fornt of field when wrong
ValidateNumber =
  cleanNumber: (number) -> number.replace /[- ]/g, ""

  validNumber: (number) ->
    total = 0
    number = @cleanNumber(number)
    for i in [(number.length-1)..0]
      n = +number[i]
      if (i+number.length) % 2 == 0
        n = if n*2 > 9 then n*2 - 9 else n*2
      total += n
    total % 10 == 0

#Shoud use 'turbolinks:load' to avoid manualy refresh the webpage
$(document).on 'turbolinks:load', ->
  $("#tr_statement_classification").blur ->
    if ValidateNumber.validNumber(@value)
      $("#description_error").text("")
    else
      $("#description_error").text("    Invalid number")
#END OF Example

#jQuery to desable the combobox TO and FROM to avoid errors on transactions
  $('#tr_statement_to').hover ->
    if $("#type_parameter").data("parameter") is 'rec'
      document.getElementById("tr_statement_to").disabled = true

  $('#tr_statement_from').hover ->
    if $("#type_parameter").data("parameter") is 'pay'
      document.getElementById("tr_statement_from").disabled = true

  $('#tr_statement_to').hover ->
    if $("#type_parameter").data("parameter") is 'exch'
      document.getElementById("tr_statement_to").disabled = true

  $('#tr_statement_from').hover ->
    if $("#type_parameter").data("parameter") is 'exch'
      document.getElementById("tr_statement_from").disabled = true

  $('#tr_statement_to').keydown ->
    if $("#type_parameter").data("parameter") is 'rec'
      document.getElementById("tr_statement_to").disabled = true

  $('#tr_statement_from').keydown ->
    if $("#type_parameter").data("parameter") is 'pay'
      document.getElementById("tr_statement_from").disabled = true

  $('#tr_statement_to').keydown ->
    if $("#type_parameter").data("parameter") is 'exch'
      document.getElementById("tr_statement_to").disabled = true

  $('#tr_statement_from').keydown ->
    if $("#type_parameter").data("parameter") is 'exch'
      document.getElementById("tr_statement_from").disabled = true
#End of Combobox desable
