class SendApprovalToFrontJob < ApplicationJob
  def perform(vita_client:)
    FrontService.instance.send_signed_approval(vita_client)
  end
end