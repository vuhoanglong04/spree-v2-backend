class Api::Admin::ProductsController < Api::BaseController
  # GET /products or /products.json
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    products = Product.all.page(page).per(per_page)
    render_response(data: {
      products: ActiveModelSerializers::SerializableResource.new(products, each_serializer: ProductSerializer)
    },
                    message: "Get all products successfully!",
                    status: 200
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

    ActiveRecord::Base.transaction do
      unless product.update(update_product_params[:product])
        raise ValidationError.new("Validation failed", product.errors.to_hash(full_messages: true))
      end
      # Images
      unless update_product_params[:images].empty?
        new_image_ids = []
        update_product_params[:images].each do |index, img|
          image_data = img
          url = S3UploadService.upload(image_data["file"], "products")
          image_data.delete("file")
          image_data[:url] = url
          new_image = product.product_images.create!(image_data)
          new_image_ids << new_image.id
        end
      end

      # Categories
      unless update_product_params[:categories].empty?
        ProductCategory.where(product_id: product.id).destroy_all
        update_product_params[:categories].each do |index, c|
          product.product_categories.create!(c)
        end
      end

      # Variant
      if update_product_params[:product_variant].present?
        variant = ProductVariant.with_deleted.find_by!(id: update_product_params[:product_variant][:id])
        variant.update!(update_product_params[:product_variant])
      end
      unless update_product_params[:images].empty?
        ProductImage.where(product_id: product.id).where.not(id: new_image_ids).destroy_all
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
    render_response(message: "Deleted product", status: 200)
  end

  # POST /products/1/restore
  def restore
    product = Product.only_deleted.find_by!(id: params[:id])
    Product.restore(product.id)
    render_response(message: "Restored product", status: 200)
  end

  private

  # Only allow a list of trusted parameters through.
  def create_product_params
    params.permit(
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
    params.permit(
      product: [
        :name,
        :slug,
        :description,
        :brand,
        :favourite_count,
      ],
      categories: [:category_id],
      images: [:file, :alt, :position],
      product_variant: [
        :id,
        :sku,
        :origin_price,
        :price,
        :stock_qty
      ]
    )
  end
end
