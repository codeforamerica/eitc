class AreYouMarriedForm < Form
  set_attributes_for :vita_client, :has_spouse

  def save
    record.update(attributes_for(:vita_client))
  end
end