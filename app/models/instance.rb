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
  STARTING=7
  REBOOTING=8

  ## Field
  field :protected, type: Boolean, :default => true
  field :name, type: String, :default => ""
  field :description, type: String, :default => ""
  field :state, type: Integer, :default => CREATING
  field :domid, type: Integer, :default => 0

  field :vncport, type: Integer, :default => 0
  field :vncpassword, type: String, :default => Digest::SHA1.hexdigest(Time.now.to_s)[0...6]


  ## Relation
  belongs_to :user
  belongs_to :instance_spec
  belongs_to :template

  has_many :disks, :dependent => :destroy
  has_many :snapshots, :dependent => :destroy
  has_many :networks, :dependent => :destroy
  has_many :templates
  has_many :logs, :class_name => "Log", :as => "logable", :dependent => :destroy

  ## Security
  #attr_accessible :state, :domid, :disks, :snapshots, :networks, :templates, :logs
  #attr_readonly :user, :template

  ## Validation
  validates :user, :presence => true
  validates :instance_spec, :presence => true
  validates :template, :presence => true

  ## Callback
  before_update :set_default

  def set_default
    case self.state
    when CREATING
      self.vncpassword = Digest::SHA1.hexdigest(Time.now.to_s)[0...6]
    when STOPPED
      self.domid = 0
      self.vncport = 0
    when STARTING
      self.vncpassword = Digest::SHA1.hexdigest(Time.now.to_s)[0...6]
    when REBOOTING
      self.domid = 0
      self.vncport = 0
      self.vncpassword = Digest::SHA1.hexdigest(Time.now.to_s)[0...6]
    end
  end

  def state_to_string
    states = ["Unknown", "Creating", "Running", "Destroying", "Destroyed", "Stopping", "Stopped", "Starting", "Rebooting"]
    states[self.state]
  end

  def main_disk
    self.disks.each do |disk|
      return disk if disk.vdev.last == "a"
    end
  end

  def can_destroy?
    if !self.protected
      true
    else
      false
    end
  end
end
