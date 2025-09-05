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

    rescue_from ActiveRecord::RecordNotFound do |e|
      render_response(message: "#{e.model} not found", status: 404)
    end
    rescue_from ActiveRecord::RecordNotUnique do |e|
      message = "Validation failed"
      errors = []

      if e.message =~ /unique constraint "([^"]+)"/
        constraint = Regexp.last_match(1)

        case constraint
        when /products/
          model = "Product"
        when /product_variants/
          model = "Product variant"
        when /product_images/
          model = "Product image"
        else
          model = "UnknownModel"
        end

        if e.message =~ /Key \((.+)\)=\((.+)\) already exists/
          column = Regexp.last_match(1)
          value = Regexp.last_match(2)
          errors << "#{model} #{column} - #{value} has already been taken\n"
        else
          errors << "#{model} record already exists\n"
        end
      end
      render_response(
        message: "Validation failed",
        errors: errors,
        status: 422
      )
    end
  end
end
