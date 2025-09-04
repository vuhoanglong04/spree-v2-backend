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
    CreateProductForm.new(product_params)
    product_attrs = product_params.to_h.deep_dup
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
          product: ActiveModelSerializers::SerializableResource.new(product, serializer: ProductSerializer),
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

  end

  # DELETE /products/1 or /products/1.json
  def destroy
  end

  private

  # Only allow a list of trusted parameters through.
  def product_params
    params.permit(:page,
                  :per_page,
                  :id,
                  :name,
                  :slug,
                  :description,
                  :brand,
                  :favourite_count,
                  product_images_attributes: [:file, :alt, :position],
                  product_categories_attributes: [:category_id],
                  product_variants_attributes: [:sku, :origin_price, :price, :stock_qty]
    )
  end
end
