class Api::Admin::ProductsController < Api::BaseController
  # GET /products or /products.json
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    products = Product.with_deleted.order("updated_at desc").all.page(page).per(per_page)
    render_response(data: {
      products: ActiveModelSerializers::SerializableResource.new(products, each_serializer: ProductSerializer)
    },
                    message: "Get all products successfully!",
                    status: 200,
                    meta: pagination_meta(products)
    )
  end

  # GET /products/1 or /products/1.json
  def show
    product = Product.with_deleted.find_by!(id: params[:id])
    render_response(
      data: {
        product: ActiveModelSerializers::SerializableResource.new(product, serializer: ProductSerializer)
      },
      message: "Get product successfully!",
      status: 200
    )
  end

  # GET /products/new
  def new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    CreateProductForm.new(create_product_params)
    product_attrs = create_product_params.to_h.deep_dup
    product_attrs[:product_images_attributes].each do |index, image_data|
      url = S3UploadService.upload(image_data[:file], "products")
      image_data.delete(:file)
      image_data[:url] = url
    end
    product_attrs[:product_variants_attributes]["0"][:name] = product_attrs[:name]
    product_attrs[:product_variants_attributes]["0"][:image_url] = product_attrs[:product_images_attributes]["0"][:url]
    product = Product.new(product_attrs)
    if product.save
      render_response(
        data: {
          product: ActiveModelSerializers::SerializableResource.new(product, serializer: ProductSerializer)
        },
        message: "Create product successfully!",
        status: 201
      )
    else
      raise ValidationError.new("Validation failed", product.errors.to_hash(full_messages: true))
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    product = Product.with_deleted.find_by!(id: params[:id])
    UpdateProductForm.new(update_product_params)
    new_params = update_product_params.to_h.deep_dup

    ActiveRecord::Base.transaction do
      # Delete old categories
      ProductCategory.where(product_id: params[:id]).destroy_all
      if new_params[:product_images_attributes].present?
        new_params[:product_images_attributes].each do |_idx, img|
          if img[:file].present?
            url = S3UploadService.upload(img[:file], "products")
            img.delete(:file)
            img[:url] = url
          else
            img.delete(:file)
          end
        end
      end

      unless product.update(new_params)
        raise ValidationError.new("Validation failed", product.errors.to_hash(full_messages: true))
      end
    end

    render_response(
      data: {
        product: ActiveModelSerializers::SerializableResource.new(product, serializer: ProductSerializer)
      },
      message: "Update product successfully!",
      status: 200
    )
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    product = Product.without_deleted.find_by!(id: params[:id])
    product.destroy
    render_response(data: nil, message: "Deleted product", status: 200)
  end

  # POST /products/1/restore
  def restore
    product = Product.only_deleted.find_by!(id: params[:id])
    Product.restore(product.id)
    render_response(data: nil, message: "Restored product", status: 200)
  end

  private

  # Only allow a list of trusted parameters through.
  def create_product_params
    params.require(:product).permit(
      :name,
      :slug,
      :description,
      :brand,
      :favourite_count,
      product_images_attributes: [:file, :alt, :position],
      product_categories_attributes: [:category_id],
      product_variants_attributes: [:id, :sku, :origin_price, :price, :stock_qty]
    )
  end

  def update_product_params
    params.require(:product).permit(
      :name,
      :slug,
      :description,
      :brand,
      :favourite_count,
      product_categories_attributes: [:id, :category_id, :_destroy],
      product_images_attributes: [:id, :file, :alt, :position, :url, :_destroy],
      product_variants_attributes: [:id, :sku, :origin_price, :price, :stock_qty, :_destroy]
    )
  end
end
