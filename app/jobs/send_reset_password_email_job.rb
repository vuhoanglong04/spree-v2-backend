class SendResetPasswordEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    email, token = args
    user = AccountUser.find_by(email: email)
    Devise::Mailer.reset_password_instructions(user, token).deliver_later
  end
end
