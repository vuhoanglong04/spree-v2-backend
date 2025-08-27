class Api::Admin::AccountUsersController < Api::BaseController
  before_action :authenticate_account_user!

  def test
    render_response(data: "OK", message: "OKOKOK", status: 200)
  end

  def index

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

  end

  # PATCH/PUT /account_users/1 or /account_users/1.json
  def update

  end

  # DELETE /account_users/1 or /account_users/1.json
  def destroy
  end
end
