class Category < ApplicationRecord
  acts_as_paranoid
  has_ancestry
  has_many :product_categories
  has_many :products, through: :product_categories
  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
end
