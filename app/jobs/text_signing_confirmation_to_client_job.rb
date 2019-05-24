class TextSigningConfirmationToClientJob < ApplicationJob
  def perform(phone_number:)
    message = "Hello from GetYourRefund.org! We have received your signed federal and state tax returns." +
        "If you qualified for a refund, you should receive a check or direct deposit within the next month." +
        "Reply to this msg any time for more info."

    SmsClient.send(to: phone_number,
                   from: CredentialsHelper.twilio_phone_number,
                   message: message)
  end
end
