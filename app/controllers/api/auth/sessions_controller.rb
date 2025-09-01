# frozen_string_literal: true

class Api::Auth::SessionsController < Devise::SessionsController
  include ResponseHandler
  include ExceptionHandler
  skip_before_action :verify_signed_out_user, only: [:destroy]
  # GET /resource/sign_in
  # def new
  # end

  # POST /resource/sign_in
  def create
    LoginForm.new(session_params)
    self.resource = warden.authenticate(auth_options)
    if resource.present?
      sign_in(resource_name, resource)
      render_response(data: {
        user: ActiveModelSerializers::SerializableResource.new(resource, serializer: LoginSerializer),
        refresh_token: RefreshTokenService.issue(resource.id)
      },
                      message: "Login successful",
                      status: 201)
    else
      raise AuthenticationError
    end
  end

  # DELETE /resource/sign_out
  def destroy
    token = request.cookies['access_token'] ||
            request.headers['Authorization']&.split(' ')&.last
    if token.present?
      payload = JWT.decode(token, ENV["JWT_SECRET_KEY"], true, algorithm: 'HS256')[0]
      user_id = payload['sub'] || payload['user_id']
      user = AccountUser.find_by(id: user_id)
      JwtRedisDenyList.revoke_jwt(payload, user) if user.present?
    end
    if session_params[:refresh_token].present?
      RefreshTokenService.revoke(session_params[:refresh_token])
    end
    render_response(
      message: "Logged out successfully",
      status: 200
    )
  end

  # POST /resource/refresh
  def refresh
    user_id = RefreshTokenService.verify(session_params[:refresh_token])
    if user_id.present?
      user = AccountUser.find_by(id: user_id)
      raise AuthenticationError, "User not found" if user.nil?
      sign_in(resource_name, user)
      render_response(data: {
        user: ActiveModelSerializers::SerializableResource.new(user, serializer: AccountUserSerializer),
        refresh_token: RefreshTokenService.rotate(session_params[:refresh_token], user_id)
      },
                      message: "Refresh token successful",
                      status: 201)
    else
      raise AuthenticationError, "Refresh token is invalid"
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def session_params
    params.require(:account_user).permit(:email, :password, :refresh_token)
  end

  def respond_to_on_destroy
    render_response(
      message: "Logged out successfully",
      status: 200
    )
  end
end
