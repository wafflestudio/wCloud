class Network
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Field
  field :name, type: String, :default => "Network##{rand(100)}"
  field :description, type: String, :default => ""

  field :ip, type: String, :default => ""
  field :mac, type: String, :default => ""

  ## Relation
  belongs_to :network_spec
  belongs_to :instance
  has_one :network_pool

  ## Validation
  validates :network_spec, :presence => true
  validates :instance, :presence => true
end
