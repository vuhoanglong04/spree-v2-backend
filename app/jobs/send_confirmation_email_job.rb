class SendConfirmationEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    email , token = args
    user = AccountUser.find_by(email: email)
    Devise::Mailer.confirmation_instructions(user, token).deliver_later
  end
end
