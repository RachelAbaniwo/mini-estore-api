class AttributeValue < ApplicationRecord
  self.table_name = "attribute_value"
  has_many :product_attributes
  has_many :products, through: :product_attributes
end
