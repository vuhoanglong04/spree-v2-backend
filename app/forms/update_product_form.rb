# frozen_string_literal: true

class UpdateProductForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :product,
                :product_variant,
                :images,
                :categories
  validate :validate_default_product_variants_attributes
  validate :validate_product_images_attributes

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

  private

  def validate_default_product_variants_attributes
    if product_variant && !product_variant.empty?
      variant_form = UpdateProductVariantForm.new(product_variant)
      unless variant_form.valid?
        errors.add(:product_variant, variant_form.errors.full_messages.to_sentence)
      end
    end
  end

  def validate_product_images_attributes
    if images && !images.empty?
      images.each do |index, image_data|
        images_form = ProductImageForm.new(image_data)
        unless images_form.valid?
          errors.add(:images, images_form.errors.full_messages.to_sentence)
          return
        end
      end
    end
  end
end
