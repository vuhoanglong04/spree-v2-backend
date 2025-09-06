# frozen_string_literal: true

class ProductVariantForm
  include ActiveModel::Model
  include CustomValidateForm

  attr_accessor :sku, :origin_price, :price, :stock_qty

  validates :sku,
            :price,
            :stock_qty,
            presence: true
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

  def initialize(attributes = {})
    super(attributes)
    validate!
  end
end
