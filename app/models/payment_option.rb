class PaymentOption < ActiveRecord::Base
  attr_accessible :amount, :amount_display, :delivery_desc, :description, :limit, :purchased_count, :shipping_desc
end
