class ResearchRegistrationForm < Form
  set_attributes_for :research_contact, :full_name, :email, :phone_number

  validates_presence_of :full_name, message: "Make sure to provide a name."
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Make sure to provide a valid email address." }, allow_blank: true
  validates_presence_of :email, message: "Make sure to enter an email address"
  validates :phone_number, phone: { message: "Make sure to provide a valid phone number." }, allow_blank: true
  validates_presence_of :phone_number, message: "Make sure to enter a phone number."

  def save
    record.update(attributes_for(:research_contact))
  end
end