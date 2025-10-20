class Api::Client::ProductAttributesController < Api::Client::BaseClientController
  skip_before_action :authenticate_account_user!
  def index
    attributes = ProductAttribute.all
    render_response(
      data: {
        attributes: ActiveModelSerializers::SerializableResource.new(attributes, each_serializer: ProductAttributeSerializer)
      },
      message: "Get all product attribute successfully",
      status: 200
    )
  end
end
