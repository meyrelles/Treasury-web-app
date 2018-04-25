class TrStatement
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :date_time, :type => Time
  field :timezone, :type => Integer
  field :description, :type => String
  field :reason, :type => String
  field :coinbag, :type => String
  field :from, :type => String
  field :to, :type => String
  field :currency, :type => String
  field :amount, :type => Float
  field :celebrate, :type => String
  field :mov_type, :type => String
end
