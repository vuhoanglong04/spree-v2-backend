class Category < ApplicationRecord
  acts_as_paranoid
  has_many :product_categories
  has_many :products, through: :product_categories
  belongs_to :category, foreign_key: :parent_id, optional: true
  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
end
