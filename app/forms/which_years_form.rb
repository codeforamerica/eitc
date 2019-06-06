class WhichYearsForm < Form
  set_attributes_for :vita_client, tax_years: []

  validates_presence_of :tax_years, message: "Make sure to choose the years you want help with."

  def save
    record.update(tax_years: tax_years)
  end
end