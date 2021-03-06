class HouseholdMember < ApplicationRecord
  belongs_to :vita_client

  RELATION_CHOICES = %w(primary_filer spouse dependent)

  validates_inclusion_of :relation, :in => RELATION_CHOICES

  def full_time_student?
    full_time_student == '1'
  end

  def non_citizen?
    non_citizen == '1'
  end

  def disabled?
    disabled == '1'
  end

  def legally_blind?
    legally_blind == '1'
  end

  def analytics_data
    {}
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
