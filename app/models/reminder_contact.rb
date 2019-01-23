class ReminderContact < ApplicationRecord
  validate :email_or_phone_number?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :phone_number, phone: true, allow_blank: true

  def email_or_phone_number?
    unless email.present? || phone_number.present?
      errors.add :phone_number, "Please enter a phone number or email."
      errors.add :email, "Please enter a phone number or email."
    end
  end
end
