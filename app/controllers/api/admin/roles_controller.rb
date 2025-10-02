class Api::Admin::RolesController < Api::Admin::BaseAdminController
  before_action :authorize_account_user
  # GET /roles or /roles.json
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    roles = Role.all.page(page).per(per_page)
    render_response(
      data:
        {
          roles: ActiveModelSerializers::SerializableResource.new(roles, each_serializer: RoleSerializer)
        },
      message: "Get all role successfully",
      meta: pagination_meta(roles),
      status: 200
    )
  end

  # GET /roles/1 or /roles/1.json
  def show
    role = Role.find_by!(id: params[:id])
    render_response(
      data: {
        role: ActiveModelSerializers::SerializableResource.new(role, serializer: RoleSerializer)
      },
      message: "Get role successfully",
      status: 200
    )
  end

  # GET /roles/new
  def new

  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles or /roles.json
  def create
    role = Role.new(role_params)
    if role.save
      render_response(
        data: {
          role: ActiveModelSerializers::SerializableResource.new(role, serializer: RoleSerializer)
        },
        message: "Create role successfully",
        status: 201
      )
    else
      raise ValidationError.new("Validation failed", role.errors.to_hash(full_messages: true))
    end
  end

  # PATCH/PUT /roles/1 or /roles/1.json
  def update
    role = Role.find_by!(id: params[:id])
    role.role_permissions.destroy_all
    if role.update(role_params)
      render_response(
        data: {
          role: ActiveModelSerializers::SerializableResource.new(role, serializer: RoleSerializer)
        },
        message: "Update role successfully",
        status: 201
      )
    else
      raise ValidationError.new("Validation failed", role.errors.to_hash(full_messages: true))
    end
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    role = Role.find_by!(id: params[:id]).destroy
    render_response(message: "Deleted role", status: 200)
  end

  private

  # Only allow a list of trusted parameters through.
  def role_params
    params.permit(:page,
                  :per_page,
                  :id,
                  :name,
                  :description,
                  role_permissions_attributes: [:permission_id, :_destroy]
    )
  end

  def authorize_account_user
    authorize current_account_user
  end
end
