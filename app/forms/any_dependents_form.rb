class AnyDependentsForm < Form
  set_attributes_for :vita_client, :has_dependents

  def save
    record.update(attributes_for(:vita_client))
  end
end