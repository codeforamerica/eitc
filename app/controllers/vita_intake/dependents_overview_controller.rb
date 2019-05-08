module VitaIntake
  class DependentsOverviewController < VitaIntakeFormsController
    def self.show?(vita_client)
      vita_client.dependents?
    end

    def form_class
      NullForm
    end
  end
end
