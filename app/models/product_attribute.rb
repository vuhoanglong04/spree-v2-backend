class ProductAttribute < ApplicationRecord
  acts_as_paranoid
  has_many :attribute_values, dependent: :destroy
  # has_many :product_variant_attr_values
  accepts_nested_attributes_for :attribute_values, allow_destroy: true
end
