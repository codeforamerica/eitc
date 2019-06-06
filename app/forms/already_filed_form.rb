class AlreadyFiledForm < Form
  set_attributes_for :vita_client, years_already_filed: []

  def save
    record.update(years_already_filed: years_already_filed || [])
  end
end