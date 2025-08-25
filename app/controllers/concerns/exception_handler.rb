# app/controllers/concerns/exception_handler.rb
module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      render_response(errors: e.message, status: :unauthorized)
    end
  end
end
