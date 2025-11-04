class Category < ApplicationRecord
  acts_as_paranoid
  has_ancestry
  has_many :product_categories, dependent: :destroy, inverse_of: :category
  has_many :products, -> { distinct }, through: :product_categories, source: :product
  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
end
