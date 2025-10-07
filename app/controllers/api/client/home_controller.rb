class Api::Client::HomeController < Api::Client::BaseClientController
  skip_before_action :authenticate_account_user!
  def index
    top_five_categories = Category
                            .joins(:product_categories) # join qua bảng trung gian
                            .select("categories.*, COUNT(product_categories.product_id) AS products_count")
                            .group("categories.id")
                            .order("products_count DESC")
                            .limit(5)
    top_four_products = Product.order("total_sold DESC").limit(4)
    render_response(
      data: {
        categories: ActiveModelSerializers::SerializableResource.new(top_five_categories, each_serializer: CategorySerializer),
        products: ActiveModelSerializers::SerializableResource.new(top_four_products, each_serializer: ProductSerializer)
      },
      message: "Get data home successfully",
      status: 200
    )
  end
end
