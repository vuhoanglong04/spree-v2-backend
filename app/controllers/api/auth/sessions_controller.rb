# frozen_string_literal: true

class Api::Auth::SessionsController < Devise::SessionsController
  include ResponseHandler
  include ExceptionHandler
  respond_to :json
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  # end

  # POST /resource/sign_in
  def create
    LoginForm.new(session_params)
    self.resource = warden.authenticate!(auth_options)
    if resource.present?
      sign_in(resource_name, resource)
      render_response(data: resource, message: "Login successful", status: :created)
    else
      raise AuthenticationError
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def session_params
    params.require(:user).permit(:email, :password)
  end
end
