class Miner
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :datetime,   :type => Time, :index => true, :uniq => true
  field :hashrate,   :type => Float
  field :totalshares,:type => Float
  field :pool,       :type => String

  #has_many :currency_defaults
end
