class Api::Admin::PromotionsController < Api::Admin::BaseAdminController

  # GET /promotions or /promotions.json
  def index
    page = params[:page] ||= 1
    per_page = params[:per_page] ||= 5
    promotions = Promotion.with_deleted.all.page(page).per(per_page)
    render_response(
      data: {
        promotions: ActiveModelSerializers::SerializableResource.new(promotions, each_serializer: PromotionSerializer)
      },
      message: "Get all promotions successfully.",
      status: 200
    )
  end

  # GET /promotions/1 or /promotions/1.json
  def show
    promotion = Promotion.with_deleted.find_by!(id: params[:id])
    render_response(
      data: {
        promotions: ActiveModelSerializers::SerializableResource.new(promotion, serializer: PromotionSerializer)
      },
      message: "Get promotion successfully.",
      status: 200
    )
  end

  # GET /promotions/new
  def new
  end

  # GET /promotions/1/edit
  def edit
  end

  # POST /promotions or /promotions.json
  def create
    promotion = Promotion.new(promotion_params)
    if promotion.save
      render_response(
        data: {
          promotions: ActiveModelSerializers::SerializableResource.new(promotion, serializer: PromotionSerializer)
        },
        message: "Create promotion successfully.",
        status: 200
      )
    else
      raise ValidationError.new("Validation failed", promotion.errors.to_hash(full_messages: true))
    end
  end

  # PATCH/PUT /promotions/1 or /promotions/1.json
  def update
    promotion = Promotion.with_deleted.find_by!(id: params[:id])
    if promotion.update(promotion_params)
      render_response(
        data: {
          promotions: ActiveModelSerializers::SerializableResource.new(promotion, serializer: PromotionSerializer)
        },
        message: "Update promotion successfully.",
        status: 200
      )
    else
      raise ValidationError.new("Validation failed", promotion.errors.to_hash(full_messages: true))
    end
  end

  # DELETE /promotions/1 or /promotions/1.json
  def destroy
    Promotion.with_deleted.find_by!(id: params[:id]).destroy
    render_response(message: "Deleted promotion successfully.", status: 200)
  end

  def restore
    promotion = Promotion.with_deleted.find_by!(id: params[:id])
    Promotion.restore(promotion.id)
    render_response(message: "Restored promotion successfully.", status: 200)
  end

  private

  # Only allow a list of trusted parameters through.
  def promotion_params
    params.permit(:page,
                  :per_page,
                  :id,
                  :code,
                  :promotion_type,
                  :value,
                  :usage_limit,
                  :min_order_amount,
                  :description,
                  :per_user_limit,
                  :start_date,
                  :end_date,
    )
  end
end
