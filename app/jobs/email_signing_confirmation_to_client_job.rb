class EmailSigningConfirmationToClientJob < ApplicationJob
  def perform(email:)
    ApplicationMailer.vita_signing_confirmation(email).deliver
  end
end
