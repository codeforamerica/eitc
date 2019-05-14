class HouseholdMember < ApplicationRecord
  belongs_to :vita_client

  RELATION_CHOICES = %w(primary_filer spouse dependent)

  validates_inclusion_of :relation, :in => RELATION_CHOICES

  def analytics_data
    {}
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
