class ProductAttribute < ApplicationRecord
  self.table_name = "product_attribute"
  belongs_to :product
  belongs_to :attribute_value
end
