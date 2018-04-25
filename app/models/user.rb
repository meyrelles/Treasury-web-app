class User
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :username, :type => String
  field :password, :type => String
  field :surname, :type => String
  field :givenname, :type => String
  field :nickname, :type => String
  field :birthdate_time, :type => Time
  field :email, :type => String
  field :spreadsheet_link, :type => String
end
