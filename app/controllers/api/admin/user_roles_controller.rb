class Api::Admin::UserRolesController < Api::Admin::BaseAdminController
  # GET /user_roles or /user_roles.json
  def index
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
    authorize current_account_user, :role?, policy_class: AccountUserPolicy
    UserRole.where(account_user_id: params[:account_user_id]).delete_all
    user_role_params.each do |user_role|
      new_user_role = UserRole.create(user_role)
      if new_user_role.save
      else
        raise ValidationError.new("Validation failed", new_user_role.errors.to_hash(full_messages: true))
      end
    end
    render_response(message: "Change roles successfully", status: 201)
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

  private

  def user_role_params
    params.permit(user_roles: [ :id, :account_user_id, :role_id ])[:user_roles]
  end
end
