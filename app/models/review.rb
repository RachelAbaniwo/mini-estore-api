class Review < ApplicationRecord
  self.table_name = "review"

  belongs_to :product
  belongs_to :customer

  validates :product_id, presence: true
  validates :review, presence: true
  validates :rating, presence: true
end
