# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#Put message in fornt of field when wrong

jQuery ->
#Form control
  $(document).on 'turbolinks:load', ->
    if $("#Settingsbody").data("controller") == 'settings'

      #PASSWORD SCRIPT BLOCK
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

      #Password controlle
      myInput = document.getElementById('psw')
      letter = document.getElementById('letter')
      capital = document.getElementById('capital')
      number = document.getElementById('number')
      length = document.getElementById('length')
      # When the user clicks on the password field, show the message box

      myInput.onfocus = ->
        document.getElementById('message').style.display = 'block'
        #return

      # When the user clicks outside of the password field, hide the message box

      myInput.onblur = ->
        document.getElementById('message').style.display = 'none'
        #return

      # When the user starts to type something inside the password field

      myInput.onkeyup = ->
        # Validate lowercase letters
        lowerCaseLetters = /[a-z]/g
        if myInput.value.match(lowerCaseLetters)
          letter.classList.remove 'invalid'
          letter.classList.add 'valid'
        else
          letter.classList.remove 'valid'
          letter.classList.add 'invalid'
        # Validate capital letters
        upperCaseLetters = /[A-Z]/g
        if myInput.value.match(upperCaseLetters)
          capital.classList.remove 'invalid'
          capital.classList.add 'valid'
        else
          capital.classList.remove 'valid'
          capital.classList.add 'invalid'
        # Validate numbers
        numbers = /[0-9]/g
        if myInput.value.match(numbers)
          number.classList.remove 'invalid'
          number.classList.add 'valid'
        else
          number.classList.remove 'valid'
          number.classList.add 'invalid'
        # Validate length
        if myInput.value.length >= 8
          length.classList.remove 'invalid'
          length.classList.add 'valid'
        else
          length.classList.remove 'valid'
          length.classList.add 'invalid'

      #END PASSWORD SCRIPT BLOCK


      # ---- /// ----  NEW BLOCK  ---- /// ----


      #CURRENCIES DEFAULT BLOCK
