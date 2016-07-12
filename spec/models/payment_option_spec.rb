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

require 'spec_helper'

describe PaymentOption do
  pending "add some examples to (or delete) #{__FILE__}"
end
