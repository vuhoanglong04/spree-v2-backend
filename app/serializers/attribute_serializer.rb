class AttributeSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id, :name, :slug, :description, :deleted_at, :created_at, :updated_at
  has_many :attribute_values
end
