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
    if current_account_user.nil? || current_account_user&.main_role != "staff"
      raise Pundit::NotAuthorizedError
    end
  end

  def pundit_user
    current_account_user
  end
end
