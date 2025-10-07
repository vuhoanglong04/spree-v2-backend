class ProductVariant < ApplicationRecord
  # Callback
  after_create_commit :create_stripe_product
  # Relationship
  belongs_to :product
  has_many :product_variant_attr_values, dependent: :destroy
  has_many :attribute_values, through: :product_variant_attr_values
  accepts_nested_attributes_for :product_variant_attr_values, allow_destroy: true
  # Other
  acts_as_paranoid

  # Validations
  validates :name, uniqueness: { case_sensitive: true }, presence: true
  validates :sku, uniqueness: { case_sensitive: true }, presence: true

  private

  def create_stripe_product
    StripeService.create_stripe_product(self)
  end
end
