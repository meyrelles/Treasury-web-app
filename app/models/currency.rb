class Currency
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :currency, :type => String
  field :created_at, :type => Time
  field :created_by, :type => String
  field :changed_at, :type => Time
  field :changed_by, :type => String

  #has_many :currency_defaults
end
