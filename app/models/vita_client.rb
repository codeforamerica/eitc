class VitaClient < ApplicationRecord
  include StatesHelper
  include SourcesHelper

  has_many :household_members
  has_many :signing_requests
  has_many_attached :tax_documents
  has_many_attached :identity_documents
  attribute :last_four_ssn
  attr_encrypted(:last_four_ssn, key: CredentialsHelper.secret_key_for_encryption)
  attribute :last_four_ssn_spouse
  attr_encrypted(:last_four_ssn_spouse, key: CredentialsHelper.secret_key_for_encryption)

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
    {
      source: full_source,
      referrer: referrer,
      state: state,
    }
  end

  def local_signed_at
    signed_at.in_time_zone(timezone)
  end

  def timezone
    timezone_for_state(state)
  end

  def formatted_phone_number
    Phonelib.parse(phone_number).local_number
  end

  def tel_link_phone_number
    "+1#{Phonelib.parse(phone_number).sanitized}"
  end

  def looks_fake?
    source == "demo"
  end

  def ready_to_upload_docs?
    # when null, return true
    ready_to_submit_docs != false
  end
end
