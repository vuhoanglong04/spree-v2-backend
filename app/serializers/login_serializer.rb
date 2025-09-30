class LoginSerializer < ActiveModel::Serializer
  attributes :id, :email, :status, :main_role
  has_one :user_profile
  has_many :cart_items
end
