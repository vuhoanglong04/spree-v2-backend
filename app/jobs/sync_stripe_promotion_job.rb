class SyncStripePromotionJob < ApplicationJob
  queue_as :default

  def perform(promotion_id)
    promotion = Promotion.find_by(id: promotion_id)
    return unless promotion

    if promotion.stripe_coupon_id.present?
      update_coupon(promotion)
    else
      create_coupon(promotion)
    end
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe sync failed for Promotion ##{promotion_id}: #{e.message}")
  end

  private

  # Create a new Stripe coupon based on promotion attributes
  def create_coupon(promotion)
    coupon_params = build_coupon_params(promotion)
    coupon = Stripe::Coupon.create(coupon_params)

    promotion.update!(stripe_coupon_id: coupon.id)
  end

  # Update existing Stripe coupon if exists
  def update_coupon(promotion)
    coupon_params = build_coupon_params(promotion)
    Stripe::Coupon.update(promotion.stripe_coupon_id, coupon_params)
  rescue Stripe::InvalidRequestError => e
    # If coupon no longer exists in Stripe, recreate it
    if e.message =~ /No such coupon/
      promotion.update!(stripe_coupon_id: nil)
      create_coupon(promotion)
    else
      raise
    end
  end

  # Build parameters for Stripe coupon creation/update
  def build_coupon_params(promotion)
    params = {
      name: promotion.code,
      duration: "once",
      metadata: {
        promotion_id: promotion.id,
        code: promotion.code,
        promotion_type: promotion.promotion_type,
        start_date: promotion.start_date,
        end_date: promotion.end_date,
        min_order_amount: promotion.min_order_amount,
        usage_limit: promotion.usage_limit,
        per_user_limit: promotion.per_user_limit
      }
    }
    case promotion.promotion_type
    when "percentage"
      # percent discount
      params[:percent_off] = promotion.value
    when "fixed"
      # (Stripe expects cents->*100 to become $)
      params[:amount_off] = (promotion.value.to_f * 100).to_i
      params[:currency] = "usd"
    else
      raise "Unknown promotion_type: #{promotion.promotion_type}"
    end

    params
  end
end
