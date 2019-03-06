class SlackService
  include Singleton

  def post_to_workforce_alerts(data)
    @url = CredentialsHelper.environment_credential_for_key(:workforce_alerts_slack_url)
    return unless @url
    json_payload = data.to_json
    HTTParty.post(@url, body: json_payload, headers: {'Content-Type' => 'application/json' })
  end
end
