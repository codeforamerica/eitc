module VitaIntake
  class TaxDocumentsOverviewController < VitaIntakeFormsController

    def current_step
      3
    end

    def form_class
      NullForm
    end

  end
end
