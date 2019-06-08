class Product < ApplicationRecord
  self.table_name = "product"
  has_many :product_categories
  belongs_to :category
  has_many :product_attributes
  has_many :attribute_values, through: :product_attributes
end
