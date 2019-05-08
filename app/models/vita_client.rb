class VitaClient < ApplicationRecord
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

  def primary_filing_member
    household_members.where(relation: :primary_filer).first
  end

  def dependents
    household_members.where(relation: :dependent)
  end

  def analytics_data
    {}
  end
end
