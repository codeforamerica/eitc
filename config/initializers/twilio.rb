if Rails.env.development? || Rails.env.test? || Rails.env.demo?
  require File.expand_path("#{Rails.root}/spec/support/fake_sms_client")
  SmsClient = FakeSmsClient
else
  Twilio.configure do |config|
    config.account_sid = CredentialsHelper.environment_credential_for_key(:twilio_account_sid)
    config.auth_token = CredentialsHelper.environment_credential_for_key(:twilio_auth_token)
  end
end
