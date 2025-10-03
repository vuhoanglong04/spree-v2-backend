class Api::Client::ProductsController < Api::Client::BaseClientController
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    products = Product.without_deleted.order("updated_at desc").all.page(page).per(per_page)
    render_response(data: {
      products: ActiveModelSerializers::SerializableResource.new(products, each_serializer: ProductSerializer)
    },
                    message: "Get all products successfully!",
                    status: 200,
                    meta: pagination_meta(products)
    )
  end

  def show
    product = Product.without_deleted.find_by!(id: params[:id])
    render_response(
      data: {
        product: ActiveModelSerializers::SerializableResource.new(product, serializer: ProductSerializer)
      },
      message: "Get product successfully!",
      status: 200
    )
  end
end
