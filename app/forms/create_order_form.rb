class CreateOrderForm
  include ActiveModel::Model
  include CustomValidateForm
  attr_accessor :account_user_id,
                :currency,
                :status,
                :total_amount,
                :refunded_amount,
                :promotion_id,
                :description,
                :order_items_attributes
  validates :account_user_id,
            :currency,
            presence: true
  validates :total_amount,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0.00
            },
            allow_nil: true
  validates :refunded_amount,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0.00
            },
            allow_nil: true
  validate :validate_order_items_attributes
  validate :validate_valid_promotion

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

  private

  def validate_order_items_attributes
    if order_items_attributes.nil?
      errors.add(:order_items_attributes, "can't be blank")
    end
    order_items_attributes.each do |index, order_item_data|
      CreateOrderItemForm.new(order_item_data)
    end
  end

  def validate_valid_promotion
    return if promotion_id.blank?

    promotion = Promotion.find_by(id: promotion_id, deleted_at: nil)
    if promotion.nil?
      errors.add(:promotion_id, "is invalid")
      return
    end

    now = Time.current
    if promotion.start_date && promotion.start_date > now
      errors.add(:promotion_id, "is not active yet")
    elsif promotion.end_date && promotion.end_date < now
      errors.add(:promotion_id, "has expired")
    end

    if promotion.usage_limit && Order.where(promotion_id: promotion.id).count >= promotion.usage_limit
      errors.add(:promotion_id, "has reached usage limit")
    end

    if promotion.per_user_limit &&
       Order.where(promotion_id: promotion.id, account_user_id: account_user_id).count >= promotion.per_user_limit
      errors.add(:promotion_id, "has reached your personal usage limit")
    end

    if promotion.min_order_amount && total_amount < promotion.min_order_amount
      errors.add(:promotion_id, "requires a minimum order of #{promotion.min_order_amount}")
    end
  end

  def total_amount
    order_items_attributes.sum { |index, item| item[:quantity].to_f * item[:unit_price].to_f }
  end
end

