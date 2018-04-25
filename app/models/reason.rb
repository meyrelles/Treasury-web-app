class Reason
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :reason, :type => String
end
