class TextConfirmationToClientJob < ApplicationJob
  def perform(phone_number:)
    message = "Hello from GetYourRefund.org! We have received your tax information. "  +
        "Our tax preparers will review it and be in touch within the next few days. " +
        "Reply to this msg any time for more info."

    SmsClient.send(to: phone_number,
                   from: CredentialsHelper.twilio_phone_number,
                   message: message)
  end
end
