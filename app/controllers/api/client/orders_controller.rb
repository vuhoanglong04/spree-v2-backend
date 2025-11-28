class Api::Client::OrdersController < Api::Client::BaseClientController
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    orders = Order.order("created_at desc").where(account_user_id: params[:account_user_id]).page(page).per(per_page)
    render_response(
      data: {
        orders: ActiveModelSerializers::SerializableResource.new(orders)
      },
      message: "Get all orders successfully.",
      meta: pagination_meta(orders),
      status: 200
    )
  end

  def create
    CreateOrderForm.new(order_params)
    order = Order.new(order_params.except(:order_items))

    ActiveRecord::Base.transaction do
      order.save!
      AutoCancelUnpaidOrderJob.set(wait: 30.minutes).perform_later(order.id)
      order_params[:order_items].each do |item|
        variant = ProductVariant.find_by!(id: item[:product_variant_id])
        order.order_items.create!(
          product_variant_id: item[:product_variant_id],
          name: variant&.name,
          sku: variant&.sku,
          quantity: item[:quantity],
          unit_price: variant&.price
        )
      end
    end

    render_response(
      data: {
        order: ActiveModelSerializers::SerializableResource.new(order, serializer: OrderSerializer)
      },
      message: "Create order successfully",
      status: 201
    )

  rescue ActiveRecord::RecordInvalid => e
    raise ValidationError.new("Validation failed", e.errors.to_hash(full_messages: true))
  end

  def update
    order = Order.find_by!(id: params[:id])
    if order.update(status: params[:status])
      render_response(
        data: {
          order: ActiveModelSerializers::SerializableResource.new(order, serializer: OrderSerializer)
        },
        message: "Update order successfully",
        status: 200
      )
    else
      raise ValidationError.new("Validation failed", e.errors.to_hash(full_messages: true))
    end
  end

  private

  def order_params
    params.permit(
      :account_user_id,
      :total_amount,
      :promotion_id,
      :description,
      :email,
      :first_name,
      :last_name,
      :phone_number,
      order_items: [ :product_variant_id, :quantity, :unit_price ]
    )
  end
end
