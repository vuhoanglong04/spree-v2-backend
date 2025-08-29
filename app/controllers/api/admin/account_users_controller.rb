class Api::Admin::AccountUsersController < Api::BaseController

  # GET /account_users
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    account_users = AccountUser.select("id,email,status,confirmed_at,created_at,updated_at").page(page).per(per_page)
    render_response(data:
                      { account_users:
                          ActiveModelSerializers::SerializableResource.new(account_users, each_serializer: AccountUserSerializer)
                      },
                    message: "Get all account user successfully",
                    meta: pagination_meta(account_users),
                    status: 200
    )
  end

  # GET /account_users/1 or /account_users/1.json
  def show
    account_user = AccountUser.select("id,email,status,confirmed_at,created_at,updated_at")
                              .find_by(id: params[:id])
    render_response(data:
                      { account_user:
                          ActiveModelSerializers::SerializableResource.new(account_user, serializer: AccountUserSerializer)
                      },
                    message: "Get account user successfully",
                    status: 200
    )
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
      render_response(data: {
        account_user: ActiveModelSerializers::SerializableResource.new(account_user, serializer: AccountUserSerializer)
      },
                      message: "Create account user successfully",
                      status: 201)
    else
      raise ValidationError.new("Validation failed", account_user.errors.to_hash(full_messages: true))
    end
  end

  # PATCH/PUT /account_users/1 or /account_users/1.json
  def update

  end

  # DELETE /account_users/1 or /account_users/1.json
  def destroy
  end

  private

  def account_user_params
    params
      .require(:account_user)
      .permit(:email, :status, :password, :password_confirmation,
              user_profile_attributes: [:full_name, :phone, :avatar_url, :locale, :time_zone])
  end
end
