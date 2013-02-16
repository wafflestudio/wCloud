class Usage
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Field
  field :message, type: String, :default => ""

  ## Relation
  belongs_to :user

  ## Validation
  validates :user, :presence => true
end
