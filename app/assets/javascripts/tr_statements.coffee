# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

format = (d) ->
  # `d` is the original data object for the row
  '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">' + '<tr>' + '<td>Detail:</td>' + '<td>' + d.detail + '</td>' +
  '</tr>' + '<tr>' + '<td>Currency to:</td>' + '<td>' + d.currency_dest + '</td>' + '</tr>' + '</tr>' + '<tr>' + '<td>Coinbag from:</td>' + '<td>' + d.coinbag + '</td>' +
  '</tr>' + '<tr>' + '<td>Coinbag to:</td>' + '<td>' + d.coinbag_dest + '</td>' +
  '</tr>' + '<tr>' + '<td>Amount to:</td>' + '<td>' + d.amount_dest + '</td>' +
  '</tr>' + '<tr>' + '<td>Celebrate:</td>' + '<td>' + d.celebrate + '</td>' +
  '</tr>' + '<tr>' + '<td>Hash:</td>' + '<td>' + d.hash + '</td>' +
  '</tr>' + '</tr>' + '<tr>' + '<td>Author:</td>' + '<td>' + d.author + '</td>' + '</tr>' + '</table>'

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

GetCoinbagStatus = ->
  e = document.getElementById("transaction_coinbag")
  return e.options[e.selectedIndex].value

GetCurrencyStatus = ->
  e = document.getElementById("transaction_currency")
  return e.options[e.selectedIndex].value

GetUserStatus = ->
  e = document.getElementById("transaction_user")
  return e.options[e.selectedIndex].value

GetCategoryStatus = ->
  e = document.getElementById("transaction_classification")
  return e.options[e.selectedIndex].value

GetAuthorStatus = ->
  e = document.getElementById("transaction_author")
  return e.options[e.selectedIndex].value

UpdateDate = ->
  dt = new Date()
  df = new Date(dt)

  df.setDate(df.getDate() - 60)

  dateEnd = dt.getFullYear() + "-" + ("0" + (dt.getMonth() + 1)).slice(-2) + "-" + ("0" + dt.getDate()).slice(-2)
  dateIni = df.getFullYear() + "-" + ("0" + (df.getMonth() - 1)).slice(-2) + "-" + ("0" + df.getDate()).slice(-2)

  $("#date_to").val(dateEnd)
  $("#date_from").val(dateIni)

