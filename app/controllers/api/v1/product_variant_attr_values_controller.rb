class Api::V1::ProductVariantAttrValuesController < ApplicationController
  before_action :set_product_variant_attr_value, only: %i[ show edit update destroy ]

  # GET /product_variant_attr_values or /product_variant_attr_values.json
  def index
    @product_variant_attr_values = ProductVariantAttrValue.all
  end

  # GET /product_variant_attr_values/1 or /product_variant_attr_values/1.json
  def show
  end

  # GET /product_variant_attr_values/new
  def new
    @product_variant_attr_value = ProductVariantAttrValue.new
  end

  # GET /product_variant_attr_values/1/edit
  def edit
  end

  # POST /product_variant_attr_values or /product_variant_attr_values.json
  def create
    @product_variant_attr_value = ProductVariantAttrValue.new(product_variant_attr_value_params)

    respond_to do |format|
      if @product_variant_attr_value.save
        format.html { redirect_to @product_variant_attr_value, notice: "Product variant attr value was successfully created." }
        format.json { render :show, status: :created, location: @product_variant_attr_value }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product_variant_attr_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_variant_attr_values/1 or /product_variant_attr_values/1.json
  def update
    respond_to do |format|
      if @product_variant_attr_value.update(product_variant_attr_value_params)
        format.html { redirect_to @product_variant_attr_value, notice: "Product variant attr value was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @product_variant_attr_value }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_variant_attr_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_variant_attr_values/1 or /product_variant_attr_values/1.json
  def destroy
    @product_variant_attr_value.destroy!

    respond_to do |format|
      format.html { redirect_to product_variant_attr_values_path, notice: "Product variant attr value was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_variant_attr_value
      @product_variant_attr_value = ProductVariantAttrValue.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def product_variant_attr_value_params
      params.fetch(:product_variant_attr_value, {})
    end
end
