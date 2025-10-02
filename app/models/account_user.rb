class AccountUser < ApplicationRecord
  after_destroy :destroy_avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable,
         :confirmable,
         :jwt_authenticatable,
         :omniauthable, omniauth_providers: [:google_oauth2],
         jwt_revocation_strategy: JwtRedisDenyList

  enum :status, { active: 0, disabled: 1, blocked: 2 }
  enum :main_role, { customer: 0, staff: 1 }

  # Validates
  validates :email,
            presence: { message: "Email is required" },
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email format" }

  # Relationships
  has_many :user_identities, dependent: :destroy
  has_one :user_profile, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :role_permissions, through: :roles
  has_many :permissions, through: :role_permissions
  has_one :cart, dependent: :destroy
  has_many :cart_items, through: :cart
  accepts_nested_attributes_for :user_profile

  def has_permission?(subject, action)
    permissions.distinct.exists?(subject: subject, action_name: action)
  end

  private

  def destroy_avatar
    if self&.user_profile&.avatar_url.present?
      S3UploadService.delete_by_url(self.user_profile.avatar_url)
    end
  end
end
