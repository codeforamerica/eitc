class FrontService
  include Singleton

  def send_message_to_front_intake(data)
    @url = CredentialsHelper.environment_credential_for_key(:front_custom_channel_url)
    @api_key = CredentialsHelper.environment_credential_for_key(:front_api_key)
    return unless @url && @api_key
    json_payload = data.to_json
    HTTParty.post(@url,
                  body: json_payload,
                  headers: {
                      'Content-Type' => 'application/json',
                      'Authorization' => "Bearer #{@api_key}",
                      'Accept' => 'application/json'
                  })
  end

  def send_message_with_attachment(attachment)
    @url = CredentialsHelper.environment_credential_for_key(:front_custom_channel_url)
    @api_key = CredentialsHelper.environment_credential_for_key(:front_api_key)
    return unless @url && @api_key

    request = RestClient::Request.new(
        :method => :post,
        :url => @url,
        :payload => {
            :multipart => true,
            :attachments => [attachment],
            :body => 'Tax document upload via Custom Intake Form<br><br><ul><li>Birthdate: 08/26/1978</li><li>Has Spouse: Yes</li></ul>',
            :body_format => 'html',
            :sender => {:handle => 'lou@codeforamerica.org'}
        },
        :headers => {
            'Content-Type' => 'multipart/form-data',
            :Authorization => "Bearer #{@api_key}",
            :Accept => 'application/json'
        })

    puts request.payload
    puts request.headers

    response = request.execute
  end

  def send_client_application(vita_client)
    @url = CredentialsHelper.environment_credential_for_key(:front_custom_channel_url)
    @api_key = CredentialsHelper.environment_credential_for_key(:front_api_key)
    return unless @url && @api_key

    attachments = []

    vita_client.tax_documents.each do |tax_doc|
      attachments.push stringfile(tax_doc.blob.download, tax_doc.blob.filename, tax_doc.blob.content_type)
    end
    vita_client.identity_documents.each do |identity_doc|
      attachments.push stringfile(identity_doc.blob.download, identity_doc.blob.filename, identity_doc.blob.content_type)
    end

    body = "Tax document upload via Custom Intake Form<br><br><ul><li>Phone Number: #{vita_client.phone_number}</li></ul>"

    request = RestClient::Request.new(
        :method => :post,
        :url => @url,
        :payload => {
            :multipart => true,
            :attachments => attachments,
            :body => body,
            :body_format => 'html',
            :sender => {:handle => 'lou@codeforamerica.org'}
        },
        :headers => {
            'Content-Type' => 'multipart/form-data',
            :Authorization => "Bearer #{@api_key}",
            :Accept => 'application/json'
        })

    puts request.payload
    puts request.headers

    response = request.execute
  end

  private

  def stringfile(string,
                 filename="file_#{rand 100000}",
                 type=MIME::Types.type_for("xml").first.content_type)
    file = StringIO.new(string)
    file.instance_variable_set(:@path, filename.to_s)
    def file.path
      @path
    end
    file.instance_variable_set(:@type, type.to_s)
    def file.content_type
      @type
    end

    return file
  end
end
