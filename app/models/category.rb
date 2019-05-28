class Category < ApplicationRecord
  self.table_name = "category"
  has_many :product_categories
  has_many :products, through: :product_categories
  belongs_to :department
end
