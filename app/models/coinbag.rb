class Coinbag
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :coinbag, :type => String, :validates => {:uniqueness => {:scope => :user_id}}
  field :user_id, :type => String
end
