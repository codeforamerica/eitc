module VitaIntake
  class IdentityDocumentIntroController < VitaIntakeFormsController
    skip_before_action :ensure_vita_client_present

    def current_step
      2
    end

    def form_class
      NullForm
    end

  end
end
