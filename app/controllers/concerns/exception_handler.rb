# app/controllers/concerns/exception_handler.rb
module ExceptionHandler
  extend ActiveSupport::Concern
  included do
    rescue_from AuthenticationError, ValidationError do |e|
      render_response(message: e.message, errors: e.errors, status: 401)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render_response(message: "Validation failed", errors: e.record.errors.full_messages, status: 401)
    end
  end
end
