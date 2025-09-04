class Product < ApplicationRecord
  acts_as_paranoid

  has_many :product_images, -> { order(position: :asc) }, dependent: :destroy
  has_many :product_variants
  has_many :product_categories
  has_many :categories, through: :product_categories
  accepts_nested_attributes_for :product_categories, allow_destroy: true
  accepts_nested_attributes_for :product_variants, allow_destroy: true
  accepts_nested_attributes_for :product_images, allow_destroy: true
end
