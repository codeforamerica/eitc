module CredentialsHelper
  class << self
    def environment_credential_for_key(key)
      Rails.application.credentials.dig(Rails.env.to_sym, key.to_sym)
    end
  end
end
