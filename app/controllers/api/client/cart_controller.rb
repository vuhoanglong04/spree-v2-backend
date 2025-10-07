class Api::Client::CartController < Api::Client::BaseClientController
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    cart = Cart.find_by(account_user_id: params[:account_user_id])
    cart_items = cart&.cart_items&.page(page)&.per(per_page) || []
    render_response(
      data: {
        cart_items: ActiveModelSerializers::SerializableResource.new(cart_items, each_serializer: CartItemSerializer)
      },
      message: "Get all cart items successfully!",
      status: 200
    )
  end

  def create
    cart = Cart.find_or_create_by(account_user_id: params[:account_user_id])
    cart_item = cart.cart_items.find_by(product_variant_id: params[:product_variant_id])
    if cart_item
      cart_item.increment!(:quantity, params[:quantity].to_i)
    else
      cart_item = cart.cart_items.create(
        product_variant_id: params[:product_variant_id],
        quantity: params[:quantity]
      )
    end
    render_response(
      data: {
        cart_item: ActiveModelSerializers::SerializableResource.new(cart_item, serializer: CartItemSerializer)
      },
      message: "Add to cart successfully",
      status: 201
    )
  end

  def update
    ActiveRecord::Base.transaction do
      params[:cart_items].each do |item|
        cart_item = CartItem.find_by!(id: item[:id])
        if item[:_destroy]
          cart_item.destroy!
        else
          cart_item.update!(quantity: item[:quantity])
        end
      end
    end
    render_response(
      message: "Update successful",
      status: 200
    )
  end

  def destroy
    CartItem.find_by!(id: params[:id]).delete
    render_response(
      message: "Delete successful",
      status: 200
    )
  end

  private

  def cart_params
  end
end
