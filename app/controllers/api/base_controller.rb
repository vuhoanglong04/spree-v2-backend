class Api::BaseController < ActionController::API
  include ExceptionHandler
  include ResponseHandler
end