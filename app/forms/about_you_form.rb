class AboutYouForm < HouseholdMemberForm
  set_attributes_for :household_member, :first_name, :last_name, :birthdate_year, :birthdate_month,
                     :birthdate_day, :full_time_student, :non_citizen, :disabled, :legally_blind

  def save
    record.save
    if record.primary_filing_member.present?
      record.primary_filing_member.update(household_member_attributes)
    else
      record.household_members.create(household_member_attributes.merge(relation: :primary_filer))
    end
  end

  def self.existing_attributes(record)
    if record.primary_filing_member.present?
      attributes = record.primary_filing_member.attributes
      %i[year month day].each do |sym|
        attributes["birthdate_#{sym}"] = record.primary_filing_member.birthdate.try(sym)
      end
      HashWithIndifferentAccess.new(attributes)
    else
      {}
    end
  end
end