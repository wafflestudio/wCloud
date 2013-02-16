class Snapshot
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Field
  field :name, type: String, :default => ""
  field :description, type: String, :default => ""

  ## Relation
  belongs_to :instance

  has_many :disks

  ## Validation
  validates :instance, :presence => true
end
