module VitaIntake
  class VitaConsentPdfPreviewController < VitaIntakeFormsController
    def edit
      assembler = IntakePdfAssembler.new(current_vita_client)
      send_data(assembler.consent_pdf_file.read, filename: assembler.filename, type: 'application/pdf', disposition: 'inline')
    end

    def form_class
      NullForm
    end
  end
end
