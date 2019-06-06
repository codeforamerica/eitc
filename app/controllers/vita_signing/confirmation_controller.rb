module VitaSigning
  class ConfirmationController < VitaSigningFormsController
    after_action :clear_session

    def form_class
      NullForm
    end
  end
end
