# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#Put message in fornt of field when wrong

jQuery ->
#Form control
  $(document).on 'turbolinks:load', ->
    if $("#Stettingsbody").data("controller") == 'settings'
      password = document.getElementById("psw")
      confirm = document.getElementById("confirm")

      document.getElementById("change_pass").disabled = true

      $("#confirm").blur ->
        lowerCaseLetters = /[a-z]/g
        upperCaseLetters = /[A-Z]/g
        numbers = /[0-9]/g

        #alert(document.getElementById("psw").childNodes[0].textContent)
        if password.value == confirm.value && myInput.value.length >= 8 &&  myInput.value.match(numbers) && myInput.value.match(upperCaseLetters) && myInput.value.match(lowerCaseLetters)
          document.getElementById("change_pass").disabled = false
        else
          document.getElementById("change_pass").disabled = true
