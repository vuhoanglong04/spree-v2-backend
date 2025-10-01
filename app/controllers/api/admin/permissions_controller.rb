class Api::Admin::PermissionsController < Api::BaseController

  # GET /permissions or /permissions.json
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 50
    permissions = Permission.all.page(page).per(per_page)
    permissions = permissions.group_by(&:subject).map do |subject, perms|
      {
        permissions: ActiveModelSerializers::SerializableResource.new(
          perms,
          each_serializer: PermissionSerializer
        )
      }
    end
    render_response(
      data: {
        permissions: permissions
      },
      message: "Get all permissions successfully.",
      status: 200)
  end

  # GET /permissions/1 or /permissions/1.json
  def show
    permission = Permission.find_by!(id: params[:id])
    render_response(
      data: {
        permissions: ActiveModelSerializers::SerializableResource.new(permissions, serializer: PermissionSerializer)
      },
      message: "Get permission successfully.",
      status: 200)
  end

  # GET /permissions/new
  def new
  end

  # GET /permissions/1/edit
  def edit
  end

  # POST /permissions or /permissions.json
  def create
    permission = Permission.new(permission_params)
    if permission.save
      render_response(
        data: {
          permissions: ActiveModelSerializers::SerializableResource.new(permissions, serializer: PermissionSerializer)
        },
        message: "Create permission successfully",
        status: 201
      )
    else
      raise ValidationError.new("Validation failed", permission.errors.to_hash(full_messages: true))
    end
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
  def permission_params
    params.permit(:page, :per_page, :id, :action_name, :subject, :description)
  end
end
