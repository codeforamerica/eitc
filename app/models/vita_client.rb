class VitaClient < ApplicationRecord
  include StatesHelper

  has_many :household_members
  has_many_attached :tax_documents
  has_many_attached :identity_documents

  def married?
    has_spouse == 'yes'
  end

  def dependents?
    has_dependents == 'yes'
  end

  def spouse
    household_members.where(relation: :spouse).first
  end

  def added_spouse?
    married? && spouse.present?
  end

  def primary_filer
    household_members.where(relation: :primary_filer).first
  end

  def dependents
    household_members.where(relation: :dependent)
  end

  def analytics_data
    {}
  end

  def local_signed_at
    signed_at.in_time_zone(timezone)
  end

  def timezone
    timezone_for_state(state)
  end
end
