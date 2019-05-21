class ApprovalPdfAssembler
  def initialize(vita_client)
    @vita_client = vita_client
  end

  def approval_pdf_file
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

  def federal_signature_overlay_path
    "tmp/fed_signature_overlay.pdf"
  end

  def write_federal_signature_overlay
    vita_client = @vita_client
    Prawn::Document.generate(federal_signature_overlay_path) do
      text_box vita_client.signature, at: [70, 310]
      text_box "IP: #{vita_client.signature_ip}", at: [70, 294], size: 9
      text_box vita_client.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [70 + 64, 294], size: 9
      if vita_client.spouse_signature.present?
        text_box vita_client.spouse_signature, at: [92, 205]
        text_box "IP: #{vita_client.signature_ip}", at: [92, 205 - 16], size: 9
        text_box vita_client.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [92 + 64, 205 - 16], size: 9
      end
    end
  end

  def colorado_signature_overlay_path
    "tmp/co_signature_overlay.pdf"
  end

  def write_colorado_signature_overlay
    vita_client = @vita_client
    signature_x = 1
    signature_y = 225
    signature_metadata_y = signature_y - 13
    Prawn::Document.generate(colorado_signature_overlay_path) do
      text_box vita_client.signature, at: [signature_x, signature_y], size: 11
      text_box "IP: #{vita_client.signature_ip}", at: [signature_x, signature_metadata_y], size: 8
      text_box vita_client.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_x + 64, signature_metadata_y], size: 9
      if vita_client.spouse_signature.present?
        spouse_signature_x = signature_x + 281
        text_box vita_client.spouse_signature, at: [spouse_signature_x, signature_y], size: 11
        text_box "IP: #{vita_client.signature_ip}", at: [spouse_signature_x, signature_metadata_y], size: 8
        text_box vita_client.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [spouse_signature_x + 64, signature_metadata_y], size: 9
      end
    end
  end

  def california_signature_overlay_path
    "tmp/ca_signature_overlay.pdf"
  end

  def write_california_signature_overlay
    vita_client = @vita_client
    signature_x = 1
    signature_y = 225
    signature_metadata_y = signature_y - 13
    Prawn::Document.generate(california_signature_overlay_path) do
      text_box vita_client.signature, at: [signature_x, signature_y], size: 11
      text_box "IP: #{vita_client.signature_ip}", at: [signature_x, signature_metadata_y], size: 8
      text_box vita_client.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_x + 64, signature_metadata_y], size: 9
      if vita_client.spouse_signature.present?
        spouse_signature_x = signature_x + 281
        text_box vita_client.spouse_signature, at: [spouse_signature_x, signature_y], size: 11
        text_box "IP: #{vita_client.signature_ip}", at: [spouse_signature_x, signature_metadata_y], size: 8
        text_box vita_client.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [spouse_signature_x + 64, signature_metadata_y], size: 9
      end
    end
  end

  def output_path
    "tmp/SignedDoc.pdf"
  end

  def output_file
    File.open(output_path, "rb")
  end

  def signature_pdf_path
    "app/lib/pdfs/SignatureDocumentsPrint.pdf"
  end

  def run
    signature_doc = CombinePDF.load(signature_pdf_path)
    write_federal_signature_overlay
    federal_signature_overlay = CombinePDF.load federal_signature_overlay_path
    signature_doc.pages[0] << federal_signature_overlay.pages[0]
    if @vita_client.state == "California"
      write_california_signature_overlay
      california_signature_overlay = CombinePDF.load california_signature_overlay_path
      signature_doc.pages[1] << california_signature_overlay.pages[0]
    else
      write_colorado_signature_overlay
      colorado_signature_overlay = CombinePDF.load colorado_signature_overlay_path
      signature_doc.pages[1] << colorado_signature_overlay.pages[0]
    end
    signature_doc.save(output_path)
  end

end