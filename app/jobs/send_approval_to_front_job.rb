class SendApprovalToFrontJob < ApplicationJob
  def perform(signing_request:)
    FrontService.instance.send_signed_approval(signing_request)
  end
end