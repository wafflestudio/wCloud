class Usage
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Field
  field :read, type: Boolean, :default => false
  field :message, type: String, :default => ""

  ## Relation
  belongs_to :user

  ## Validation
  validates :user, :presence => true
end
