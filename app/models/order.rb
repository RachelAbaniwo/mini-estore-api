class Order < ApplicationRecord
  validates :shipping_id, presence: true
  validates :tax_id, presence: true

  has_many :order_details
end
