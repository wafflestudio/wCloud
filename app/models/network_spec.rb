class NetworkSpec
  include Mongoid::Document

  ## Constant
  PRIVATE=1
  PUBLIC=2

  ## Field
  field :active, type: Boolean, :default => false
  field :name, type: String, :default => ""
  field :description, type: String, :default => ""
  field :type, type: Integer, :default => PRIVATE
  field :bridge, type: String, :default => ""

  ## Relation
  has_many :networks, :dependent => :destroy

  def type_to_string
    types = ["Unknown", "Private"]
    types[self.type]
  end
end
