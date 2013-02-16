class InstanceSpec
  include Mongoid::Document

  ## Field
  field :active, type: Boolean, :default => false
  field :name, type: String, :default => ""
  field :description, type: String, :default => ""
  field :ram, type: Integer, :default => 512
  field :core, type: Integer, :default => 1

  ## Relation
  has_many :instances, :dependent => :destroy
end
