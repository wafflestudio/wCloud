class InstanceSpec
  include Mongoid::Document

## Field
field :active, type: Boolean, :default => false
field :ram, type: Integer, :default => 512
field :cpu, type: Integer, :default => 1

## Relation
has_many :instances, :dependent => :destroy
end
