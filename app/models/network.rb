class Network
  include Mongoid::Document
  include Mongoid::Timestamps

  ## Field
  field :name, type: String, :default => "Network##{rand(100)}"
  field :description, type: String, :default => ""

  field :ip, type: String, :default => ""
  field :mac, type: String, :default => ""
  field :protected, type: Boolean, :default => true

  ## Relation
  belongs_to :user
  belongs_to :network_spec
  belongs_to :instance

  has_many :logs, :class_name => "Log", :as => "logable", :dependent => :destroy

  ## Validation
  validates :user, :presence => true
  validates :network_spec, :presence => true

  before_create :generate_mac

  private
  def generate_mac
    self.mac = "00:16:" + Digest::SHA1.hexdigest(self._id.to_s + Time.now.to_s)[0...8].insert(2, ":").insert(5, ":").insert(8, ":")
  end
end
