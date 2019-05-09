module CredentialsHelper
  class << self

    def twilio_phone_number
      environment_credential_for_key(:twilio_phone_number, alternate_value: "15553338888")
    end

    def environment_credential_for_key(key, alternate_value: nil)
      if alternate_value.present? && (Rails.env.test? || Rails.env.development?)
        alternate_value
      else
        Rails.application.credentials.dig(Rails.env.to_sym, key.to_sym)
      end
    end
  end
end
