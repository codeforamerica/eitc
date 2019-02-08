class FiledRecentlyForm < Form
  set_attributes_for :eitc_estimate, :filed_recently

  def save
    record.update(attributes_for(:eitc_estimate))
  end
end