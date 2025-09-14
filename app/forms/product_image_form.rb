# frozen_string_literal: true

class ProductImageForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :id, :url, :file, :alt, :position, :_destroy

  validates :alt,
            :position,
            presence: true
  validates :file, presence: true, if: :new_record?
  validates :position,
            numericality: {
              greater_than_or_equal_to: 0
            }

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

  private

  def new_record?
    !id.nil?
  end
end
