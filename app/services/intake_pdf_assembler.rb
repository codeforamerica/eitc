class IntakePdfAssembler
  def initialize(vita_client)
    @vita_client = vita_client
  end

  def intake_pdf_file
    run
    output_file
  end

  def filename
    time = DateTime.now.in_time_zone(@vita_client.timezone)
    @filename ||= "Intake_Packet_#{@vita_client.primary_filer.last_name}_#{time.strftime("%Y-%m-%d_%H-%M_%Z")}.pdf"
  end

  private
  def client_data
    data = {
      name: @vita_client.primary_filer.full_name,
      dob: @vita_client.primary_filer.birthdate.strftime("%-m/%-d/%Y"),
      email: @vita_client.email,
      phone_number: @vita_client.phone_number,
    }

    if @vita_client.signature.present?
      data = data.merge({
        signature: @vita_client.signature,
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
        ip_address_spouse: "IP: #{@vita_client.signature_ip}",
        signed_at_spouse: @vita_client.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"),
      })
    end

    data
  end


  def output_file
    @_output_file ||= Tempfile.new(
        filename,
        "tmp/",
        )
  end

  def source_pdf_path
    if @vita_client.state == "California"
      "app/lib/pdfs/California_14446.pdf"
    else
      "app/lib/pdfs/Colorado_14446.pdf"
    end
  end

  def run
    PdfForms.new.fill_form(source_pdf_path, output_file.path, client_data)
  end
end