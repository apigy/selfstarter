# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :User do
    sequence(:name) { |n| " name #{n}" }
    sequence(:price) {  1.00 }
    association :user
  end
end
