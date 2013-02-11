class Template
  include Mongoid::Document
  include Mongoid::Timestamps

PVM=1
HVM=2

X86=32
X86_64=64

## Field
field :path, type: String, :default => ""
field :name, type: String, :default => ""
field :description, type: String, :default => ""
field :type, type: Integer, :default => PVM
field :arch, type: Integer, :default => X86

## Relation
belongs_to :user
belongs_to :instance

has_many :instances, :dependent => :destroy
end
