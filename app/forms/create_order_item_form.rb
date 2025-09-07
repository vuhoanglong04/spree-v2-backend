class CreateOrderItemForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :product_variant_id,
                :quantity,
                :unit_price,
                :product_variant_snapshot
  validates :product_variant_id,
            :quantity,
            :unit_price,
            presence: true
  validates :quantity,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: 99_999_999.99,
              message: "Order item quantity is not valid"
            }
  def initialize(attributes = {})
    super(attributes)
    validate!
  end
end
