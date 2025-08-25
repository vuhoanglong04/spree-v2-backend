class Api::Admin::RefundsController < ApplicationController
  before_action :set_refund, only: %i[ show edit update destroy ]

  # GET /refunds or /refunds.json
  def index
    @refunds = Refund.all
  end

  # GET /refunds/1 or /refunds/1.json
  def show
  end

  # GET /refunds/new
  def new
    @refund = Refund.new
  end

  # GET /refunds/1/edit
  def edit
  end

  # POST /refunds or /refunds.json
  def create
    @refund = Refund.new(refund_params)

    respond_to do |format|
      if @refund.save
        format.html { redirect_to @refund, notice: "Refund was successfully created." }
        format.json { render :show, status: :created, location: @refund }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @refund.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /refunds/1 or /refunds/1.json
  def update
    respond_to do |format|
      if @refund.update(refund_params)
        format.html { redirect_to @refund, notice: "Refund was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @refund }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @refund.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /refunds/1 or /refunds/1.json
  def destroy
    @refund.destroy!

    respond_to do |format|
      format.html { redirect_to refunds_path, notice: "Refund was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_refund
      @refund = Refund.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def refund_params
      params.fetch(:refund, {})
    end
end
