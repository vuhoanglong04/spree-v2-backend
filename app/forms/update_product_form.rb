# frozen_string_literal: true

class UpdateProductForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :name,
                :slug,
                :description,
                :brand,
                :product_images_attributes,
                :product_categories_attributes,
                :product_variants_attributes
  validate :validate_default_product_variants_attributes
  validate :validate_product_images_attributes
  validate :valid_categories_attributes

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

  private

  def validate_default_product_variants_attributes
    return if product_variants_attributes.blank?

    product_variants_attributes.each do |index, variant_data|
      variant_form = UpdateDefaultNestedProductVariantForm.new(variant_data)
      unless variant_form.valid?
        errors.add(:product_variants_attributes, variant_form.errors.full_messages.to_sentence)
      end
    end
  end

  def validate_product_images_attributes
    return if product_images_attributes.blank?

    product_images_attributes.each do |index, image_data|
      if image_data[:id].nil?
        image_form = ProductImageForm.new(image_data)
        unless image_form.valid?
          errors.add(:product_images_attributes, image_form.errors.full_messages.to_sentence)
          return
        end
      end
    end
  end

  def valid_categories_attributes
    if product_categories_attributes.blank?
      errors.add(:product_categories_attributes, "Categories are required")
    end
  end
end
