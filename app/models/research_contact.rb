class ResearchContact < ApplicationRecord
  include ContactInfo

  before_create :assign_unique_token
  validates_presence_of :full_name, message: "Make sure to provide a name."

  def self.generate_unique_token
    SecureRandom.urlsafe_base64(5)
  end

  def assign_unique_token
    self.unique_token = self.class.generate_unique_token
  end

  def regenerate_unique_token
    update!(unique_token: self.class.generate_unique_token)
  end

  def eitc_estimate
    EitcEstimate.find_by(visitor_id: visitor_id)
  end
end
