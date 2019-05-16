class IntakePdfAssembler
  def initialize(vita_client)
    @vita_client = vita_client
  end

  def consent_pdf_file
    run
    consent_file
  end

  def intake_packet_pdf
    run
    output_file
  end

  def filename
    time = DateTime.now.in_time_zone(@vita_client.timezone)
    @filename ||= "Intake_Packet_#{@vita_client.primary_filer.last_name}_#{time.strftime("%Y-%m-%d_%H-%M_%Z")}.pdf"
  end

  private
  def consent_data
    data = {
      name: @vita_client.primary_filer.full_name,
      dob: @vita_client.primary_filer.birthdate.strftime("%-m/%-d/%Y"),
      email: @vita_client.email,
      phone_number: @vita_client.phone_number,
    }

    if @vita_client.signature.present?
      data = data.merge({
        signature: @vita_client.signature,
        ssn_last_four: @vita_client.last_four_ssn,
        ip_address: "IP: #{@vita_client.signature_ip}",
        signed_at: @vita_client.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z")
      })
    end

    if @vita_client.added_spouse?
      data = data.merge({
        name_spouse: @vita_client.spouse.full_name,
        dob_spouse: @vita_client.spouse.birthdate.strftime("%-m/%-d/%Y"),
      })
    end

    if @vita_client.spouse_signature.present?
      data = data.merge({
        signature_spouse: @vita_client.spouse_signature,
        ssn_last_four_spouse: @vita_client.last_four_ssn_spouse,
        ip_address_spouse: "IP: #{@vita_client.signature_ip}",
        signed_at_spouse: @vita_client.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"),
      })
    end

    data
  end

  def intake_data
    data = {
      "phone" => @vita_client.phone_number,
      "married" => yesoff(@vita_client.married?),
      "street_address" => @vita_client.street_address,
      "city" => @vita_client.city,
      "state" => @vita_client.state,
      "zip" => @vita_client.zip,
    }.merge(
        member_attributes(@vita_client.primary_filer, "")
    )
    if @vita_client.added_spouse?
      data = data.merge(member_attributes(@vita_client.spouse, "_spouse"))
    end
    @vita_client.dependents.first(4).each_with_index do | dependent, index |
      data = data.merge(member_attributes(dependent, "_dependent_#{index + 1}"))
    end
    data
  end

  def member_attributes(member, suffix)
    data = {
        "birthdate#{suffix}" => member.birthdate.strftime("%-m/%-d/%Y"),
        "student#{suffix}" => yesno(member.full_time_student?),
        "disabled#{suffix}" => yesno(member.disabled?),
        "citizen#{suffix}" => yesno(!member.non_citizen?),
    }
    if member.relation == 'dependent'
      data["name#{suffix}"] = member.full_name
    else
      data["first_name#{suffix}"] = member.first_name
      data["last_name#{suffix}"] = member.last_name
      data["blind#{suffix}"] = yesno(member.legally_blind?)
    end

    data
  end


  def output_file
    @_output_file ||= Tempfile.new('Intake_Packet', "tmp/",)
  end

  def intake_file
    @_intake_file ||= Tempfile.new('14446.pdf', "tmp/",)
  end

  def consent_file
    @_consent_file ||= Tempfile.new('13614c.pdf', "tmp/",)
  end

  def intake_pdf_path
    "app/lib/pdfs/f13614c.pdf"
  end

  def consent_pdf_path
    if @vita_client.state == "California"
      "app/lib/pdfs/California_14446.pdf"
    else
      "app/lib/pdfs/Colorado_14446.pdf"
    end
  end

  def run
    PdfForms.new.fill_form(consent_pdf_path, consent_file.path, consent_data)
    PdfForms.new.fill_form(intake_pdf_path, intake_file.path, intake_data)
    PdfForms::PdftkWrapper.new.cat([intake_file, consent_file], output_file.path)
  end

  def yesno(value)
    value ? "yes" : "no"
  end

  def yesoff(value)
    value ? "Yes" : "Off"
  end
end