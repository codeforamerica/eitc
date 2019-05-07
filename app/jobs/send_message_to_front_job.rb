class SendMessageToFrontJob < ApplicationJob
  def perform(vita_client:)
    FrontService.instance.send_message_to_front_intake({
      sender: {
        handle: vita_client.email,
      },
      body: "some text that we would send",
      attachments: [],
      metadata: {}
    })
  end
end