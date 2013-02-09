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

require 'spec_helper'

describe PaymentOption do
  pending "add some examples to (or delete) #{__FILE__}"
end
