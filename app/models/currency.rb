class Currency
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :currency, :type => String
end
