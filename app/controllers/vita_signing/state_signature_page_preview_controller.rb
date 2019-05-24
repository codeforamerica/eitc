module VitaSigning
  class StateSignaturePagePreviewController < VitaSigningFormsController
    def edit
      send_data(current_signing_request.state_signature_page, filename: "State Signature Page.pdf", type: 'application/pdf', disposition: 'inline')
    end

    def form_class
      NullForm
    end
  end
end
