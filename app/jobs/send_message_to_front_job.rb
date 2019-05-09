class SendMessageToFrontJob < ApplicationJob
  def perform(vita_client:)
    FrontService.instance.send_client_application(vita_client)
  end
end