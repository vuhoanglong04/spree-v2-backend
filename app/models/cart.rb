class Cart < ApplicationRecord
  belongs_to :account_user
  has_many :cart_items, dependent: :destroy
end
