class Product < ApplicationRecord
  has_many :product_variants
  has_many :product_categories
end
