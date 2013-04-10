class User < ActiveRecord::Base
  attr_accessible :email
  has_many :orders
  before_validate :generate_uuid!, :on => :create
  
  def generate_uuid!
    begin
      self.uuid = SecureRandom.hex(16)
    end while Order.find_by_uuid(self.uuid).present?
    end
end
