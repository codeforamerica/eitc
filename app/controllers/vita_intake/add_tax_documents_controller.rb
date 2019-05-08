module VitaIntake
  class AddTaxDocumentsController < VitaIntakeFormsController

    def form_class
      AddTaxDocumentsForm
    end

    def update
      @form = form_class.new(current_record, form_params)
      if @form.valid?
        @form.save
        update_session
        track_form_progress
        send_application_to_front
        redirect_to(next_path)
      else
        track_validation_errors
        render :edit
      end
    end

    def send_application_to_front
      FrontService.instance.send_client_application(current_record)
    end
  end
end
