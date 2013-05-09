class User < ActiveRecord::Base
  attr_accessible :email, :uuid
  has_many :orders
end
