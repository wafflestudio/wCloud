class Log
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Field
  field :read, type: Boolean, :default => false
  field :message, type: String, :default => ""

  ## Relation
  belongs_to :user
  belongs_to :logable, :polymorphic => true

  ## Validation
  validates :user, :presence => true
  validates :logable, :presence => true
end
