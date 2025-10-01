class Api::Admin::PermissionsController < Api::Admin::BaseAdminController

  # GET /permissions or /permissions.json
  def index
    permissions = Permission.all
    render_response(
      data: {
        permissions: ActiveModelSerializers::SerializableResource.new(permissions, each_serializer: PermissionSerializer)
      },
      message: "Get all permissions successfully.",
      status: 200)
  end

  # GET /permissions/1 or /permissions/1.json
  def show
  end

  # GET /permissions/new
  def new
  end

  # GET /permissions/1/edit
  def edit
  end

  # POST /permissions or /permissions.json
  def create
  end

  # PATCH/PUT /permissions/1 or /permissions/1.json
  def update
    permission = Permission.find_by!(id: params[:id])
    if permission.update(permission_params)
      render_response(
        data: {
          permissions: ActiveModelSerializers::SerializableResource.new(permissions, serializer: PermissionSerializer)
        },
        message: "Update permission successfully",
        status: 201
      )
    else
      raise ValidationError.new("Validation failed", permission.errors.to_hash(full_messages: true))
    end
  end

  # DELETE /permissions/1 or /permissions/1.json
  def destroy
    Permission.find_by!(id: params[:id]).destroy
    render_response(message: "Deleted permission", status: 200)
  end

  private

  # Only allow a list of trusted parameters through.
  def update_permission_params
    params.permit(:id, :subject, :action, :_destroy)
  end
end
