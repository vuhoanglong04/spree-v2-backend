class Order < ApplicationRecord
  enum :status, {
    pending: 0,
    paid: 1,
    fulfilled: 2,
    canceled: 3
  }
  has_many :order_items
  belongs_to :promotion, optional: true
end
