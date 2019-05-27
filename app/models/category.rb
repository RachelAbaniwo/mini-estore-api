class Category < ApplicationRecord
  self.table_name = "category"
  belongs_to :department
end
