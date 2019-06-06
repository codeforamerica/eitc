module VitaIntake
  class ConfirmationController < VitaIntakeFormsController
    after_action :clear_session

    def form_class
      NullForm
    end
  end
end
