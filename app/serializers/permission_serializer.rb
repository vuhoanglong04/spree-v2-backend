class PermissionSerializer < ActiveModel::Serializer
  attributes :id, :subject, :action_name
end
