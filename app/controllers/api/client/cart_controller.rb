class Api::Client::CartController < Api::Client::BaseClientController
  def create
    cart = Cart.find_or_create_by(account_user_id: current_account_user.id)
    CartItem.create(cart_id: cart.id, product_variant_id: params[:product_variant_id], quantity: params[:quantity])
  end

  private

  def cart_params
    params.permit(:product_variant_id, :quantity)
  end
end
