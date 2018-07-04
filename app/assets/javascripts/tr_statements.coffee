# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#Put message in fornt of field when wrong
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

EnableSubmitButton =
  Checking: (array) ->
    i = 0
    k = 0
    fLen = array.length
    while i < fLen
      k = k + array[i]
      i++
    if sessionStorage.getItem('mov_type') is 'exch'
      if k == 9
        document.getElementById("send").disabled = false
    else
      if k == 6
        document.getElementById("send").disabled = false

Update_Field_On_Start =
  From_Coinbag: ->
    #FROM COINBAG CONTROL
    coinbag = $('#tr_statement_coinbag').html()
    if $('#tr_statement_from option:selected').text() == "World"
      $('#field_coinbag_from').hide()
      $('#tr_statement_coinbag').empty()
    else
      $('#field_coinbag_from').show()
      destfrom = $('#tr_statement_from :selected').text()
      options = "<option value=''></option>"
      options = options + $(coinbag).filter("optgroup[label='#{destfrom}']").html()
      if options
        $('#tr_statement_coinbag').html(options)
      else
        $('#tr_statement_coinbag').empty()

  To_Coinbag: ->
    #TO COINBAG CONTROL
    destcoinbags = $('#tr_statement_coinbag_dest').html()
    if $('#tr_statement_to option:selected').text() == "World"
      $('#field_coinbag_to').hide()
      $('#tr_statement_coinbag_dest').empty()
    else
      $('#field_coinbag_to').show()
      destto = $('#tr_statement_to :selected').text()
      options = "<option value=''></option>"
      options = options + $(destcoinbags).filter("optgroup[label='#{destto}']").html()
      if options
        $('#tr_statement_coinbag_dest').html(options)
      else
        $('#tr_statement_coinbag_dest').empty()

