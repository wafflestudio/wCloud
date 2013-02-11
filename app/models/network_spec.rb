class NetworkSpec
  include Mongoid::Document

PRIVATE=1
PUBLIC=2

field :name, type: String, :default => ""
field :description, type: String, :default => ""
field :type, type: Integer, :default => PRIVATE

## Relation
has_many :networks, :dependent => :destroy
end
