module VitaIntake
  class WelcomeController < VitaIntakeFormsController
    layout "vita_intake/hero"

    prepend_before_action :clear_session
    skip_before_action :ensure_vita_client_present

    def form_class
      NullForm
    end

  end
end
