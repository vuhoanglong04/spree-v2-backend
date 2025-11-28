class Api::Admin::ProductVariantsController < Api::Admin::BaseAdminController
  before_action :authorize_account_user
  # GET /product_variants or /product_variants.json
  def index
    product = Product.with_deleted.find_by!(id: params[:product_id])
    raw_variant = product.product_variants.order(:created_at).last
    product_variants = product.product_variants
                              .with_deleted
                              .where("id != ?", raw_variant.id)
                              .order("updated_at desc")
                              .to_a
    product_variants.unshift(raw_variant) if raw_variant.present?
    render_response(
      data: {
        product_variants: ActiveModelSerializers::SerializableResource.new(product_variants, each_serializer: ProductVariantSerializer)
      },
      message: "Get all product variants of product successfully",
      status: 200
    )
  end

  # GET /product_variants/1 or /product_variants/1.json
  def show
    product = Product.with_deleted.find_by!(id: params[:product_id])
    product_variants = ProductVariant.with_deleted.find_by!(id: params[:id], product_id: product.id)
    render_response(
      data: {
        product_variants: ActiveModelSerializers::SerializableResource.new(product_variants, each_serializer: ProductVariantSerializer)
      },
      message: "Get all product variants of product successfully",
      status: 200
    )
  end

  # GET /product_variants/new
  def new
  end

  # GET /product_variants/1/edit
  def edit
  end

  # POST /product_variants or /product_variants.json
  def create
    CreateProductVariantForm.new(product_variant_params)
    product_variant = ProductVariant.new(product_variant_params)
    if product_variant.save
      render_response(
        data: {
          product_variant: ActiveModelSerializers::SerializableResource.new(product_variant, serializer: ProductVariantSerializer)
        },
        message: "Create product variant successfully",
        status: 201
      )
    else
      raise ValidationError.new("Validation failed", product_variant.errors.to_hash(full_messages: true))
    end
  end

  # PATCH/PUT /product_variants/1 or /product_variants/1.json
  def update
    UpdateProductVariantForm.new(product_variant_params)
    product = Product.find_by!(id: params[:product_id])
    product_variant = ProductVariant.with_deleted.find_by!(id: params[:id], product_id: product.id)
    if product_variant.update(product_variant_params)
      render_response(
        data: {
          product_variant: ActiveModelSerializers::SerializableResource.new(product_variant, serializer: ProductVariantSerializer)
        },
        message: "Update product variant successfully",
        status: 200
      )
    else
      raise ValidationError.new("Validation failed", product_variant.errors.to_hash(full_messages: true))
    end
  end

  # DELETE /product_variants/1 or /product_variants/1.json
  def destroy
    ProductVariant.without_deleted.find_by!(id: params[:id]).destroy
    render_response(message: "Deleted variant", status: 200)
  end

  def restore
    variant = ProductVariant.only_deleted.find_by!(id: params[:id])
    ProductVariant.restore(variant.id)
    render_response(message: "Restored variant", status: 200)
  end

  private

  # Only allow a list of trusted parameters through.
  def product_variant_params
    params.permit(:product_id,
                  :sku,
                  :name,
                  :origin_price,
                  :price,
                  :stock_qty,
                  product_variant_attr_values_attributes: [ :id, :product_attribute_id, :attribute_value_id, :_destroy ]
    )
  end

  def authorize_account_user
    authorize current_account_user, policy_class: ProductVariantPolicy
  end
end
