module VitaSigning
  class FileReturnsController < VitaSigningFormsController
    def form_params
      super.merge(signature_ip: request.remote_ip, signed_at: Time.now)
    end

    def track_form_progress
        SendApprovalToFrontJob.perform_later(signing_request: current_signing_request)
        EmailSigningConfirmationToClientJob.perform_later(email: current_signing_request.vita_client.email)
        TextSigningConfirmationToClientJob.perform_later(phone_number: current_signing_request.vita_client.phone_number)
      super
    end
  end
end
