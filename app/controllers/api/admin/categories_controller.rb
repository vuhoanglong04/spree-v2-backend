class Api::Admin::CategoriesController < Api::BaseController

  # GET /categories or /categories.json
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    categories = Category.with_deleted.order(:position).page(page).per(per_page)
    render_response(data: {
      categories: ActiveModelSerializers::SerializableResource.new(categories, each_serializer: CategorySerializer),
    },
                    message: "Get all categories successfully",
                    status: 200
    )
  end

  # GET /categories/1 or /categories/1.json
  def show
    category = Category.with_deleted.find_by!(id: params[:id])
    render_response(data: {
      category: ActiveModelSerializers::SerializableResource.new(category, each_serializer: CategorySerializer)
    },
                    message: "Get a category successfully",
                    status: 200
    )
  end

  # GET /categories/new
  def new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    category = Category.new(category_params)
    if category.save
      CategoryClosure.create!(ancestor: category.id, descendant: category.id, depth: 0)
      if category_params[:parent_id]
        CategoryClosure.where(descendant: category_params[:parent_id]).each do |parent|
          CategoryClosure.create!(ancestor: parent.ancestor, descendant: category.id, depth: parent.depth + 1)
        end
      end
      render_response(
        data: {
          category: ActiveModelSerializers::SerializableResource.new(category, each_serializer: CategorySerializer)
        },
        message: "Create a category successfully",
        status: 201
      )
    else
      raise ValidationError.new("Validation failed", category.errors.to_hash(full_messages: true))
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    category = Category.with_deleted.find_by!(id: params[:id])
    if category.update(category_params) \
      # Change parent category
      if category_params[:parent_id]
        # Delete all records where this category is descendant
        CategoryClosure.where(descendant: category.id).where.not(ancestor_id: category.id).destroy_all
        # Create new links from this category to its ancestors
        CategoryClosure.where(descendant: category_params[:parent_id]).each do |parent|
          CategoryClosure.create!(ancestor: parent.ancestor, descendant: category.id, depth: parent.depth + 1)
        end
      end
      render_response(data: {
        category: ActiveModelSerializers::SerializableResource.new(category, each_serializer: CategorySerializer)
      },
                      message: "Update a category successfully",
                      status: 200)
    else
      raise ValidationError.new("Validation failed", category.errors.to_hash(full_messages: true))
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    Category.without_deleted.find_by!(id: params[:id]).destroy
    render_response(message: "Deleted category", status: 200)
  end

  # POST /categories/1/restore
  def restore
    category = Category.only_deleted.find_by!(id: params[:id])
    Category.restore(category.id)
    render_response(message: "Restored category", status: 200)
  end

  private

  # Only allow a list of trusted parameters through.
  def category_params
    params.permit(:page, :per_page, :id, :name, :slug, :position, :parent_id)
  end
end
