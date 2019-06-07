class FrontService
  include Singleton

  def initialize
    @url = CredentialsHelper.environment_credential_for_key(:front_custom_channel_url)
    @api_key = CredentialsHelper.environment_credential_for_key(:front_api_key)
  end

  def send_message_with_attachment(attachment)
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
    return unless @url && @api_key

    attachments = []

    pdf_assembler = IntakePdfAssembler.new(vita_client)
    attachments.push stringfile(pdf_assembler.intake_packet_pdf.read, pdf_assembler.filename, 'application/pdf')

    vita_client.tax_documents.each do |tax_doc|
      attachments.push stringfile(tax_doc.blob.download, tax_doc.blob.filename, tax_doc.blob.content_type)
    end
    vita_client.identity_documents.each do |identity_doc|
      attachments.push stringfile(identity_doc.blob.download, identity_doc.blob.filename, identity_doc.blob.content_type)
    end

    body = "New <strong>#{vita_client.looks_fake? ? "probably fake " : ""}#{vita_client.state}</strong> intake form received from #{vita_client.full_source}<br>"\
           "<em>Referrer: #{vita_client.referrer || "No referrer"}</em><br>"

    if !vita_client.ready_to_upload_docs?
      body += "<p><strong>This client was not ready to upload documents.</strong></p>"
    end

    body += "<p>Wants help with:</p><ul>"
    vita_client.tax_years.each do |year|
      body += "<li>#{year}#{vita_client.years_already_filed.include?(year) ? " (Already filed)" : "" }</li>"
    end
    body += "</ul>"

    if vita_client.already_filed?
      body+= "<p><em>For years they already filed, they'd like help with:<em></p> <p>#{vita_client.already_filed_needs}</p>"
    end

    if vita_client.dependents.count > 4
      body += "<p><strong>Alert! More than 4 dependents!</strong></p>"
    end

    body += "<br>"\
            "Primary Filer: #{vita_client.primary_filer.first_name} #{vita_client.primary_filer.last_name}<br>"\
            "<ul>"\
            "<li>Date of Birth: #{vita_client.primary_filer.birthdate.strftime("%m/%d/%Y")}</li>"\
            "<li>Email: #{vita_client.email}</li>"\
            "<li>Address: #{vita_client.street_address} #{vita_client.city} #{vita_client.state} #{vita_client.zip}</li>"\
            "<li>Phone Number: #{vita_client.formatted_phone_number}</li>"\
            "<li>Can you receive text messages?: #{vita_client.sms_enabled ? 'yes' : 'no'}</li>"\
            "<li>Are you a full-time student?: #{vita_client.primary_filer.full_time_student? ? 'yes' : 'no'}</li>"\
            "<li>Are you a non-citizen?: #{vita_client.primary_filer.non_citizen? ? 'yes' : 'no'}</li>"\
            "<li>Are you disabled?: #{vita_client.primary_filer.disabled? ? 'yes' : 'no'}</li>"\
            "<li>Are you legally blind?: #{vita_client.primary_filer.legally_blind? ? 'yes' : 'no'}</li>"\
            "<li>Are you married?: #{vita_client.married? ? 'yes' : 'no'}</li>"\
            "<li>Do you have any dependents?: #{vita_client.dependents? ? 'yes' : 'no'}</li>"\
            "<li>Is anyone in your household self employed?: #{vita_client.anyone_self_employed ? 'yes' : 'no'}</li>"\
            "<li>Additional Info: #{vita_client.anything_else}</li>"\
            "</ul>"

    if vita_client.married? && vita_client.spouse.present?
      body += "<br>"\
            "Spouse: #{vita_client.spouse.first_name} #{vita_client.spouse.last_name}<br>"\
            "<ul>"\
            "<li>Date of Birth: #{vita_client.spouse.birthdate.strftime("%m/%d/%Y")}</li>"\
            "<li>Are they a full-time student?: #{vita_client.spouse.full_time_student? ? 'yes' : 'no'}</li>"\
            "<li>Are they a non-citizen?: #{vita_client.spouse.non_citizen? ? 'yes' : 'no'}</li>"\
            "<li>Are they disabled?: #{vita_client.spouse.disabled? ? 'yes' : 'no'}</li>"\
            "<li>Are they legally blind?: #{vita_client.spouse.legally_blind? ? 'yes' : 'no'}</li>"\
            "</ul>"
    end

    if vita_client.dependents? && vita_client.dependents.present?
      vita_client.dependents.each_with_index do |dependent, index|
        body += "<br>"\
            "Dependent ##{index+1}: #{dependent.first_name} #{dependent.last_name}<br>"\
            "<ul>"\
            "<li>Date of Birth: #{dependent.birthdate.strftime("%m/%d/%Y")}</li>"\
            "<li>Are they a full-time student?: #{dependent.full_time_student? ? 'yes' : 'no'}</li>"\
            "<li>Are they a non-citizen?: #{dependent.non_citizen? ? 'yes' : 'no'}</li>"\
            "<li>Are they disabled?: #{dependent.disabled? ? 'yes' : 'no'}</li>"\
            "<li>Are they legally blind?: #{dependent.legally_blind? ? 'yes' : 'no'}</li>"\
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
            :sender => sender_data(vita_client),
            :subject => front_subject(vita_client)
        },
        :headers => {
            'Content-Type' => 'multipart/form-data',
            :Authorization => "Bearer #{@api_key}",
            :Accept => 'application/json'
        })

    response = request.execute
  end

  def send_signed_approval(signing_request)
    return unless @url && @api_key

    vita_client = signing_request.vita_client

    attachments = []

    pdf_assembler = ApprovalPdfAssembler.new(signing_request)
    attachments.push stringfile(pdf_assembler.approval_pdf_file, pdf_assembler.filename, 'application/pdf')

    body = "New <strong>#{vita_client.looks_fake? ? "probably fake " : ""}#{vita_client.state}</strong> signed approval form received from #{vita_client.full_source}<br>"\
           "<em>Referrer: #{vita_client.source || "No referrer"}</em><br>"

    body += "<br>"\
            "Primary Filer: #{vita_client.primary_filer.first_name} #{vita_client.primary_filer.last_name}<br>"\
            "<ul>"\
            "<li>Date of Birth: #{vita_client.primary_filer.birthdate.strftime("%m/%d/%Y")}</li>"\
            "<li>Email: #{vita_client.email}</li>"\
            "<li>Address: #{vita_client.street_address} #{vita_client.city} #{vita_client.zip}</li>"\
            "<li>Phone Number: #{vita_client.formatted_phone_number}</li>"\
            "</ul>"



    request = RestClient::Request.new(
        :method => :post,
        :url => @url,
        :payload => {
            :multipart => true,
            :attachments => attachments,
            :body => body,
            :body_format => 'html',
            :sender => sender_data(vita_client),
            :subject => front_approval_subject(vita_client)
        },
        :headers => {
            'Content-Type' => 'multipart/form-data',
            :Authorization => "Bearer #{@api_key}",
            :Accept => 'application/json'
        })

    response = request.execute
  end

  def front_subject(vita_client)
    return "Fake #{vita_client.state} Intake" if vita_client.looks_fake?
    "New #{vita_client.state} Intake"
  end

  def front_approval_subject(vita_client)
    return "Fake #{vita_client.state} Signed Approval" if vita_client.looks_fake?
    "New #{vita_client.state} Signed Approval"
  end

  private

  def sender_data(vita_client)
    contact_id = find_or_create_contact(
        :name => vita_client.primary_filer.full_name,
        :email => vita_client.email,
        :phone => vita_client.tel_link_phone_number)
    data = {
      name: vita_client.primary_filer.full_name,
      handle: vita_client.email
    }
    if contact_id.present?
      data = data.merge(contact_id: contact_id)
    end

    data
  end

  def find_contact(email:, phone:)
    contact_aliases = []
    contact_aliases << "alt:email:#{email}" if email
    contact_aliases << "alt:phone:#{format_phone_number(phone)}" if phone

    contact_aliases.each do |contact_alias|
      response = RestClient.get(
        "https://api2.frontapp.com/contacts/#{contact_alias}",
        {
          'Content-Type' => 'application/json',
          :Authorization => "Bearer #{@api_key}",
          :Accept => 'application/json'
        }
      )

      if response
        return JSON.parse(response.body)
      end
    end
  rescue RestClient::BadRequest, RestClient::NotFound
    nil
  end

  def format_phone_number(phone_number_string)
    return unless phone_number_string && phone_number_string.present?

    cleaned_string = phone_number_string.gsub(/\D+/, "")
    if (cleaned_string.length == 11) && (cleaned_string[0] == '1')
      "+" + cleaned_string
    elsif cleaned_string.length == 10
      "+1" + cleaned_string
    end
  end

  def find_or_create_contact(name:, email:, phone:)
    existing_contact = find_contact(email: email, phone: phone)
    return existing_contact['id'] if existing_contact

    response = RestClient.post(
      "https://api2.frontapp.com/contacts",
      {
        :name => name,
        :handles => [
          {
            :handle => email,
            :source => 'email',
          },
          {
            :handle => phone,
            :source => 'phone',
          },
        ],
      }.to_json,
      {
        'Content-Type' => 'application/json',
        :Authorization => "Bearer #{@api_key}",
        :Accept => 'application/json'
      }
    )

    JSON.parse(response.body)['id']
  rescue RestClient::Conflict
    nil
  end

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
