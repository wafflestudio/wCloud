class Instance
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Constant
  CREATING=1
  RUNNING=2
  DESTROYING=3
  DESTROYED=4

  STOPPING=5
  STOPPED=6
  STRATING=7

  ## Field
  field :protected, type: Boolean, :default => false
  field :name, type: String, :default => ""
  field :description, type: String, :default => ""
  field :ram, type: Integer, :default => 512
  field :cpu, type: Integer, :default => 1
  field :state, type: Integer, :default => CREATING

  field :vncpassword, type: String, :default => ""

  ## Relation
  belongs_to :user
  belongs_to :instance_spec
  belongs_to :template

  has_many :disks, :dependent => :destroy
  has_many :snapshots, :dependent => :destroy
  has_many :networks, :dependent => :destroy
  has_many :templates

  ## Validation
  validates :user, :presence => true
  validates :instance_spec, :presence => true
  validates :template, :presence => true
end
