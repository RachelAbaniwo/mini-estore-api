class ShippingRegion < ApplicationRecord
  self.table_name = "shipping_region"
  has_many :shippings

end
