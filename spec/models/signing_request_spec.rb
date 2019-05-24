require 'rails_helper'

RSpec.describe ReminderContact, type: :model do
  describe "#federal_signature_page" do
    xit "retrieves the first page of the signature documents" do
      signing_request = SigningRequest.create
      signing_request.signature_document.attach(
          io: File.open("spec/fixtures/pdfs/ColoradoSignatureDocuments.pdf"),
          filename: "signature_pages.pdf",
          content_type: "application/pdf"
      )

      File.open("Federal page.pdf", "wb") do |file|
        file.write(signing_request.federal_signature_page)
      end
    end
  end
end
