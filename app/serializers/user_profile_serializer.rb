class UserProfileSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :phone, :avatar_url, :locale, :time_zone
end
