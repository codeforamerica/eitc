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
end
