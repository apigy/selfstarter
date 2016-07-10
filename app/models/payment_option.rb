# == Schema Information
#
# Table name: payment_options
#
#  id             :integer          not null, primary key
#  amount         :decimal(, )
#  amount_display :string
#  description    :text
#  shipping_desc  :string
#  delivery_desc  :string
#  limit          :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class PaymentOption < ActiveRecord::Base
  has_many :orders
end
