class FileReturnsForm < Form
  set_attributes_for :vita_admin, :signature_ip, :signed_at

  def save
    record.update(attributes_for(:vita_admin))
  end
end