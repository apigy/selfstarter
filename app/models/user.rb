class User < ActiveRecord::Base
  attr_accessible :email
  has_many :orders
  before_validate :generate_uuid!, :on => :create
  
  def generate_uuid!
    self.uuid = SecureRandom.hex(9)
  end
end
