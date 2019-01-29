class IncomeForm < Form
  set_attributes_for :eitc_estimate, :income

  validates_presence_of :income, message: "Please answer this question."

  def save
    record.update(attributes_for(:eitc_estimate))
  end
end