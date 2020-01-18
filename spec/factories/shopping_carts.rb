FactoryBot.define do
  factory :shopping_cart do
    item_id { 1 }
    cart_id { "MyString" }
    product_id { 1 }
    attributes { "MyString" }
    quantity { 1 }
    buy_now { false }
    added_on { "2019-07-10 15:38:00" }
  end
end
