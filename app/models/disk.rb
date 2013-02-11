class Disk
  include Mongoid::Document
  include Mongoid::Timestamps

READ=0
WRITE=1

GB=1024

## Field
field :path, type: String, :default => ""
field :name, type: String, :default => ""
field :description, type: String, :default => ""
field :size, type: Integer, :default => 50 * GB

field :attached, type: Boolean, :default => false
field :vdev, type: String, :default => ""
field :mode, type: Integer, :default => WRITE

## Relation
belongs_to :disk_spec
belongs_to :instance

belongs_to :snapshot
belongs_to :parent, :class_name => "Disk", :inverse_of => :children
has_many :children, :class_name => "Disk", :inverse_of => :parent

## Validation
validates :disk_spec, :presence => true
validates :instance, :presence => true
end
