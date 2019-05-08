module VitaIntake
  class IdentityDocumentsOverviewController < VitaIntakeFormsController

    def current_step
      2
    end

    def form_class
      NullForm
    end

  end
end
