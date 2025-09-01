class Category < ApplicationRecord
  has_many :products, through: :product_categories
end
