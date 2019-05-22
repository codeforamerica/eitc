class EmailApprovalConfirmationToClientJob < ApplicationJob
  def perform(email:)
    ApplicationMailer.vita_approval_confirmation(email).deliver
  end
end
