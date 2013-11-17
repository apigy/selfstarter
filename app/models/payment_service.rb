class PaymentService < ActiveRecord::Base
  has_many :orders
end
