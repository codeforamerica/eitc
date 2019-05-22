class SigningRequestController < ApplicationController

  def index
    if params[:email]
      @vita_client = VitaClient.find_by_email(params[:email])
    end
  end

  def create
    if params[:vita_client_id]
      @vita_client = VitaClient.find_by_id(params[:vita_client_id])
      @signature_document = params[:signature_document]
      @prepared_return = params[:prepared_return]
      signing_request = SigningRequest.new(vita_client_id: @vita_client.id, email: @vita_client.email, unique_key: self.class.generate_unique_key)
      signing_request.signature_document.attach(@signature_document)
      signing_request.prepared_return.attach(@prepared_return)
      signing_request.save

      EmailSigningRequestToClientJob.perform_later(email: @vita_client.email, link: signing_request.signature_url )
    end
  end

  def show
    if params[:unique_key]
      @signing_request = SigningRequest.find_by_unique_key(params[:unique_key])
      if @signing_request.expired?
        # TODO: handle expired links
      end
    end
  end

  def sign
    if params[:signing_request_id]
      @signing_request = SigningRequest.find_by_id(params[:signing_request_id])
      @signing_request.federal_signature = params[:federal_signature]
      @signing_request.state_signature = params[:state_signature]
      @signing_request.federal_signature_spouse = params[:federal_signature_spouse]
      @signing_request.state_signature_spouse = params[:federal_signature_spouse]
      @signing_request.signed_at = Time.now
      @signing_request.signature_ip = request.remote_ip
      @signing_request.save

      SendApprovalToFrontJob.perform_later(vita_client: @signing_request.vita_client)
      EmailApprovalConfirmationToClientJob.perform_later(email: @signing_request.vita_client.email)
      TextApprovalConfirmationToClientJob.perform_later(phone_number: @signing_request.vita_client.phone_number)

    end
  end

  def self.generate_unique_key
    SecureRandom.urlsafe_base64(5)
  end

end

