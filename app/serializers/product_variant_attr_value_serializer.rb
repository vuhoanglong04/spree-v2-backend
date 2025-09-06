class ProductVariantAttrValueSerializer < ActiveModel::Serializer
  attributes :id, :attribute_value_id
  belongs_to :attribute_value
end
