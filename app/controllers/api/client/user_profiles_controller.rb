class Api::Client::UserProfilesController < Api::Client::BaseClientController
  def show
    account_user = AccountUser.find_by!(email: params[:email])
    user_profile = account_user.user_profile
    render_response(
      data: {
        user_profile: user_profile.present? ? ActiveModelSerializers::SerializableResource.new(
          user_profile,
          serializer: UserProfileSerializer
        ) : nil,
        created_at: account_user.created_at,
        total_order: account_user.orders.size,
        total_spent: account_user.orders.sum(:total_amount)
      },
      message: "Get information user successfully",
      status: 200
    )
  end

  def update
    account_user = AccountUser.find_by!(id: params[:account_user_id])
    user_profile = account_user.user_profile

    if user_profile # User profile exist
      if user_profile_params[:avatar_url].present?
        if user_profile.avatar_url.present?
          S3UploadService.delete_by_url(user_profile.avatar_url)
        end
        avatar_url = S3UploadService.upload(user_profile_params[:avatar_url], "account_users")
        user_profile.avatar_url = avatar_url
      end
      if user_profile.update(user_profile_params.except(:avatar_url))
        render_response(
          data: {
            user_profile: ActiveModelSerializers::SerializableResource.new(
              user_profile,
              serializer: UserProfileSerializer
            ),
            created_at: account_user.created_at,
            total_order: account_user&.orders&.size,
            total_spent: account_user&.orders&.sum(:total_amount)
          },
        )
      else
        raise ValidationError.new("Validation failed", user_profile.errors.to_hash(full_messages: true))
      end

    else
      # Create new user profile

      new_profile = account_user.create_user_profile!(
        user_profile_params
      )
      render_response(
        data: {
          user_profile: ActiveModelSerializers::SerializableResource.new(
            new_profile,
            serializer: UserProfileSerializer
          ),
          message: "Update profile successfully",
          created_at: account_user.created_at,
          total_order: account_user&.orders&.size,
          total_spent: account_user&.orders&.sum(:total_amount)
        },
      )
    end
  end

  private

  def user_profile_params
    params.permit(:account_user_id, :full_name, :phone, :locale, :time_zone, :avatar_url)
  end
end
