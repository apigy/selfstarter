class PaymentOption < ActiveRecord::Base
  has_many :orders
end
