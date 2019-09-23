class EmailSigningRequestToClientJob < ApplicationJob
  def perform(signing_request:)
    ApplicationMailer.vita_signing_request(signing_request: signing_request).deliver
  end
end
