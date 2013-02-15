class NetworkPool
  include Mongoid::Document

## Field
field :ip, type: String, :default => ""
field :port, type: Hash, :default => {}

## Relation
belongs_to :network
end
