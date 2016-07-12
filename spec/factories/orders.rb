# == Schema Information
#
# Table name: orders
#
#  token             :string
#  transaction_id    :string
#  address_one       :string
#  address_two       :string
#  city              :string
#  state             :string
#  zip               :string
#  country           :string
#  status            :string
#  number            :string
#  uuid              :string           primary key
#  user_id           :string
#  price             :decimal(, )
#  shipping          :decimal(, )
#  tracking_number   :string
#  phone             :string
#  name              :string
#  expiration        :date
#  created_at        :datetime
#  updated_at        :datetime
#  payment_option_id :integer
#

FactoryGirl.define do
  factory :order do
    sequence(:name) { |n| " name #{n}" }
    sequence(:price) {  1.00 }
    association :user
  end
end
