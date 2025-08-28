class Api::BaseController < ActionController::API
  # before_action :authenticate_account_user!
  include ExceptionHandler
  include ResponseHandler
end