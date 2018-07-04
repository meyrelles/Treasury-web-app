class ClassificationDefault
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :classification, :type => String
  field :user_id, :type => String
  field :created_at, :type => Time
  field :created_by, :type => String
  field :classification_id, :type => String
  field :isdefault, :type => String
  field :ishide, :type => String
  field :operation, :type => String
end
