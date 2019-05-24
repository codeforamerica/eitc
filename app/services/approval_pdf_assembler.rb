class ApprovalPdfAssembler
  def initialize(signing_request)
    @signing_request = signing_request
  end

  def approval_pdf_file
    run
  end

  def filename
    time = DateTime.now.in_time_zone(@signing_request.vita_client.timezone)
    @filename ||= "Signature_Pages_#{@signing_request.vita_client.primary_filer.last_name}_#{time.strftime("%Y-%m-%d_%H-%M_%Z")}.pdf"
  end

  private

  def federal_signature_overlay_path
    "tmp/fed_signature_overlay.pdf"
  end

  def write_federal_signature_overlay
    signing_request = @signing_request
    Prawn::Document.generate(federal_signature_overlay_path) do
      text_box signing_request.federal_signature, at: [70, 310]
      text_box "IP: #{signing_request.signature_ip}", at: [70, 294], size: 9
      text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [70 + 64, 294], size: 9
      if signing_request.federal_signature_spouse.present?
        text_box signing_request.federal_signature_spouse, at: [92, 205]
        text_box "IP: #{signing_request.signature_ip}", at: [92, 205 - 16], size: 9
        text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [92 + 64, 205 - 16], size: 9
      end
    end
  end

  def colorado_signature_overlay_path
    "tmp/co_signature_overlay.pdf"
  end

  def write_colorado_signature_overlay
    signing_request = @signing_request
    signature_x = 1
    signature_y = 225
    signature_metadata_y = signature_y - 13
    Prawn::Document.generate(colorado_signature_overlay_path) do
      text_box signing_request.state_signature, at: [signature_x, signature_y], size: 11
      text_box "IP: #{signing_request.signature_ip}", at: [signature_x, signature_metadata_y], size: 8
      text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_x + 64, signature_metadata_y], size: 9
      if signing_request.state_signature_spouse.present?
        signature_spouse_x = signature_x + 281
        text_box signing_request.state_signature_spouse, at: [signature_spouse_x, signature_y], size: 11
        text_box "IP: #{signing_request.signature_ip}", at: [signature_spouse_x, signature_metadata_y], size: 8
        text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_spouse_x + 64, signature_metadata_y], size: 9
      end
    end
  end

  def california_signature_overlay_path
    "tmp/ca_signature_overlay.pdf"
  end

  def write_california_signature_overlay
    signing_request = @signing_request
    signature_x = 65
    signature_y = 319
    signature_metadata_y = signature_y - 13
    Prawn::Document.generate(california_signature_overlay_path) do
      text_box signing_request.state_signature, at: [signature_x, signature_y], size: 11
      text_box "IP: #{signing_request.signature_ip}", at: [signature_x, signature_metadata_y], size: 8
      text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_x + 64, signature_metadata_y], size: 9
      if signing_request.state_signature_spouse.present?
        signature_spouse_x = signature_x + 37
        signature_spouse_y = signature_y - 104
        signature_metadata_y = signature_spouse_y - 11
        text_box signing_request.state_signature_spouse, at: [signature_spouse_x, signature_spouse_y], size: 11
        text_box "IP: #{signing_request.signature_ip}", at: [signature_spouse_x, signature_metadata_y], size: 8
        text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_spouse_x + 64, signature_metadata_y], size: 9
      end
    end
  end

  def download_signature_document
    @signing_request.signature_document.download
  end

  def unsigned_pdf_file
    @_unsigned_pdf_file ||= Tempfile.new("unsigned.pdf", "tmp/", encoding: "ascii-8bit")
  end

  def run
    unsigned_pdf_file << download_signature_document
    signature_doc = CombinePDF.load(unsigned_pdf_file.path)
    write_federal_signature_overlay
    federal_signature_overlay = CombinePDF.load federal_signature_overlay_path
    signature_doc.pages[0] << federal_signature_overlay.pages[0]
    if @signing_request.vita_client.state == "California"
      write_california_signature_overlay
      california_signature_overlay = CombinePDF.load california_signature_overlay_path
      signature_doc.pages[1] << california_signature_overlay.pages[0]
    else
      write_colorado_signature_overlay
      colorado_signature_overlay = CombinePDF.load colorado_signature_overlay_path
      signature_doc.pages[1] << colorado_signature_overlay.pages[0]
    end

    signature_doc.to_pdf
  end
end