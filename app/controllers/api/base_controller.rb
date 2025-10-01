class Api::BaseController < ActionController::API
  # before_action :authenticate_account_user!
  include ExceptionHandler
  include ResponseHandler
  include PaginateHandler
  include Pundit::Authorization

  private

  def authenticate_admin!
    authenticate_account_user!

    unless current_account_user&.role == "admin"
      render_response(
        message: "You are not authorized",
        status: 403
      )
    end
  end
end