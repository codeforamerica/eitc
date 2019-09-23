module CredentialsHelper
  class << self
    def secret_key_for_encryption
      encoded_value = environment_credential_for_key(:secret_key_for_encryption)
      Base64.decode64(encoded_value)
    end

    def twilio_phone_number
      environment_credential_for_key(:twilio_phone_number, alternate_value: "15553338888")
    end

    def vita_admin_user
      environment_credential_for_key(:vita_admin_user, alternate_value: "eitc")
    end

    def vita_admin_password
      environment_credential_for_key(:vita_admin_password, alternate_value: "eitc")
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
