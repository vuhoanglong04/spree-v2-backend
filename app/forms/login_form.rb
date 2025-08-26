# frozen_string_literal: true

class LoginForm
  include ActiveModel::Model
  attr_accessor :email, :password
  validates :email, presence: { message: "Email is required" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email format" }
  validates :password, presence: { message: "Password is required" }

  def initialize(attributes = {})
    super(attributes)
    validate!
  end

  def validate!
    raise ValidationError.new("Validation failed", errors) unless valid?
  end
end
