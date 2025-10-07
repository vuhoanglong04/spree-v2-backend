class Api::PaymentController < ApplicationController
  include ResponseHandler
  skip_before_action :verify_authenticity_token

  def stripe
    items = []
    order_params[:items].each do |item_params|
      items << {
        price: item_params[:stripe_price_id],
        quantity: item_params[:quantity]
      }
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      line_items: items,
      mode: "payment",
      discounts: [
        { coupon: order_params[:stripe_coupon_id] }
      ],
      success_url: "http://localhost:5173/payment/success",
      cancel_url: "http://localhost:5173/payment/error",
      payment_intent_data: {
        metadata: { order_id: order_params[:order_id] }
      },
    )
    render_response(message: "Create payment link successfully", status: 200, data: session.url)
  rescue Stripe::StripeError => e
    render_response(status: :unprocessable_entity, message: e.message)
  end

  def stripe_webhook
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = ENV["STRIPE_WEBHOOK_SECRET"]

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError
      return head :bad_request
    rescue Stripe::SignatureVerificationError
      return head :unauthorized
    end

    case event.type
    when "charge.succeeded"
      session = event.data.object
      handle_checkout_session(session)
    else
      Rails.logger.info("Unhandled event type: #{event.type}")
    end

    head :ok
  end

  private

  def order_params
    params.permit(
      :order_id,
      :stripe_coupon_id,
      items: [
        :stripe_price_id,
        :quantity
      ]
    )
  end

  def handle_checkout_session(session)
    order_id = session.metadata.order_id
    order = Order.find_by(id: order_id)
    if order && order.status == "pending"
      order.update(status: "paid")
      payment_intent_id = session.payment_intent
      payment_intent = Stripe::PaymentIntent.retrieve(payment_intent_id)
      charge_id = payment_intent.latest_charge
      amount = payment_intent.amount_received / 100.0
      currency = payment_intent.currency.upcase
      Payment.create!(
        order_id: order.id,
        stripe_payment_id: payment_intent.id,
        stripe_charge_id: charge_id,
        amount: amount,
        currency: currency,
        status: 1,
        amount_refunded: 0.0,
        last_synced_at: Time.current,
        raw_response: payment_intent.to_json
      )
      Rails.logger.info("✅ Order #{order.id} marked as paid")
    else
      Rails.logger.warn("⚠️ Order not found or payment not completed for session #{session.id}")
    end
  end

end


