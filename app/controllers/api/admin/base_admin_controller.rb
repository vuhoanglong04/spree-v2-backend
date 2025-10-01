class Api::Admin::BaseAdminController < ActionController::API
  before_action :authenticate_account_user!
  include ExceptionHandler
  include ResponseHandler
  include PaginateHandler
  include Pundit::Authorization

  def me
    authenticate_account_user!
    render_response(message: "Authorized", status: 200)
  end
  def authenticate_account_user!
    unless current_account_user&.main_role == "staff"
      render_response(
        message: "You are not authorized",
        status: 403
      )
    end
  end
end