class EmailConfirmationToClientJob < ApplicationJob
  def perform(email:)
    ApplicationMailer.vita_intake_confirmation(email).deliver
  end
end
