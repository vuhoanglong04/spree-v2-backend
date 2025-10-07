class Api::Client::CategoriesController < Api::Client::BaseClientController
  skip_before_action :authenticate_account_user!

  def index
    categories = Category.where(deleted_at: nil).arrange
    render_response(
      data: {
        categories: build_tree(categories),
      },
      message: "Get all categories successfully",
      status: 200
    )
  end

end
