class AnythingElseForm < Form
  set_attributes_for :vita_client, :anything_else

  def save
    record.update(attributes_for(:vita_client))
  end
end