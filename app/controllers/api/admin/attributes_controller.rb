class Api::Admin::AttributesController < Api::BaseController
  # GET /attributes or /attributes.json
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    attributes = Attribute.with_deleted.all.page(page).per(per_page)
    render_response(
      data: {
        attributes: ActiveModelSerializers::SerializableResource.new(attributes, each_serializer: AttributeSerializer),
      },
      message: "Get all attributes successfully",
      status: 200
    )
  end

  # GET /attributes/1 or /attributes/1.json
  def show
    attribute = Attribute.with_deleted.find_by!(id: params[:id])
    render_response(
      data: {
        attributes: ActiveModelSerializers::SerializableResource.new(attribute, serializer: AttributeSerializer),
      },
      message: "Get attribute successfully",
      status: 200
    )
  end

  # GET /attributes/new
  def new
  end

  # GET /attributes/1/edit
  def edit
  end

  # POST /attributes or /attributes.json
  def create
    attribute = Attribute.new(attribute_params)
    if attribute.save
      render_response(
        data: {
          attribute: ActiveModelSerializers::SerializableResource.new(attribute, serializer: AttributeSerializer)
        },
        message: "Create attribute successfully",
        status: 201
      )
    else
      raise ValidationError.new("Validation failed", attribute.errors.to_hash(full_messages: true))
    end
  end

  # PATCH/PUT /attributes/1 or /attributes/1.json
  def update
    attribute = Attribute.with_deleted.find_by!(id: params[:id])
    if attribute.update(attribute_params)
      render_response(
        data: {
          attribute: ActiveModelSerializers::SerializableResource.new(attribute, serializer: AttributeSerializer)
        },
        message: "Update attribute successfully",
        status: 201
      )
    else
      raise ValidationError.new("Validation failed", attribute.errors.to_hash(full_messages: true))
    end
  end

  # DELETE /attributes/1 or /attributes/1.json
  def destroy
    Attribute.without_deleted.find_by!(id: params[:id]).destroy
    render_response(message: "Deleted attribute", status: 200)
  end

  # POST /attributes/1
  def restore
    attribute = Attribute.only_deleted.find_by!(id: params[:id])
    Attribute.restore(attribute.id)
    render_response(message: "Restored attribute", status: 200)
  end

  private

  # Only allow a list of trusted parameters through.
  def attribute_params
    params.permit(:page,
                  :per_page,
                  :id,
                  :name,
                  :slug,
                  :description,
                  attribute_values_attributes: [:id, :value, :extra]
    )
  end
end
