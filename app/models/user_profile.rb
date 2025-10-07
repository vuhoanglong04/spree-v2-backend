class UserProfile < ApplicationRecord
  # Relationships
  belongs_to :account_user

  # Validations
  validates :account_user_id, presence: true

  validates :full_name,
            presence: true,
            length: { maximum: 255 }

  validates :phone,
            presence: true,
            length: { maximum: 20 }

  validates :locale,
            presence: true,
            inclusion: {
              in: %w[en vi fr ja zh],
              message: "%{value} is not a supported locale"
            },
            allow_blank: true
end
