module VitaIntake
  class ConsentAndSignController < VitaIntakeFormsController
    def form_params
      super.merge(signature_ip: request.remote_ip, signed_at: Time.now)
    end

    def track_form_progress
      SendMessageToFrontJob.perform_later(vita_client: current_vita_client)
      TextConfirmationToClientJob.perform_later(phone_number: current_vita_client.phone_number)
      EmailConfirmationToClientJob.perform_later(email: current_vita_client.email)
      super
    end
  end
end
