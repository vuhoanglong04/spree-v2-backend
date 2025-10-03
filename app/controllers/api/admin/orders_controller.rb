class Api::Admin::OrdersController < Api::Admin::BaseAdminController
  before_action :authorize_account_user
  # GET /orders or /orders.json
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    orders = Order.order("updated_at desc").all.page(page).per(per_page)
    render_response(
      data: {
        orders: ActiveModelSerializers::SerializableResource.new(orders, each_serializer: OrderSerializer)
      },
      message: "Get all orders successfully",
      status: 200,
      meta: pagination_meta(orders)
    )
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    order = Order.find_by!(id: params[:id])
    if order.update(order_params)
      render_response(
        data: {
          order: ActiveModelSerializers::SerializableResource.new(order)
        },
        message: "Update order successfully!",
        status: 200
      )
    else
      raise ValidationError.new("Validation failed", account_user.errors.to_hash(full_messages: true))
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
  end

  private

  def order_params
    params.permit(:account_user_id,
                  :currency,
                  :status,
                  :total_amount,
                  :refunded_amount,
                  :promotion_id,
                  :description)
  end

  def authorize_account_user
    authorize current_account_user,  policy_class: OrderPolicy
  end
end
