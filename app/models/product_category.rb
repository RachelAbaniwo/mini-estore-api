class ProductCategory < ApplicationRecord
  self.table_name = "product_category"
  belongs_to :product
  belongs_to :category
end
