class PermissionSerializer < ActiveModel::Serializer
  include SerializerConcern
  attributes :id, :subject, :action_name, :description, :created_at, :updated_at
end
