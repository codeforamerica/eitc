module VitaIntake
  class AddIdentityDocumentsController < VitaIntakeFormsController
    def self.show?(vita_client)
      vita_client.ready_to_upload_docs?
    end

    def form_class
      AddIdentityDocumentsForm
    end
  end
end
