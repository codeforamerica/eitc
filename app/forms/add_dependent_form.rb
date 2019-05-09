class AddDependentForm < Form
  set_attributes_for :household_member, :first_name, :last_name, :birthdate_year, :birthdate_month,
                     :birthdate_day, :full_time_student, :non_citizen, :disabled, :legally_blind

  validates_presence_of :first_name, message: "Make sure to provide a first name."
  validates_presence_of :last_name, message: "Make sure to provide a last name."
  attr_internal_reader :birthdate
  validates :birthdate, date: true

  def save
    record.update(household_member_attributes)
  end

  private

  def household_member_attributes
    attributes = attributes_for(:household_member)
    attributes[:birthdate] = to_datetime(birthdate_year, birthdate_month, birthdate_day)
    attributes.except(
        :birthdate_year,
        :birthdate_month,
        :birthdate_day,
        )
  end
end