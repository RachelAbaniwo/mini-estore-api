FactoryBot.define do
  factory :customer do
    name { "MyString" }
    email { "MyString" }
    password { "MyString" }
    credit_card { "MyText" }
    address_1 { "MyString" }
    address_2 { "MyString" }
    city { "MyString" }
    region { "MyString" }
    postal_code { "MyString" }
    country { "MyString" }
    shipping_region_id { 1 }
    day_phone { "MyString" }
    eve_phone { "MyString" }
    mob_phone { "MyString" }
  end
end
