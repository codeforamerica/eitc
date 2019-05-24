module VitaSigning
  class FederalSignaturePagePreviewController < VitaSigningFormsController
    def edit
      send_data(current_signing_request.federal_signature_page, filename: "Federal Signature Page.pdf", type: 'application/pdf', disposition: 'inline')
    end

    def form_class
      NullForm
    end
  end
end
