# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

format = (d) ->
  # `d` is the original data object for the row
  '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">' + '<tr>' + '<td>Full name:</td>' + '<td>' + d.surname + ', ' + d.givenname + '</td>' + '</tr>' + '<tr>' + '<td>Status:</td>' + '<td>' + d.status   + '</td>' + '</tr>' + '<tr>' +
  '<td>Kind of user:</td>' + '<td>' + d.group + '</td>' + '</tr>' + '<tr>' + '<td>User profile:</td>' + '<td>' + d.profile + '</td>' + '</tr>' + '</table>'

jQuery ->
  $(document).ready ->
    $(document).on 'turbolinks:load', ->
      table = $('#users').DataTable (
        sPaginationType: "full_numbers"
        bProcessing: true
        bServerSide: true
        sAjaxSource: $('#users').data('source')
        columnDefs: [ {
          targets: 6
          render: (url, type, full, row, data) ->
            '<a data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="/users/' + full.id1 + '"><img src="assets/delete.ico" height="20px" width="20px" title="Delete user" alt="Delete"></a>'
          }
          {
          targets: 5
          render: (url, type, full, row, data) ->
            '<a href="/users/' + full.id2 + '/edit"><img src="assets/edit.ico" height="20px" width="20px" title="Edit user" alt="Edit"></a>'
        } ]
        columns: [
          {
            'className': 'details-control'
            'orderable': false
            'data': null
            'defaultContent': ''
          }
          { 'data': 'username' }
          { 'data': 'nickname' }
          { 'data': 'email' }
          { 'data': 'status' }
          { 'data': 'id1' }
          { 'data': 'id2' }
        ]
        'order': [ [
          1
          'asc'
          ] ]
        )

      # Add event listener for opening and closing details
      $('#users tbody').on 'click', 'td.details-control', ->
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
