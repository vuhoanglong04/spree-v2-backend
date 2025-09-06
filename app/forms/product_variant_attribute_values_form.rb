# frozen_string_literal: true

class ProductVariantAttributeValuesForm
  include ActiveModel::Model
  include CustomValidateForm

  attr_accessor :product_attribute_id, :attribute_value_id

  validates :product_attribute_id,
            :attribute_value_id,
            presence: true

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

end
