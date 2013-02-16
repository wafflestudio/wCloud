class DiskSpec
  include Mongoid::Document

  ## Constant
  HDD=1
  CDROM=2

  GB=1024

  ## Field
  field :active, type: Boolean, :default => false
  field :name, type: String, :default => ""
  field :description, type: String, :default => ""
  field :type, type: Integer, :default => HDD
  field :size, type: Integer, :default => 64 * GB

  ## Relation
  has_many :disks, :dependent => :destroy
end
