class Api::Client::BaseClientController < ActionController::API
  before_action :authenticate_account_user!
  include ExceptionHandler
  include ResponseHandler
  include PaginateHandler
  include BuildTreeHandler
  include Pundit::Authorization

  def pundit_user
    current_account_user
  end
end