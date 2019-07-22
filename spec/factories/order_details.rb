FactoryBot.define do
  factory :order_detail do
    item_id { 1 }
    order_id { 1 }
    product_id { 1 }
    attributes { "MyString" }
    product_name { "MyString" }
    quantity { 1 }
    unit_cost { "9.99" }
  end
end
