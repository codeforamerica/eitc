class TextApprovalConfirmationToClientJob < ApplicationJob
  def perform(phone_number:)
    message = "Hello from GetYourRefund.org! We have received your signed approval to file your state and federal " +
        "taxes. Our tax preparers will submit your taxes and you should receive your refund within the next 3-4 " +
        "weeks. Reply to this msg any time for more info."

    SmsClient.send(to: phone_number,
                   from: CredentialsHelper.twilio_phone_number,
                   message: message)
  end
end
