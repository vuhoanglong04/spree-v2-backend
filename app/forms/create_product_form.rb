# frozen_string_literal: true

class CreateProductForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :name,
                :slug,
                :description,
                :brand,
                :favourite_count,
                :product_images_attributes,
                :product_categories_attributes,
                :product_variants_attributes
  validates :name,
            :slug,
            :description,
            :brand,
            presence: true
  validate :valid_categories_attributes
  validate :validate_default_product_variants_attributes
  validate :validate_product_images_attributes

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

  private

  def valid_categories_attributes
    if product_categories_attributes.blank?
      errors.add(:product_categories_attributes, "Categories are required")
    end
  end

  def validate_default_product_variants_attributes
    if product_variants_attributes.empty?
      errors.add(:product_variants_attributes, "Default variant's attributes are required")
    else
      variant_form = ProductVariantForm.new(product_variants_attributes["0"])
      unless variant_form.valid?
        errors.add(:product_variants_attributes, variant_form.errors.full_messages.to_sentence)
      end
    end
  end

  def validate_product_images_attributes
    if product_images_attributes.empty?
      errors.add(:product_images_attributes, "Product image is required")
    else
      product_images_attributes.each do |index, image_data|
        images_form = ProductImageForm.new(image_data)
        unless images_form.valid?
          errors.add(:product_images_attributes, images_form.errors.full_messages.to_sentence)
          return
        end
      end
    end
  end

end
