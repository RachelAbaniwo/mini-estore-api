FactoryBot.define do
  factory :review do
    customer_id { 1 }
    product_id { 1 }
    review { "MyText" }
    rating { 1 }
    created_on { "2019-07-20 01:09:53" }
  end
end
