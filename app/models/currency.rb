class Currency
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :currency, :type => String, :index => true, :uniq => true
  field :created_at, :type => Time
  field :created_by, :type => String
  field :changed_at, :type => Time
  field :changed_by, :type => String
  field :exch_symbol,:type => String
  field :exch_name,  :type => String
  field :exch_rate,  :type => Float
  field :cur_type,   :type => String

  #has_many :currency_defaults
end
