class SigningRequestController < ApplicationController
  layout "vita_intake/form_card"

  def new
    if params.has_key?(:email)
      @vita_client = VitaClient.find_by_email(params[:email])
    end
  end

  def create
    if params.has_key?(:vita_client_id)
      @vita_client = VitaClient.find_by_id(params[:vita_client_id])
      @signature_document = params[:signature_document]
      @prepared_return = params[:prepared_return]
      @signing_request = SigningRequest.new(vita_client_id: @vita_client.id, email: @vita_client.email, unique_key: self.class.generate_unique_key)
      @signing_request.signature_document.attach(@signature_document)
      @signing_request.prepared_return.attach(@prepared_return)
      @signing_request.save

      EmailSigningRequestToClientJob.perform_later(email: @vita_client.email, link: @signing_request.signature_url )
      if @signature_document.present? && @prepared_return.present?
        flash[:success] = "A request for e-file authorization signature has been sent to #{@vita_client.email}"
        redirect_to start_signing_request_path
      else
        flash.now[:error] = "You must attach both a Signature Document and a Prepared Return"
        render "new"
      end
    end
  end

  def confirm
  end

  def show
    if params.has_key?(:unique_key)
      @signing_request = SigningRequest.find_by_unique_key(params[:unique_key])
      if @signing_request.expired?
        @signing_request = nil
        flash.now[:error] = "Sorry, this link has expired. Please contact our tax prep volunteers by email at vita-support@codeforamerica.org or by text at 720-728-0704 to request a new link."
      end
    end
  end

  def update
    if params.has_key?(:signing_request_id)
      @signing_request = SigningRequest.find_by_id(params[:signing_request_id])
      if !params[:federal_signature].blank? && !params[:state_signature].blank?
        @signing_request.federal_signature = params[:federal_signature]
        @signing_request.state_signature = params[:state_signature]

        unless params[:federal_signature_spouse].blank? || params[:state_signature_spouse].blank?
          @signing_request.federal_signature_spouse = params[:federal_signature_spouse]
          @signing_request.state_signature_spouse = params[:federal_signature_spouse]
        end

        @signing_request.signed_at = Time.now
        @signing_request.signature_ip = request.remote_ip
        @signing_request.save

        SendApprovalToFrontJob.perform_later(vita_client: @signing_request.vita_client)
        EmailApprovalConfirmationToClientJob.perform_later(email: @signing_request.vita_client.email)
        TextApprovalConfirmationToClientJob.perform_later(phone_number: @signing_request.vita_client.phone_number)

        flash[:success] = "You're done! You should receive email and text confirmations of receipt of your signed tax returns shortly."
        return redirect_to signature_confirm_path(signature_unique_key: @signing_request.unique_key)
      else
        flash.now[:error] = "You must electronically sign for your federal and state tax returns."
        render "show"
      end
    end
  end

  def self.generate_unique_key
    SecureRandom.urlsafe_base64(5)
  end

end

