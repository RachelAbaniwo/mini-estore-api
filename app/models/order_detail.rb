class OrderDetail < ApplicationRecord
  self.table_name = "order_detail"

  belongs_to :order
end
