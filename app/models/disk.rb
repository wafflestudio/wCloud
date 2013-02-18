class Disk
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Constant
  READ=0
  WRITE=1

  GB=1024

  ## Field
  field :path, type: String, :default => ""
  field :name, type: String, :default => "Disk##{rand(100)}"
  field :description, type: String, :default => ""
  field :size, type: Integer, :default => 50 * GB

  field :protected, type: Boolean, :default => true
  field :attached, type: Boolean, :default => false
  field :vdev, type: String, :default => ""
  field :mode, type: Integer, :default => WRITE

  ## Relation
  belongs_to :user
  belongs_to :disk_spec
  belongs_to :instance

  belongs_to :snapshot
  belongs_to :parent, :class_name => "Disk", :inverse_of => :children
  has_many :children, :class_name => "Disk", :inverse_of => :parent
  has_many :logs, :class_name => "Log", :as => "logable", :dependent => :destroy

  ## Validation
  validates :user, :presence => true
  validates :disk_spec, :presence => true

  before_save :set_size

  def mode_to_string
    modes = ["Unknown", "Write", "Read only"]
    modes[self.mode]
  end
  
  private
  def set_size
    self.size = self.disk_spec.size
  end
end
