class Coinbag
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :coinbag, :type => String
end
