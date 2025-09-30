class AccountUser < ApplicationRecord
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
  has_one :cart, dependent: :destroy
  has_many :cart_items, through: :cart
  accepts_nested_attributes_for :user_profile
end
