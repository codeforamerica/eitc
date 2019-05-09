class FakeSmsClient
  class << self
    def send(to:, from:, message:)
      @@sent_messages ||= []
      @@sent_messages.push(OpenStruct.new(to: to, from: from, message: message))
    end

    def clear
      @@sent_messages = []
    end

    def sent_messages
      @@sent_messages ||= []
    end
  end
end
