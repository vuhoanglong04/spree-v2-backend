class Product < ApplicationRecord
  has_many :product_variants
  has_many :product_categories
  has_many :categories, through: :product_categories
end
