class Google_synch_a

  require("bundler")
  Bundler.require

  def ws
    begin
      #Need to change when uplaod to webserver
      @session ||= GoogleDrive::Session.from_service_account_key("c:/Ruby25-x64/app/json_files/client_secret.json")

      @spreadsheet ||= @session.spreadsheet_by_key($user_google_key)
      @worksheet ||= @spreadsheet.worksheet_by_title($user_google_sheet_name)
    rescue Exception => e
      x=e.message
    end

  end
end
