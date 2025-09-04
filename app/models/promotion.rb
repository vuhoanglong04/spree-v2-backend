class Promotion < ApplicationRecord
  enum :promotion_type, { percentage: 0, fixed: 1 }
  acts_as_paranoid

  validates :code,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :promotion_type,
            presence: true

  validates :value,
            presence: true,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: 100,
              if: -> { promotion_type == "percentage" }
            }

  validates :value,
            presence: true,
            numericality: {
              greater_than: 0
            },
            if: -> { promotion_type == "fixed" }

  validates :usage_limit,
            numericality: { only_integer: true, greater_than: 0 },
            allow_nil: true

  validates :per_user_limit,
            numericality: { only_integer: true, greater_than: 0 },
            allow_nil: true

  validates :min_order_amount,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
