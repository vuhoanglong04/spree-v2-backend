class Order < ApplicationRecord
  enum :status, {
    pending: 0,
    paid: 1,
    processing: 2,
    shipped: 3,
    canceled: 4,
    refunded: 5,
    return_requested: 6,
    returned: 7
  }

  belongs_to :promotion, optional: true
  has_many :order_items
  belongs_to :account_user
  accepts_nested_attributes_for :order_items
end
