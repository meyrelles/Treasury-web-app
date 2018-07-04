class CurrencyDefault
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :currency, :type => String
  field :user_id, :type => String
  field :created_at, :type => Time
  field :created_by, :type => String
  field :currency_id, :type => String

  #belongs_to :currency
end
