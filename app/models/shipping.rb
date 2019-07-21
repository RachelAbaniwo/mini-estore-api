class Shipping < ApplicationRecord
  self.table_name = "shipping"
  belongs_to :shipping_region
end
