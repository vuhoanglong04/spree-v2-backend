class Category < ApplicationRecord
  acts_as_paranoid
  has_many :product_categories
  has_many :products, through: :product_categories
  has_one :category
  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
end
