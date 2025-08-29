class Order < ApplicationRecord
  enum :status, {
    pending: 0,
    paid: 1,
    fulfilled: 2,
    partially_fulfilled: 3,
    canceled: 4,
    refunded: 5,
    returned: 6,
    return_requested: 7
  }
  has_many :order_items
end
