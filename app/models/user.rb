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
  #validates :status,  presence: true

  def email=(value)
    super(value.strip.downcase)
  end

  field :username, :type => String, :index => true, :uniq => true
  field :password_digest, :type => String, :required => true
  field :surname, :type => String, :required => true
  field :givenname, :type => String, :required => true
  field :nickname, :type => String, :uniq => true, :required => true
  field :birthdate_time, :type => Time
  field :email, :type => String, :uniq => true, :required => true
  field :spreadsheet_link, :type => String
  field :sheet_name, :type => String
  field :verified, :type => Boolean 
  field :admin, :type => Boolean #User is app administrator?
  field :group, :type => String, :required => true #used to define users and teams
  field :status, :type => String, :required => true #Status of user in app
  field :profile, :type => String, :required => true #Used to create users group on app

  #has_secure_password
end
