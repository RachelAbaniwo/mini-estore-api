class ShoppingCart < ApplicationRecord
  self.table_name = "shopping_cart"
  validates :cart_id, presence: true
  validates :product_id, presence: true
  validates :attry, presence: true
  
end
