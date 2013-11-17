class User < ActiveRecord::Base
  has_many :orders
end
