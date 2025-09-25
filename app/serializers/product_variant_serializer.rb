class ProductVariantSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id,
             :sku,
             :name,
             :origin_price,
             :price,
             :stock_qty,
             :stripe_product_id,
             :stripe_price_id,
             :deleted_at,
             :created_at,
             :updated_at
  has_many :attribute_values do
    object.attribute_values.map do |av|
      pivot = object.product_variant_attr_values.find_by(attribute_value_id: av.id)
      {
        id: av.id,
        value: av.value,
        extra: av.extra,
        product_variant_attr_value_id: pivot&.id
      }
    end
  end
end
