# frozen_string_literal: true

class ProductImageForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :file, :alt, :position

  validates :file,
            :alt,
            :position,
            presence: true
  validates :position,
            numericality: {
              greater_than_or_equal_to: 0
            }

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

end
