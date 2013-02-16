class Template
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  ## Constant
  PVM=1
  HVM=2

  X86=32
  X86_64=64

  ## Field
  field :active, type: Boolean, :default => false
  field :path, type: String, :default => ""
  field :name, type: String, :default => ""
  field :description, type: String, :default => ""
  field :type, type: Integer, :default => PVM
  field :arch, type: Integer, :default => X86

  has_mongoid_attached_file :logo,
    :default        => ':rails_root/public/system/:class/:attachment/:style/default.png',
    :styles => {
    :original => ['1920x1680>', :png],
    :small    => ['100x100#',     :png],
    :thumb    => ['30x30#',     :png] #TODO
  }

  ## Relation
  belongs_to :user
  belongs_to :instance

  has_many :instances, :dependent => :destroy
end
