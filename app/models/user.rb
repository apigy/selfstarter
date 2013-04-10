class User < ActiveRecord::Base
  attr_accessible :email
  has_many :orders
  before_validate :generate_uuid!, :on => :create
  validates_presence_of :uuid
  self.primary_key = 'uuid'
  
  def generate_uuid!
    begin
      self.uuid = SecureRandom.hex(16)
    end while Order.find_by_uuid(self.uuid).present?
    end
end
