// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

// Function to disable the combobox TO in new transactions type Receipt to avoid errors
function disable_tr_statement_to() {
    var type = location.search.split('type=')[1]
    type = type.substr(0, 3)
    if (type == "rec") {
      document.getElementById("tr_statement_to").disabled = true;
    }
}
