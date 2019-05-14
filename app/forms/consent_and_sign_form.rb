class ConsentAndSignForm < Form
  set_attributes_for :vita_client, :signature, :spouse_signature, :signature_ip, :signed_at

  validates_presence_of :signature

  def save
    record.update(attributes_for(:vita_client))
  end
end