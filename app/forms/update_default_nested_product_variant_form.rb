# frozen_string_literal: true

class UpdateDefaultNestedProductVariantForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :id, :name, :sku, :origin_price, :price, :stock_qty, :_destroy

  validates :id,
            presence: true
  validates :origin_price,
            numericality: {
              greater_or_equal_to: 0,
              less_than_or_equal_to: 99_999_999.99,
              message: "Product variant's origin price is not valid"
            },
            allow_nil: true
  validates :price,
            numericality: {
              greater_or_equal_to: 0,
              less_than_or_equal_to: 99_999_999.99,
              message: "Product variant's price is not valid"
            },
            allow_nil: true
  validates :stock_qty,
            numericality:
              {
                greater_than_or_equal_to: 0,
                message: "Product variant's stock quantity is not valid"
              },
            allow_nil: true

  def initialize(attributes = {})
    super(attributes)
    validate!
  end
end
