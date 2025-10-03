class Api::Client::BaseClientController < ActionController::API
  include ExceptionHandler
  include ResponseHandler
  include PaginateHandler
  include BuildTreeHandler
  include Pundit::Authorization

  def pundit_user
    current_account_user
  end
end