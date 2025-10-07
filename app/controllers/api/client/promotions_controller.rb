class Api::Client::PromotionsController < Api::Client::BaseClientController
  def show
    promotion = Promotion.find_by!(code: params[:code])
    render_response(
      data: {
        promotion: ActiveModelSerializers::SerializableResource.new(promotion, serializer: PromotionSerializer)
      },
      message: "Get promotion successfully",
      status: 200
    )
  end

  private

  def promotion_params

  end
end
