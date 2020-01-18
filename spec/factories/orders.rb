FactoryBot.define do
  factory :order do
    total_amount { "9.99" }
    created_on { "2019-07-18 18:27:59" }
    shipped_on { "2019-07-18 18:27:59" }
    status { 1 }
    comments { "MyString" }
    customer_id { 1 }
    auth_code { "MyString" }
    reference { "MyString" }
    shipping_id { 1 }
    tax_id { 1 }
  end
end
