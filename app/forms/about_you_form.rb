class AboutYouForm < Form
  set_attributes_for :household_member, :first_name, :last_name, :birthdate_year, :birthdate_month,
                     :birthdate_day, :full_time_student, :non_citizen, :disabled, :legally_blind

  validates_presence_of :first_name, message: "Make sure to provide a first name."
  validates_presence_of :last_name, message: "Make sure to provide a last name."
  attr_internal_reader :birthdate
  validates :birthdate, date: true

  def save
    record.save
    if record.primary_filing_member.present?
      record.primary_filing_member.update(primary_filing_member_attributes)
    else
      record.household_members.create(primary_filing_member_attributes.merge(relation: :primary_filer))
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

  private

  def primary_filing_member_attributes
    attributes = attributes_for(:household_member)
    attributes[:birthdate] = to_datetime(birthdate_year, birthdate_month, birthdate_day)
    attributes.except(
        :birthdate_year,
        :birthdate_month,
        :birthdate_day,
        )
  end

end