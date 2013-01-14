class PaymentOption < ActiveRecord::Base
  attr_accessible :amount, :amount_display, :delivery_desc, :description, :limit, :shipping_desc
end
