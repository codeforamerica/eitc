class SigningRequest < ApplicationRecord
  belongs_to :vita_client

  has_one_attached :prepared_return
  has_one_attached :signature_document

  def expired?
    created_at < 5.days.ago
  end

  def signature_url
    default_url_options = Rails.application.config.action_mailer.default_url_options
    Rails.application.routes.url_helpers.signature_url(unique_key: unique_key, **default_url_options)
  end

end