jQuery ->
#Form control
  $(document).on 'turbolinks:load', ->
    $('#new_tr').click ->
      sessionStorage.setItem('mov_type', 'tr')
    $('#new_exch').click ->
      sessionStorage.setItem('mov_type', 'exch')

    if $("#tr_type").data("parameter") is 'tr'
      sessionStorage.setItem('mov_type', 'tr')
    if $("#tr_type").data("parameter") is 'exch'
      sessionStorage.setItem('mov_type', 'exch')

    if $("#Trstatementbody").data("controller") == 'tr_statements'
      #alert($("#Trstatementbody").data("controller"))
      array=[]
      array[0]=0

      #document.getElementById('type_parameter').setAttribute('data_parameter',sessionStorage.getItem('mov_type'))

      #jQuery to disable the combobox TO and FROM to avoid errors on transactions
      if sessionStorage.getItem('mov_type') is 'tr'
        document.getElementById("tr_statement_from").disabled = false
        document.getElementById("tr_statement_to").disabled = false
      if sessionStorage.getItem('mov_type') is 'exch'
        document.getElementById("tr_statement_to").disabled = true
        document.getElementById("tr_statement_from").disabled = true

      if $("#type_new").data("parameter") is 'NEW'
        document.getElementById("send").disabled = true
        array = [0,1,0,0,0,0,0,0,0,0]

      if $("#type_new").data("parameter") is 'EDIT'
        array = [0,1,1,1,1,1,1,1,1,1]

      #Enable combox before submit to permit ruby store the user data.
      $('#send').mousedown ->
        document.getElementById("tr_statement_to").disabled = false
        document.getElementById("tr_statement_from").disabled = false

      $('#send').keydown ->
        document.getElementById("tr_statement_to").disabled = false
        document.getElementById("tr_statement_from").disabled = false

      $('#send').keypress ->
        document.getElementById("tr_statement_to").disabled = false
        document.getElementById("tr_statement_from").disabled = false
      #End of Combobox desable

      #REASON FIELD
      $("#tr_statement_detail").blur ->
        if @value.length > 5
          $("#CTR_reason").text("")
          array[2]=1
          #enable submit
          EnableSubmitButton.Checking(array)
        else
          $("#CTR_reason").text("Detail should be great than 5 characters!")
          document.getElementById("send").disabled = true
          array[2]=0

      #TIME ZONE FIELD
      $("#tr_statement_timezone").blur ->
        if @value.length >= 1
          if @value % 1 == 0
            $("#CTR_TZ").text("")
            array[1]=1
            #enable submit
            EnableSubmitButton.Checking(array)
          else
            $("#CTR_TZ").text("Input should be integer!")
            document.getElementById("send").disabled = true
            array[1]=0
        else
          $("#CTR_TZ").text("should have at least 1 digit!")
          document.getElementById("send").disabled = true
          array[1]=0

      #COINBAG FIELD
      $("#tr_statement_coinbag").blur ->
        if @value.length > 0
          $("#CTR_coinbag").text("")
          array[3]=1
          #enable submit
          EnableSubmitButton.Checking(array)
        else
          $("#CTR_coinbag").text("Please select a coinbag!")
          document.getElementById("send").disabled = true
          array[3]=0

      #COINBAG FOR EXCHANGE FIELD
      $("#tr_statement_coinbag_dest").blur ->
        if @value.length > 0
          $("#CTR_coinbag_dest").text("")
          array[4]=1
          #enable submit
          EnableSubmitButton.Checking(array)
        else
          $("#CTR_coinbag_dest").text("Please select a coinbag!")
          document.getElementById("send").disabled = true
          array[4]=0

      #CURRENCY AND AMOUNT FOR EXCHANGE FIELD
      $("#tr_statement_currency").blur ->
        if @value.length > 0
          $("#CTR_currency").text("")
          array[5]=1
          #enable submit
          EnableSubmitButton.Checking(array)
        else
          $("#CTR_currency").text("Please select a currency!  ")
          document.getElementById("send").disabled = true
          array[5]=0

      $("#tr_statement_amount").blur ->
        if !isNaN(@value)
          if @value >= 0 && @value.length > 0
            $("#CTR_amount").text("")
            array[6]=1
            #enable submit
            EnableSubmitButton.Checking(array)
          else
            $("#CTR_amount").text("Amount should be positive value and great or equal 0!")
            document.getElementById("send").disabled = true
            array[6]=0
        else
          $("#CTR_amount").text("Amount should be a number!")
          document.getElementById("send").disabled = true
          array[6]=0

      $("#tr_statement_fee").blur ->
        if !isNaN(@value)
          if @value >= 0 && @value.length > 0
            $("#CTR_fee").text("")
            array[9]=1
            #enable submit
            EnableSubmitButton.Checking(array)
          else
            $("#CTR_fee").text("Fee should be positive value and great or equal 0!")
            document.getElementById("send").disabled = true
            array[9]=0
        else
          $("#CTR_fee").text("Fee should be a number!")
          document.getElementById("send").disabled = true
          array[9]=0

      #CURRENCY AND AMOUNT FOR EXCHANGE FIELD Destination
      $("#tr_statement_currency_dest").blur ->
        if @value.length > 0
          $("#CTR_currency_dest").text("")
          array[7]=1
          #enable submit
          EnableSubmitButton.Checking(array)
        else
          $("#CTR_currency_dest").text("Please select a currency!  ")
          document.getElementById("send").disabled = true
          array[7]=0

      $("#tr_statement_amount_dest").blur ->
        if !isNaN(@value)
          if @value >= 0 && @value.length > 0
            $("#CTR_amount_dest").text("")
            array[8]=1
            #enable submit
            EnableSubmitButton.Checking(array)
          else
            $("#CTR_amount_dest").text("Amount should be positive value and great or equal 0!")
            document.getElementById("send").disabled = true
            array[8]=0
        else
          $("#CTR_amount_dest").text("Amount should be a number!")
          document.getElementById("send").disabled = true
          array[8]=0

      #Dynamic destination coinbag Combobox
      destcoinbags = $('#tr_statement_coinbag_dest').html()
      $('#tr_statement_to').change ->
        if $('#tr_statement_to option:selected').text() == "World"
          $('#field_coinbag_to').hide()
          $('#tr_statement_coinbag_dest').empty()
        else
          $('#field_coinbag_to').show()
          destto = $('#tr_statement_to :selected').text()
          options = "<option value=''></option>"
          options = options + $(destcoinbags).filter("optgroup[label='#{destto}']").html()
          if options
            $('#tr_statement_coinbag_dest').html(options)
          else
            $('#tr_statement_coinbag_dest').empty()

      #Dynamic source coinbag Combobox
      coinbag = $('#tr_statement_coinbag').html()
      $('#tr_statement_from').change ->
        if $('#tr_statement_from option:selected').text() == "World"
          $('#field_coinbag_from').hide()
          $('#tr_statement_coinbag').empty()
        else
          $('#field_coinbag_from').show()
          destfrom = $('#tr_statement_from :selected').text()
          options = "<option value=''></option>"
          options = options + $(coinbag).filter("optgroup[label='#{destfrom}']").html()
          if options
            $('#tr_statement_coinbag').html(options)
          else
            $('#tr_statement_coinbag').empty()

      if sessionStorage.getItem('mov_type') is 'tr'
        Update_Field_On_Start.From_Coinbag()
        Update_Field_On_Start.To_Coinbag()

      #OPEN CATEGORY FORM
      $('#flip').click ->
        $('#panel').slideToggle 'slow'

      $('#catsubmit').click ->
        put_new_cat_to = document.getElementById("tr_statement_classification")
        create_option = document.createElement("option")
        create_option.text = document.getElementById("newCatrgory").value
        create_option.id = 'NEW'
        #Verify if exist in the list
        i = 0
        flag = 0
        while i < document.getElementById("tr_statement_classification").options.length - 1
          if document.getElementById("tr_statement_classification").options[i].text == create_option.text
            alert('Category already exist in categories tables, change your input.')
            flag = 1
          i++

        if flag == 0
          #Generate id key
          text = ''
          possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
          i = 0
          while i < 15
            text += possible.charAt(Math.floor(Math.random() * possible.length))
            i++
          create_option.value = text
          #set values to array to insert in the controller
          array_id = []
          array_category = []

          #clear the form field
          document.getElementById("newCatrgory").value = ""

          put_new_cat_to.add(create_option)
          #send data to array
          i=0
          while i < document.getElementById("tr_statement_classification").options.length
            if document.getElementById("tr_statement_classification").options[i].id == 'NEW'
              array_id[array_id.length] = document.getElementById("tr_statement_classification").options[i].value
              array_category[array_category.length] = document.getElementById("tr_statement_classification").options[i].text
            i++
          #put data in form hidden field to psend to controller
          $("#tr_statement_array_id").val(array_id)
          $("#tr_statement_array_category").val(array_category)

          $('#panel').slideToggle 'slow'



      #CALENDAR CONTROLLER
      $('[data-behaviour~=datepicker]').datepicker
        format: 'yyyy-mm-dd'
        maxViewMode: 2
        todayHighlight: true
        orientation: 'bottom left'
        todayBtn: 'linked'
        autoclose: true

      #FORMAT COMBOBOX CURRENCIES DEFAULTS
      k=0
      $('#tr_statement_currency').ready ->
        while k < document.getElementById("tr_statement_currency").options.length - 1
          if document.getElementById("tr_statement_currency").options[k].text.substring(0, 1) == '*'
            texto = document.getElementById("tr_statement_currency").options[k].text.substring(1, 100)
            document.getElementById("tr_statement_currency").options[k].text = texto
            document.getElementById("tr_statement_currency").options[k].id = 'default_atr'
          k++
      k=0
      if sessionStorage.getItem('mov_type') is 'exch'
        $('#tr_statement_currency_dest').ready ->
        while k < document.getElementById("tr_statement_currency_dest").options.length - 1
          if document.getElementById("tr_statement_currency_dest").options[k].text.substring(0, 1) == '*'
            texto = document.getElementById("tr_statement_currency_dest").options[k].text.substring(1, 100)
            document.getElementById("tr_statement_currency_dest").options[k].text = texto
            document.getElementById("tr_statement_currency_dest").options[k].id = 'default_atr'
          k++

      #FORMAT COMBOBOX CLASSIFICATIONS(CATEGORIES) DEFAULTS
      k=0
      $('#tr_statement_classification').ready ->
        while k < document.getElementById("tr_statement_classification").options.length
          if document.getElementById("tr_statement_classification").options[k].text.substring(0, 1) == '*'
            texto = document.getElementById("tr_statement_classification").options[k].text.substring(1, 100)
            document.getElementById("tr_statement_classification").options[k].text = texto
            document.getElementById("tr_statement_classification").options[k].id = 'default_atr'
          k++
