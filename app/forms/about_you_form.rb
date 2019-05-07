class AboutYouForm < Form
  set_attributes_for :household_member, :first_name, :last_name, :birth_date, :full_time_student, :non_citizen, :disabled, :no_special_cases

  validates_presence_of :first_name, message: "Make sure to provide a first name."
  validates_presence_of :last_name, message: "Make sure to provide a last name."
  validates_presence_of :birth_date, message: "Make sure to provide a date of birth."

  def save
    record.update(attributes_for(:household_member))
  end
end