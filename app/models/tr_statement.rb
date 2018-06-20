class TrStatement
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :date_time, :type => Time
  field :timezone, :type => Integer
  field :classification, :type => String
  field :reason, :type => String
  field :coinbag, :type => String
  field :coinbag_dest, :type => String
  field :from, :type => String
  field :to, :type => String
  field :currency, :type => String
  field :amount, :type => Float
  field :celebrate, :type => String
  field :mov_type, :type => String
  field :transaction_link, :type => String
  field :exch_destin, :type => String
  field :fee, :type => Float
  field :hash, :type => String
  field :version, :type => String
  field :created_by, :type => String
  field :transaction_id, :type => String
  field :status, :type => String
end
