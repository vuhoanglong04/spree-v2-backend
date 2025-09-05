class ProductVariant < ApplicationRecord
  acts_as_paranoid
  belongs_to :product
  has_many :product_variant_attr_values
  has_many :attribute_values, through: :product_variant_attr_values
  accepts_nested_attributes_for :product_variant_attr_values
end
