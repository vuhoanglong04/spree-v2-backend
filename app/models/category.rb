class Category < ApplicationRecord
  acts_as_paranoid
  has_many :product_categories
  has_many :products, through: :product_categories

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
end
