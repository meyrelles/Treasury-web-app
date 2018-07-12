class Classification
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :classification, :type => String, :uniq => true
end
