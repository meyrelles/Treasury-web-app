class Google_synch_a

  require("bundler")
  Bundler.require

  def ws
    begin
      @session ||= GoogleDrive::Session.from_service_account_key("./app/assets/json_files/client_secret.json")
      @spreadsheet ||= @session.spreadsheet_by_key($user_google_key)
      @worksheet ||= @spreadsheet.worksheets[$user_google_sheet_name]
    rescue Exception => e
      x=e.message
    end

  end
end
