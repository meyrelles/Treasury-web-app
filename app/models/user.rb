class User
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps
  has_many :coinbag

  before_save { self.email = email.downcase }
  validates :password_digest,  presence: true, length: { minimum: 8 }
  validates :username,  presence: true, length: { minimum: 5, maximum: 20 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,  presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true
  validates :nickname,  presence: true, uniqueness: true

  field :username, :type => String
  field :password_digest, :type => String
  field :surname, :type => String
  field :givenname, :type => String
  field :nickname, :type => String
  field :birthdate_time, :type => Time
  field :email, :type => String
  field :spreadsheet_link, :type => String
  field :sheet_name, :type => String

  #has_secure_password
end
