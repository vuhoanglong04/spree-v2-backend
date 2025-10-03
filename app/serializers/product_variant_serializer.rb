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
             :updated_at,
             :attribute_values
  def attribute_values
    object.attribute_values.map do |av|
      pivot = object.product_variant_attr_values.find_by(attribute_value_id: av.id)
      {
        id: av.id,
        product_attribute_name: av.product_attribute&.name,
        value: av.value,
        extra: av.extra,
        product_variant_attr_value_id: pivot&.id
      }
    end
  end
end
