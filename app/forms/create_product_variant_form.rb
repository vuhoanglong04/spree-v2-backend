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
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 99_999_999.99,
              message: "Product variant's origin price must be a number and greater or equal to 0"
            }

  validates :price,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 99_999_999.99,
              message: "Product variant's price must be a number and greater or equal to 0"
            }

  validates :stock_qty,
            numericality:
              {
                greater_than_or_equal_to: 0,
                message: "Product variant's stock quantity must be a number and greater or equal to 0 "
              }
  validate :validate_product_variant_attr_values_attributes

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

  private

  def validate_product_variant_attr_values_attributes
    if product_variant_attr_values_attributes.blank?
      errors.add(:product_variant_attr_values_attributes, "must not be empty")
      return
    end

    seen_pairs = Set.new
    product_variant_attr_values_attributes.each do |item|
      form = ProductVariantAttributeValuesForm.new(item)
      unless form.valid?
        errors.add(:product_variant_attr_values_attributes, form.errors.full_messages)
      end
      # Check duplicated a pair of attribute and attribute value in input data
      pair = [ item["product_attribute_id"], item["attribute_value_id"] ]
      if seen_pairs.include?(pair)
        errors.add(:product_variant_attr_values_attributes, "Duplicate attributes found!")
        return
      else
        seen_pairs.add(pair)
      end

      # 2. Check uniqueness in DB
      input_value_ids = product_variant_attr_values_attributes.map { |i| i["attribute_value_id"] }.sort
      existing_variants = ProductVariant.includes(:product_variant_attr_values)
                                        .where(product_id: product_id)

      existing_variants.each do |variant|
        existing_value_ids = variant.product_variant_attr_values.pluck(:attribute_value_id).sort
        if existing_value_ids == input_value_ids
          errors.add(:product_variant_attr_values_attributes, "This variant is already exist!")
          return
        end
      end
    end
  end
end
