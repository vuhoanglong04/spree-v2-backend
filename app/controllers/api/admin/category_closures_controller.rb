class Api::Admin::CategoryClosuresController < ApplicationController
  before_action :set_category_closure, only: %i[ show edit update destroy ]

  # GET /category_closures or /category_closures.json
  def index
    @category_closures = CategoryClosure.all
  end

  # GET /category_closures/1 or /category_closures/1.json
  def show
  end

  # GET /category_closures/new
  def new
    @category_closure = CategoryClosure.new
  end

  # GET /category_closures/1/edit
  def edit
  end

  # POST /category_closures or /category_closures.json
  def create
    @category_closure = CategoryClosure.new(category_closure_params)

    respond_to do |format|
      if @category_closure.save
        format.html { redirect_to @category_closure, notice: "Category closure was successfully created." }
        format.json { render :show, status: :created, location: @category_closure }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category_closure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /category_closures/1 or /category_closures/1.json
  def update
    respond_to do |format|
      if @category_closure.update(category_closure_params)
        format.html { redirect_to @category_closure, notice: "Category closure was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @category_closure }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category_closure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /category_closures/1 or /category_closures/1.json
  def destroy
    @category_closure.destroy!

    respond_to do |format|
      format.html { redirect_to category_closures_path, notice: "Category closure was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category_closure
      @category_closure = CategoryClosure.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def category_closure_params
      params.fetch(:category_closure, {})
    end
end
