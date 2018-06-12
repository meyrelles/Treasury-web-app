class Coinbag
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :coinbag, :type => String
  field :user_id, :type => String
end
