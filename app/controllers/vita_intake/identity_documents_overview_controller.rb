module VitaIntake
  class IdentityDocumentsOverviewController < VitaIntakeFormsController
    def self.show?(vita_client)
      vita_client.ready_to_upload_docs?
    end

    def current_step
      2
    end

    def form_class
      NullForm
    end
  end
end
