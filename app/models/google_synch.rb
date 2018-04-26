class Google_synch

  require("bundler")
  Bundler.require

  def worksheet
    #connect to google spreadsheet
    @session ||= GoogleDrive::Session.from_service_account_key("./app/assets/json_files/client_secret.json")
    @spreadsheet ||= @session.spreadsheet_by_key("19jjPEid0fhzkx4iwYX52e_Y9Pj8JKkX76I7yB0jKp0I")
    @worksheet ||= @spreadsheet.worksheets[1]
  end

end
