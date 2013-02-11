class DiskSpec
  include Mongoid::Document

HDD=1
CDROM=2

GB=1024

## Field
field :name, type: String, :default => ""
field :description, type: String, :default => ""
field :type, type: Integer, :default => HDD
field :size, type: Integer, :default => 50 * GB

## Relation
has_many :disks, :dependent => :destroy
end
