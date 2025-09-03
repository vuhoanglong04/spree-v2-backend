class Api::Admin::UserRolesController < Api::BaseController

  # GET /user_roles or /user_roles.json
  def index
    user_roles = UserRole.where(account_user_id: params[:account_user_id])
    render_response(data: {
      roles: ActiveModelSerializers::SerializableResource.new(user_roles, each_serializer: UserRoleSerializer)
    },
                    message: "Get all role successfully",
                    status: 200
    )
  end

  # GET /user_roles/1 or /user_roles/1.json
  def show
  end

  # GET /user_roles/new
  def new
  end

  # GET /user_roles/1/edit
  def edit
  end

  # POST /user_roles or /user_roles.json
  def create
    user_role = UserRole.new(user_role_params)
    if user_role.save
      render_response(message: "Added role", status: 201)
    else
      raise ValidationError.new("Validation failed", user_role.errors.to_hash(full_messages: true))
    end
  end

  # PATCH/PUT /user_roles/1 or /user_roles/1.json
  def update
  end

  # DELETE /user_roles/1 or /user_roles/1.json
  def destroy
    UserRole.find_by!(id: params[:id]).destroy
    render_response(message: "Deleted this role", status: 200)
  end

  private

  # Only allow a list of trusted parameters through.
  def user_role_params
    params.permit(:id, :account_user_id, :role_id)
  end
end
