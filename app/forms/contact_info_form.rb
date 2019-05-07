class ContactInfoForm < Form
  set_attributes_for :vita_client, :phone_number, :email, :sms_consent

  validates_presence_of :phone_number, message: "Make sure to provide a phone number."
  validates_presence_of :email, message: "Make sure to provide an email."

  def save
    record.update(attributes_for(:vita_client))
  end
end