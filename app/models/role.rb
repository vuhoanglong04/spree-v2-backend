class Role < ApplicationRecord
  # Relationship
  has_many :account_users, through: :user_roles
  has_many :user_roles, dependent: :destroy
  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions
  accepts_nested_attributes_for :role_permissions, allow_destroy: true
  # Validates
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
