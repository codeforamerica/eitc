module VitaSigning
  class ConfirmationController < VitaSigningFormsController
    def form_class
      NullForm
    end
  end
end
