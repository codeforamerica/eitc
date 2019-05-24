class VitaAdminController < ApplicationController
  layout "vita_intake/form_card"

  def index
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
        redirect_to vita_admin_index_path
      else
        flash.now[:error] = "You must attach both a Signature Document and a Prepared Return"
        render "index"
      end
    end
  end

  def self.generate_unique_key
    SecureRandom.urlsafe_base64(13)
  end

end

