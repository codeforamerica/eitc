class ConsentAndSignForm < Form
  set_attributes_for(:vita_client,
                     :signature, :last_four_ssn, :last_four_ssn_spouse, :spouse_signature, :signature_ip, :signed_at)

  validates_presence_of :signature, message: "Make sure to sign if you'd like to continue"

  def save
    record.update(attributes_for(:vita_client))
  end
end