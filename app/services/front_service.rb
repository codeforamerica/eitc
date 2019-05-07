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

    # puts request.payload
    # puts request.headers

    response = request.execute
  end
end
