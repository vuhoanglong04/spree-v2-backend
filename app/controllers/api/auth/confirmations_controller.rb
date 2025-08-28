# frozen_string_literal: true

class Api::Auth::ConfirmationsController < Devise::ConfirmationsController
  include ResponseHandler
  include ExceptionHandler
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirm_email
  def confirm_email
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      render_response(message: "Successfully confirmed. Please login", status: 200)
    else
      render_response(
        message: "Something went wrong. Please try again.",
        errors: resource.errors.full_messages,
        status: 422
      )
    end
  end

  def resend_confirmation_instructions
    user = AccountUser.find_by(email: params[:email])
    raise ValidationError, "User not found" if user.nil?
    raw_token, enc_token = Devise.token_generator.generate(AccountUser, :confirmation_token)
    user.confirmation_token = raw_token
    user.confirmation_sent_at = Time.current
    user.save(validate: false)
    user.send_confirmation_instructions
    render_response(message: "Sent confirmation instructions", status: 200)
  end

  # POST

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
