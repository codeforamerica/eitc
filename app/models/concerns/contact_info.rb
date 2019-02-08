module ContactInfo
  extend ActiveSupport::Concern

  included do
    validate :email_or_phone_number?
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Make sure to provide a valid email address." }, allow_blank: true
    validates :phone_number, phone: { message: "Make sure to provide a valid phone number." }, allow_blank: true

    def email_or_phone_number?
      unless email.present? || phone_number.present?
        errors.add :phone_number, "Make sure to enter a phone number or email."
        errors.add :email, "Make sure to enter a phone number or email."
      end
    end
  end
end