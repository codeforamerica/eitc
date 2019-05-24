class StateEfileForm < Form
  set_attributes_for :vita_admin, :state_signature, :state_signature_spouse

  validates_presence_of :state_signature, message: "Make sure to sign if you'd like to continue"

  def save
    record.update(attributes_for(:vita_admin))
  end
end