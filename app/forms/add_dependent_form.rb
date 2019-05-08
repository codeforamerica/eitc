class AddDependentForm < Form
  set_attributes_for :household_member, :first_name, :last_name, :birthdate, :full_time_student, :non_citizen, :disabled, :legally_blind

  validates_presence_of :first_name, message: "Make sure to provide a first name."
  validates_presence_of :last_name, message: "Make sure to provide a last name."
  validates_presence_of :birthdate, message: "Make sure to provide a date of birth."

  def save
    record.update(attributes_for(:household_member))
  end
end