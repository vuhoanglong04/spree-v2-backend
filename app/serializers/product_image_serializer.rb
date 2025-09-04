class ProductImageSerializer < ActiveModel::Serializer
  attributes :id, :url, :alt, :position
end
