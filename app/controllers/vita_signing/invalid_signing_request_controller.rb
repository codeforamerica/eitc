module VitaSigning
  class InvalidSigningRequestController < VitaSigningFormsController
    skip_before_action :ensure_valid_signing_request

    def form_class
      NullForm
    end
  end
end