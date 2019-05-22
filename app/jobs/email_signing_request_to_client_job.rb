class EmailSigningRequestToClientJob < ApplicationJob
  def perform(email:, link:)
    ApplicationMailer.vita_signing_request(email, link).deliver
  end
end
