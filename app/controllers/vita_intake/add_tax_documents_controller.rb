module VitaIntake
  class AddTaxDocumentsController < VitaIntakeFormsController
    def self.show?(vita_client)
      vita_client.ready_to_upload_docs?
    end

    def form_class
      AddTaxDocumentsForm
    end
  end
end
