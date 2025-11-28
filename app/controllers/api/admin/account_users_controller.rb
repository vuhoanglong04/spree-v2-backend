class Api::Admin::AccountUsersController < Api::Admin::BaseAdminController
  before_action :authorize_account_user
  # GET /account_users
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    account_users = AccountUser
                      .select("id,email,status,main_role,confirmed_at,created_at,updated_at")
                      .order("created_at DESC")
                      .page(page).per(per_page)
    render_response(
      data:
        {
          account_users: ActiveModelSerializers::SerializableResource.new(account_users, each_serializer: AccountUserSerializer)
        },
      message: "Get all account user successfully",
      meta: pagination_meta(account_users),
      status: 200
    )
  end

  # GET /account_users/1 or /account_users/1.json
  def show
  end

  # GET /account_users/new
  def new
  end

  # GET /account_users/1/edit
  def edit
  end

  # POST /account_users or /account_users.json
  def create
    CreateAccountUserForm.new(account_user_params)
    account_user = AccountUser.new(account_user_params)
    avatar_url = S3UploadService.upload(account_user_params[:user_profile_attributes][:avatar_url], "account_users")
    account_user.user_profile.avatar_url = avatar_url
    if account_user.save
      render_response(
        data: {
          account_user: account_user
        },
        message: "Create account user successfully",
        status: 201)
    else
      raise ValidationError.new("Validation failed", account_user.errors.to_hash(full_messages: true))
    end
  end

  # PATCH/PUT /account_users/1 or /account_users/1.json
  def update
    UpdateAccountUserForm.new(account_user_params)
    account_user = AccountUser.find_by!(id: params[:id])
    if account_user.update(account_user_params)
      if account_user_params.dig(:user_profile_attributes, :avatar_url).present?
        S3UploadService.delete_by_url(account_user.user_profile.avatar_url) unless account_user.user_profile&.avatar_url.nil?
        avatar_url = S3UploadService.upload(account_user_params[:user_profile_attributes][:avatar_url], "account_users")
        account_user.user_profile.avatar_url = avatar_url
        account_user.save
      end
      render_response(
        data: {
          account_user: account_user
        },
        message: "Update account user successfully",
        status: 200)
    else
      raise ValidationError.new("Validation failed", account_user.errors.to_hash(full_messages: true))
    end
  end

  # DELETE /account_users/1 or /account_users/1.json
  def destroy
    AccountUser.find_by!(id: params[:id]).destroy
    render_response(message: "Destroy account user successfully", status: 200)
  end

  def role
    account_user = AccountUser.select("id,email,status,main_role,confirmed_at,created_at,updated_at")
                              .find_by(id: params[:id])
    render_response(
      data:
        {
          account_user: ActiveModelSerializers::SerializableResource.new(account_user, each_serializer: AccountUserSerializer)
        },
      message: "Get account user successfully",
      status: 200
    )
  end

  private

  def account_user_params
    params
      .permit(:email, :status, :password, :password_confirmation, :main_role,
              user_profile_attributes: [ :full_name, :phone, :avatar_url, :locale, :time_zone ])
  end

  def authorize_account_user
    authorize current_account_user, policy_class: AccountUserPolicy
  end
end
