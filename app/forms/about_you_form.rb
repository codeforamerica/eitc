class AboutYouForm < HouseholdMemberForm
  set_attributes_for :household_member, :first_name, :last_name, :birthdate_year, :birthdate_month,
                     :birthdate_day, :full_time_student, :non_citizen, :disabled, :legally_blind

  def save
    record.save
    if record.primary_filer.present?
      record.primary_filer.update(household_member_attributes)
    else
      record.household_members.create(household_member_attributes.merge(relation: :primary_filer))
    end
  end

  def self.existing_attributes(record)
    if record.primary_filer.present?
      attributes = record.primary_filer.attributes
      %i[year month day].each do |sym|
        attributes["birthdate_#{sym}"] = record.primary_filer.birthdate.try(sym)
      end
      HashWithIndifferentAccess.new(attributes)
    else
      {}
    end
  end
end