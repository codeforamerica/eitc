class FederalEfileForm < Form
  set_attributes_for :vita_admin, :federal_signature, :federal_signature_spouse

  validates_presence_of :federal_signature, message: "Make sure to sign if you'd like to continue"

  def save
    record.update(attributes_for(:vita_admin))
  end
end