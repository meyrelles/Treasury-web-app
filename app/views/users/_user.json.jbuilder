json.extract! user, :id, :username, :password_digest, :surname, :givenname, :nickname, :birthdate_time, :spreadsheet_link, :created_at, :updated_at
json.url user_url(user, format: :json)
