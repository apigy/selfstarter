# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    user
    name { Faker::Name.first_name }
    price { (Faker::Number.number(3).to_f)/100 }
    number 1
    factory :completed_order do
    	token "123456"
    end
  end
end
