class FrontService
  include Singleton

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

    body = "New intake form received<br><br>"\
            "Primary Filer: #{vita_client.primary_filing_member.first_name} #{vita_client.primary_filing_member.last_name}<br>"\
            "<ul>"\
            "<li>Date of Birth: #{vita_client.primary_filing_member.birthdate.strftime("%m/%d/%Y")}</li>"\
            "<li>Email: #{vita_client.email}</li>"\
            "<li>Address: #{vita_client.street_address} #{vita_client.city} #{vita_client.zip}</li>"\
            "<li>Phone Number: #{vita_client.phone_number}</li>"\
            "<li>Can you receive text messages?: #{vita_client.sms_enabled ? 'yes' : 'no'}</li>"\
            "<li>Are you a full-time student?: #{vita_client.primary_filing_member.full_time_student ? 'yes' : 'no'}</li>"\
            "<li>Are you a non-citizen?: #{vita_client.primary_filing_member.non_citizen ? 'yes' : 'no'}</li>"\
            "<li>Are you disabled?: #{vita_client.primary_filing_member.disabled ? 'yes' : 'no'}</li>"\
            "<li>Are you legally blind?: #{vita_client.primary_filing_member.legally_blind ? 'yes' : 'no'}</li>"\
            "<li>Are you married?: #{vita_client.has_spouse ? 'yes' : 'no'}</li>"\
            "<li>Do you have any dependents?: #{vita_client.has_dependents ? 'yes' : 'no'}</li>"\
            "<li>Is anyone in your household self employed?: #{vita_client.anyone_self_employed ? 'yes' : 'no'}</li>"\
            "<li>Additional Info: #{vita_client.anything_else}</li>"\
            "</ul>"

    if vita_client.has_spouse
      body += "<br>"\
            "Spouse: #{vita_client.spouse.first_name} #{vita_client.spouse.last_name}<br>"\
            "<ul>"\
            "<li>Date of Birth: #{vita_client.spouse.birthdate.strftime("%m/%d/%Y")}</li>"\
            "<li>Are they a full-time student?: #{vita_client.spouse.full_time_student ? 'yes' : 'no'}</li>"\
            "<li>Are they a non-citizen?: #{vita_client.spouse.non_citizen ? 'yes' : 'no'}</li>"\
            "<li>Are they disabled?: #{vita_client.spouse.disabled ? 'yes' : 'no'}</li>"\
            "<li>Are they legally blind?: #{vita_client.spouse.legally_blind ? 'yes' : 'no'}</li>"\
            "</ul>"
    end

    if vita_client.has_dependents
      vita_client.dependents.each_with_index do |dependent, index|
        body += "<br>"\
            "Dependent ##{index+1}: #{dependent.first_name} #{dependent.last_name}<br>"\
            "<ul>"\
            "<li>Date of Birth: #{dependent.birthdate.strftime("%m/%d/%Y")}</li>"\
            "<li>Are they a full-time student?: #{dependent.full_time_student ? 'yes' : 'no'}</li>"\
            "<li>Are they a non-citizen?: #{dependent.non_citizen ? 'yes' : 'no'}</li>"\
            "<li>Are they disabled?: #{dependent.disabled ? 'yes' : 'no'}</li>"\
            "<li>Are they legally blind?: #{dependent.legally_blind ? 'yes' : 'no'}</li>"\
            "</ul>"
      end
    end

    request = RestClient::Request.new(
        :method => :post,
        :url => @url,
        :payload => {
            :multipart => true,
            :attachments => attachments,
            :body => body,
            :body_format => 'html',
            :sender => {:handle => vita_client.email}
        },
        :headers => {
            'Content-Type' => 'multipart/form-data',
            :Authorization => "Bearer #{@api_key}",
            :Accept => 'application/json'
        })

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
