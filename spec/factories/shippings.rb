FactoryBot.define do
  factory :shipping do
    shipping_type { "MyString" }
    shipping_cost { "9.99" }
    shipping_region_id { 1 }
  end
end
