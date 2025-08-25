class Api::Admin::UserIdentitiesController < ApplicationController
  before_action :set_user_identity, only: %i[ show edit update destroy ]

  # GET /user_identities or /user_identities.json
  def index
    @user_identities = UserIdentity.all
  end

  # GET /user_identities/1 or /user_identities/1.json
  def show
  end

  # GET /user_identities/new
  def new
    @user_identity = UserIdentity.new
  end

  # GET /user_identities/1/edit
  def edit
  end

  # POST /user_identities or /user_identities.json
  def create
    @user_identity = UserIdentity.new(user_identity_params)

    respond_to do |format|
      if @user_identity.save
        format.html { redirect_to @user_identity, notice: "User identity was successfully created." }
        format.json { render :show, status: :created, location: @user_identity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_identities/1 or /user_identities/1.json
  def update
    respond_to do |format|
      if @user_identity.update(user_identity_params)
        format.html { redirect_to @user_identity, notice: "User identity was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user_identity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_identity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_identities/1 or /user_identities/1.json
  def destroy
    @user_identity.destroy!

    respond_to do |format|
      format.html { redirect_to user_identities_path, notice: "User identity was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_identity
      @user_identity = UserIdentity.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_identity_params
      params.fetch(:user_identity, {})
    end
end
