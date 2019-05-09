class SmsClient
  class << self
    def send(to:, from:, message:)
      Twilio::REST::Client.new.messages.create(
        to: to,
        from: from,
        body: message,
      )
    end
  end
end
