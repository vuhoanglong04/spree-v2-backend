class Api::Admin::OrdersController < Api::BaseController
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    orders = Order.all.page(page).per(per_page)
    render_response(
      data: {
        orders: ActiveModelSerializers::SerializableResource.new(orders, each_serializer: OrderSerializer)
      },
      message: "Get all orders successfully",
      status: 200
    )
  end

  # GET /orders/1 or /orders/1.json
  def show
    orders = Order.find_by!(id: params[:id])
    render_response(
      data: {
        orders: ActiveModelSerializers::SerializableResource.new(orders, each_serializer: OrderSerializer)
      },
      message: "Get all orders successfully",
      status: 200
    )
  end

  # GET /orders/new
  def new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    CreateOrderForm.new(order_params)
    order = nil
    Order.transaction do
      order_items_attrs = order_params[:order_items_attributes]&.values || []
      subtotal = order_items_attrs.sum do |item|
        item[:unit_price].to_d * item[:quantity].to_i
      end
      discount = 0
      if order_params[:promotion_id].present?
        promotion = Promotion.find_by!(id: order_params[:promotion_id])
        if promotion.promotion_type == "percentage" # percent
          discount = subtotal * (promotion.value / 100.0)
        elsif promotion.promotion_type == "fixed" # fixed
          discount = promotion.value
        end
      end
      total = [subtotal - discount, 0].max
      order = Order.create!(
        order_params.merge(
          status: order_params[:status].to_i,
          total_amount: total
        )
      )
    end
    render_response(
      data: {
        order: ActiveModelSerializers::SerializableResource.new(order, serializer: OrderSerializer)
      },
      message: "Create order successfully",
      status: 201
    )
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    UpdateOrderForm.new(status: params[:status])
    order = Order.find_by!(id: params[:id])
    unless can_transition?(order.status, params[:status])
      render_response(
        message: "Invalid status transition from #{order.status} to #{params[:status]}",
        status: 422
      )
      return
    end
    order.update!(status: params[:status])
    render_response(
      data: {
        order: ActiveModelSerializers::SerializableResource.new(order, serializer: OrderSerializer)
      },
      message: "Order updated successfully",
      status: 200
    )
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy

  end

  private

  # Only allow a list of trusted parameters through.
  def order_params
    params.permit(:account_user_id,
                  :currency,
                  :status,
                  :total_amount,
                  :refunded_amount,
                  :promotion_id,
                  :description,
                  order_items_attributes: [
                    :product_variant_id,
                    :quantity,
                    :unit_price,
                    :product_variant_snapshot
                  ]
    )
  end

  def can_transition?(current_status, new_status)
    current_status_str = current_status.to_s
    new_status_str = new_status.to_s

    allowed = {
      "pending" => %w[canceled paid],
      "paid" => %w[processing],
      "processing" => %w[shipped],
      "shipped" => %w[return_requested],
      "return_requested" => %w[returned refunded],
      "returned" => %w[refunded],
      "refunded" => [],
      "canceled" => []
    }

    allowed[current_status_str].include?(new_status_str)
  end

end

