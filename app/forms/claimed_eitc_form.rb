class ClaimedEitcForm < Form
  set_attributes_for :eitc_estimate, :claimed_eitc

  def save
    record.update(attributes_for(:eitc_estimate))
  end
end