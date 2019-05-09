module VitaIntake
  class AnythingElseController < VitaIntakeFormsController

    def form_class
      AnythingElseForm
    end

    def update
      @form = form_class.new(current_record, form_params)
      if @form.valid?
        @form.save
        update_session
        track_form_progress
        SendMessageToFrontJob.perform_later(vita_client: current_vita_client)
        TextConfirmationToClientJob.perform_later(phone_number: current_vita_client.phone_number)
        EmailConfirmationToClientJob.perform_later(email: current_vita_client.email)
        redirect_to(next_path)
      else
        track_validation_errors
        render :edit
      end
    end
  end
end
