class SigningRequest < ApplicationRecord
  belongs_to :vita_client

  def expired?
    created_at < 5.days.ago
  end
end
