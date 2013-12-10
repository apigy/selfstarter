# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    user
    name { Faker::Name.first_name }
    price { (Faker::Number.number(3).to_f)/100 }
    number 1
    
    factory :authenticated_order do
      addressLine1 { Faker::Address.street_address }
      addressLine2 { Faker::Address.secondary_address }
      city { Faker::Address.city }
      state { Faker::Address.state }
      zip { Faker::Address.zip_code }
      phoneNumber { Faker::PhoneNumber.cell_phone }
      country { Faker::Address.country }
      status "IN PROGRESS"
      token 128736127863
      expiration { Date.parse(Time.now + 99999) }
    end
  end
end
