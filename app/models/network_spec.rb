class NetworkSpec
  include Mongoid::Document

PRIVATE=1
PUBLIC=2

## field
field :active, type: Boolean, :default => false
field :name, type: String, :default => ""
field :description, type: String, :default => ""
field :type, type: Integer, :default => PRIVATE
field :bridge, type: String, :default => ""

## Relation
has_many :networks, :dependent => :destroy
end
