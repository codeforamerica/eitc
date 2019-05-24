module VitaSigning
  class PreparedReturnPreviewController < VitaSigningFormsController
    def edit
      send_data(current_signing_request.prepared_return.download, filename: "Prepared Tax Returns.pdf", type: 'application/pdf', disposition: 'inline')
    end

    def form_class
      NullForm
    end
  end
end
