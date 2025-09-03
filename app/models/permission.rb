class Permission < ApplicationRecord
  validates :action_name, :subject, presence: true
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions
end
