class SigningRequest < ApplicationRecord
  include StatesHelper

  belongs_to :vita_client

  has_one_attached :prepared_return
  has_one_attached :signature_document

  def expired?
    created_at < 5.days.ago
  end

  def signature_url
    default_url_options = Rails.application.config.action_mailer.default_url_options
    Rails.application.routes.url_helpers.welcome_vita_signing_index_url(unique_key: unique_key, **default_url_options)
  end

  def local_signed_at
    signed_at.in_time_zone(vita_client.timezone)
  end

  def federal_signature_page
    signature_page(1)
  end

  def state_signature_page
    signature_page(2)
  end

  def analytics_data
    {
        vita_client_id: vita_client.id
    }
  end

  private

  def signature_page(page_number)
    full_file = Tempfile.new("sig_pages.pdf", "tmp/", encoding: "ascii-8bit")
    full_file << signature_document.download
    fed_page = CombinePDF.new
    fed_page << CombinePDF.load(full_file.path).pages[page_number - 1]
    fed_page.to_pdf
  end

end
