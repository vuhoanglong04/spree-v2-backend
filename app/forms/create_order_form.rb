class CreateOrderForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :account_user_id,
                :total_amount,
                :description,
                :email,
                :first_name,
                :last_name,
                :phone_number,
                :order_items,
                :promotion_id

  validates :account_user_id,
            presence: true

  validates :total_amount,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :first_name,
            presence: true

  validates :last_name,
            presence: true

  validates :phone_number,
            presence: true

  validate :validate_order_items

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

  private

  def validate_order_items
    if order_items.blank? || !order_items.is_a?(Array)
      errors.add(:order_items, "Order item is required")
      return
    end
  end
end
