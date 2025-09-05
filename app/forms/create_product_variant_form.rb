# frozen_string_literal: true

class CreateProductVariantForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :product_id, :sku, :name, :origin_price, :price, :stock_qty, :product_variant_attr_values_attributes

  validates :product_id,
            presence: { message: "Product ID is required" }

  validates :sku,
            presence: { message: "SKU must be provided" }

  validates :name,
            presence: { message: "Name can't be blank, please enter product name" }

  validates :origin_price,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: 99_999_999.99,
              message: "Product variant's origin price is not valid"
            }

  validates :price,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: 99_999_999.99,
              message: "Product variant's price is not valid"
            }

  validates :stock_qty,
            numericality:
              {
                greater_than_or_equal_to: 0,
                message: "Product variant's stock quantity is not valid"
              }
  validate :validate_product_variant_attr_values_attributes

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

  private

  def validate_product_variant_attr_values_attributes
    if product_variant_attr_values_attributes.empty?
      errors.add(:product_variant_attr_values_attributes, "must not be empty")
      return
    end

    seen_pairs = Set.new
    product_variant_attr_values_attributes.each do |index, item|
      form = ProductVariantAttributeValuesForm.new(item)
      unless form.valid?
        errors.add(:product_variant_attr_values_attributes, form.errors.full_messages)
      end

      # check duplicate (product_attribute_id, attribute_value_id)
      pair = [item["product_attribute_id"], item["attribute_value_id"]]
      if seen_pairs.include?(pair)
        errors.add(:product_variant_attr_values_attributes, "Duplicate pair of product_attribute_id and attribute_value_id found")
        return
      else
        seen_pairs.add(pair)
      end
    end
  end
end
