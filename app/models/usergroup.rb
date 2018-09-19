class Usergroup
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  field :group_name, :type => String
  field :created_at, :type => Time
  field :created_by, :type => String
end
