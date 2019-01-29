class FilingStatusForm < Form
  set_attributes_for :eitc_estimate, :status

  validates_presence_of :status, message: "Please answer this question."

  def save
    record.update(attributes_for(:eitc_estimate))
  end

  def self.existing_attributes(record)
    if record.present?
      HashWithIndifferentAccess.new(record.attributes)
    else
      {}
    end
  end
end