class Attribute < ApplicationRecord
  self.table_name = "attribute"
  has_many :attribute_values
end