jQuery ->
#Form control
  $(document).on 'turbolinks:load', ->

    UpdateDate()

    $("#transactions").append('<tfoot><tr id="foot"><th></th><th></th><th></th><th></th><th></th><th style="max-width:5px;">PAGE TOTAL:</th><th style="background:#a1eaed;color:black;max-width:5px;"></th><th></th><th></th>');

    $("#transaction_user").change ->
      table = window.$('#transactions').DataTable()
      table.draw()
    $("#transaction_coinbag").change ->
      table = window.$('#transactions').DataTable()
      table.draw()
    $("#transaction_currency").change ->
      table = window.$('#transactions').DataTable()
      table.draw()
    $("#transaction_classification").change ->
      table = window.$('#transactions').DataTable()
      table.draw()
    $("#transaction_author").change ->
      table = window.$('#transactions').DataTable()
      table.draw()

    #CALENDAR CONTROLLER
    $('[data-behaviour~=datepicker]').datepicker
      format: 'yyyy-mm-dd'
      maxViewMode: 2
      todayHighlight: true
      orientation: 'bottom left'
      todayBtn: 'linked'
      autoclose: true

    table = $('#transactions').DataTable (
      sPaginationType: "full_numbers"
      responsive: true
      bFilter: true
      bProcessing: true
      bServerSide: true
      drawCallback: (settings) ->
        total = 0
        api = this.api()
        sum = api.column(6, page: 'all').data().sum()
        $(api.column(6).footer()).html(Math.round(sum * 100)/100)

      #scrollY:        '800px'
      #scrollX:        true
      #scrollCollapse: true
      #paging:         true
      #fixedColumns:   true
      stateSave:      true
      order: [ 1, 'asc' ]
      #jQueryUI: true
      #sDom: 'lfBtip'
      #buttons:
      sAjaxSource: $('#transactions').data('source')
      columnDefs: [ {
        targets: 8
        render: (url, type, full, row, data) ->
          if (full.session_id == full.from_id or full.session_id == full.to_id or full.session_id == full.created_by)
            '<a data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="/tr_statements/' + full.id + '"><img src="assets/delete.ico" height="20px" width="20px" title="Delete transaction" alt="Delete"></a>'
          else
            '<a><img src="assets/delete_disabled.ico" height="20px" width="20px" title="No permissions to delete transaction" alt="Delete"></a>'
        }
        {
        targets: 7
        render: (url, type, full, row, data) ->
          if (full.session_id == full.from_id or full.session_id == full.to_id or full.session_id == full.created_by)
            '<a href="/tr_statements/' + full.id + '/edit?type=' + full.mov_type + '&usr=' + full.session_id + '"><img src="assets/edit.ico" height="20px" width="20px" title="Edit transaction" alt="Edit"></a>'
          else
            '<a><img src="assets/edit_disabled.ico" height="20px" width="20px" title="No permissions to edit transaction" alt="Edit"></a>'
      } ]
      columns: [
        {
          'className': 'details-control'
          'orderable': false
          'data': null
          'defaultContent': ''
        }
        {
        data: 'date_time'
        render: (data, type, row) ->
          dt = new Date(data)
          d = "0" + dt.getDate()
          d = d.substr(d.length - 2 , 2)
          m = "0" + (dt.getMonth() + 1)
          m = m.substr(m.length - 2 , 2)
          y = dt.getFullYear()
          dt = d + "-" + m + "-" + y
           #$("#txtDate").val($.format.date(new Date(), 'dd M yy'));
          #dt.toDateString()

        }
        { data: 'classification' }
        { data: 'from' }
        { data: 'to' }
        { data: 'currency' }
        { data: 'amount' }
        { data: 'id' }
        { data: 'id' }
      ]
      fnServerParams: (aoData) ->
        aoData.push {
          'name': 'coinbag'
          'value': GetCoinbagStatus()
          },{
          'name': 'currency'
          'value': GetCurrencyStatus()
          },{
          'name': 'user'
          'value': GetUserStatus()
          },{
          'name': 'author'
          'value': GetAuthorStatus()
          },{
          'name': 'category'
          'value': GetCategoryStatus()
          },{
          'name': 'datefrom'
          'value': document.getElementById("date_from").value
          },{
          'name': 'dateto'
          'value': document.getElementById("date_to").value
          },{
          'name': 'amountfrom'
          'value': document.getElementById("amount_from").value
          },{
          'name': 'amountto'
          'value': document.getElementById("amount_to").value
          }
      #sDom: 'f<"#reset">irt',
      sDom: '<"toolbar">frtip' +
        "<'row'<'col-sm-12 col-md-6'l>>" +
        "<'row'<'col-sm-12'tr>>" +
        "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>"
      buttons: [
            "Search"
            "excel"
            "pdf"
        ]
      )

    #alert($.param(dtIni))

    $('div.toolbar').html'<table id="temporary" style="display:none;"></table>'
    #table.buttons()
    #  .container()
    #  .appendTo( $("#myTableButtons", table.table().container() ) );

    # Add event listener for opening and closing details
    $('#transactions tbody').on 'click', 'td.details-control', ->
      tr = $(this).closest('tr')
      row = table.row(tr)
      if row.child.isShown()
        # This row is already open - close it
        row.child.hide()
        tr.removeClass 'shown'
      else
        # Open this row
        row.child(format(row.data())).show()
        tr.addClass 'shown'




    $('#new_tr').click ->
      sessionStorage.setItem('mov_type', 'tr')
    $('#new_exch').click ->
      sessionStorage.setItem('mov_type', 'exch')

    if $("#tr_type").data("parameter") is 'tr'
      sessionStorage.setItem('mov_type', 'tr')
    if $("#tr_type").data("parameter") is 'exch'
      sessionStorage.setItem('mov_type', 'exch')

    if $("#Trstatementbody").data("controller") == 'tr_statements'

      array=[]
      array[0]=0

      #jQuery to disable the combobox TO and FROM to avoid errors on transactions
      if sessionStorage.getItem('mov_type') is 'tr'
        document.getElementById("tr_statement_from").disabled = false
        document.getElementById("tr_statement_to").disabled = false
      if sessionStorage.getItem('mov_type') is 'exch'
        document.getElementById("tr_statement_to").disabled = true
        document.getElementById("tr_statement_from").disabled = true

      if $("#type_new").data("parameter") is 'NEW'
        document.getElementById("send").disabled = true
        array = [0,1,0,0,0,0,0,0,0,1]

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
        if @value.length >= 1
          $("#CTR_reason").text("")
          array[2]=1
        else
          $("#CTR_reason").text("Detail should be great than 1 characters!")
          document.getElementById("send").disabled = true
          array[2]=0
        #enable submit
        EnableSubmitButton.Checking(array)        

      #TIME ZONE FIELD
      $("#tr_statement_timezone").blur ->
        if @value.length >= 1
          if @value % 1 == 0
            $("#CTR_TZ").text("")
            array[1]=1
          else
            $("#CTR_TZ").text("Input should be integer!")
            document.getElementById("send").disabled = true
            array[1]=0
        else
          $("#CTR_TZ").text("should have at least 1 digit!")
          document.getElementById("send").disabled = true
          array[1]=0
        #enable submit
        EnableSubmitButton.Checking(array)

      #COINBAG FIELD
      $("#tr_statement_coinbag").blur ->
        if @value.length > 0
          $("#CTR_coinbag").text("")
          array[3]=1
        else
          $("#CTR_coinbag").text("Please select a coinbag!")
          document.getElementById("send").disabled = true
          array[3]=0
        #enable submit
        EnableSubmitButton.Checking(array)

      #COINBAG FOR EXCHANGE FIELD
      $("#tr_statement_coinbag_dest").blur ->
        if @value.length > 0
          $("#CTR_coinbag_dest").text("")
          array[4]=1
        else
          $("#CTR_coinbag_dest").text("Please select a coinbag!")
          document.getElementById("send").disabled = true
          array[4]=0
        #enable submit
        EnableSubmitButton.Checking(array)

      #CURRENCY AND AMOUNT FOR EXCHANGE FIELD
      $("#tr_statement_currency").blur ->
        if @value.length > 0
          $("#CTR_currency").text("")
          array[5]=1
        else
          $("#CTR_currency").text("Please select a currency!  ")
          document.getElementById("send").disabled = true
          array[5]=0
        #enable submit
        EnableSubmitButton.Checking(array)

      $("#tr_statement_amount").blur ->
        if !isNaN(@value)
          if @value >= 0 && @value.length > 0
            $("#CTR_amount").text("")
            array[6]=1
          else
            $("#CTR_amount").text("Amount should be positive value and great or equal 0!")
            document.getElementById("send").disabled = true
            array[6]=0
        else
          $("#CTR_amount").text("Amount should be a number!")
          document.getElementById("send").disabled = true
          array[6]=0
        #enable submit
        EnableSubmitButton.Checking(array)

      $("#tr_statement_fee").blur ->
        if !isNaN(@value)
          if @value >= 0 && @value.length > 0
            $("#CTR_fee").text("")
            array[9]=1
          else
            $("#CTR_fee").text("Fee should be positive value and great or equal 0!")
            document.getElementById("send").disabled = true
            array[9]=0
        else
          $("#CTR_fee").text("Fee should be a number!")
          document.getElementById("send").disabled = true
          array[9]=0
        #enable submit
        EnableSubmitButton.Checking(array)

      #CURRENCY AND AMOUNT FOR EXCHANGE FIELD Destination
      $("#tr_statement_currency_dest").blur ->
        if @value.length > 0
          $("#CTR_currency_dest").text("")
          array[7]=1
        else
          $("#CTR_currency_dest").text("Please select a currency!  ")
          document.getElementById("send").disabled = true
          array[7]=0
        #enable submit
        EnableSubmitButton.Checking(array)

      $("#tr_statement_amount_dest").blur ->
        if !isNaN(@value)
          if @value >= 0 && @value.length > 0
            $("#CTR_amount_dest").text("")
            array[8]=1
          else
            $("#CTR_amount_dest").text("Amount should be positive value and great or equal 0!")
            document.getElementById("send").disabled = true
            array[8]=0
        else
          $("#CTR_amount_dest").text("Amount should be a number!")
          document.getElementById("send").disabled = true
          array[8]=0
        #enable submit
        EnableSubmitButton.Checking(array)

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

      #FORMAT COMBOBOX CURRENCIES DEFAULTS
      k=0
      $('#tr_statement_currency').ready ->
        while k < document.getElementById("tr_statement_currency").options.length - 1
          if document.getElementById("tr_statement_currency").options[k].text.substring(0, 1) == '*'
            texto = document.getElementById("tr_statement_currency").options[k].text.substring(2, 100) + ' *'
            document.getElementById("tr_statement_currency").options[k].text = texto
            document.getElementById("tr_statement_currency").options[k].id = 'default_atr'
          k++
      k=0
      if sessionStorage.getItem('mov_type') is 'exch'
        $('#tr_statement_currency_dest').ready ->
        while k < document.getElementById("tr_statement_currency_dest").options.length - 1
          if document.getElementById("tr_statement_currency_dest").options[k].text.substring(0, 1) == '*'
            texto = document.getElementById("tr_statement_currency_dest").options[k].text.substring(2, 100) + ' *'
            document.getElementById("tr_statement_currency_dest").options[k].text = texto
            document.getElementById("tr_statement_currency_dest").options[k].id = 'default_atr'
          k++

      #FORMAT COMBOBOX CLASSIFICATIONS(CATEGORIES) DEFAULTS
      k=0
      $('#tr_statement_classification').ready ->
        while k < document.getElementById("tr_statement_classification").options.length
          if document.getElementById("tr_statement_classification").options[k].text.substring(0, 1) == '*'
            texto = document.getElementById("tr_statement_classification").options[k].text.substring(2, 100) + ' *'
            document.getElementById("tr_statement_classification").options[k].text = texto
            document.getElementById("tr_statement_classification").options[k].id = 'default_atr'
          k++
