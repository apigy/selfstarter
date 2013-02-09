# == Schema Information
#
# Table name: payment_options
#
#  id             :integer          not null, primary key
#  amount         :decimal(, )
#  amount_display :string(255)
#  description    :text
#  shipping_desc  :string(255)
#  delivery_desc  :string(255)
#  limit          :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PaymentOption < ActiveRecord::Base
  attr_accessible :amount, :amount_display, :delivery_desc, :description, :limit, :shipping_desc
  has_many :orders
end
