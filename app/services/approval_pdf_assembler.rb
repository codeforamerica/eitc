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

  def write_federal_signature_overlay
    signing_request = @signing_request
    Prawn::Document.generate(signature_overlay_path("fed")) do
      case signing_request.year
      when 2017
        signature_y = 275
      when 2016
        signature_y = 275
      else
        signature_y = 310
      end
      signature_x = 70
      signature_metadata_y = signature_y - 16
      spouse_signature_x = signature_x + 22

      text_box signing_request.federal_signature, at: [signature_x, signature_y]
      text_box "IP: #{signing_request.signature_ip}", at: [signature_x, signature_y - 16], size: 8
      text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_x + 69, signature_metadata_y], size: 8
      if signing_request.federal_signature_spouse.present?
        text_box signing_request.federal_signature_spouse, at: [spouse_signature_x, signature_y - 105]
        text_box "IP: #{signing_request.signature_ip}", at: [spouse_signature_x, signature_metadata_y - 105], size: 8
        text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [spouse_signature_x + 69, signature_metadata_y - 105], size: 8
      end
    end
  end

  def write_colorado_signature_overlay
    signing_request = @signing_request
    signature_x = 1
    signature_y = 225
    signature_metadata_y = signature_y - 13
    Prawn::Document.generate(signature_overlay_path("co")) do
      text_box signing_request.state_signature, at: [signature_x, signature_y], size: 11
      text_box "IP: #{signing_request.signature_ip}", at: [signature_x, signature_metadata_y], size: 8
      text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_x + 69, signature_metadata_y], size: 9
      if signing_request.state_signature_spouse.present?
        signature_spouse_x = signature_x + 281
        text_box signing_request.state_signature_spouse, at: [signature_spouse_x, signature_y], size: 11
        text_box "IP: #{signing_request.signature_ip}", at: [signature_spouse_x, signature_metadata_y], size: 8
        text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_spouse_x + 69, signature_metadata_y], size: 9
      end
    end
  end

  def write_california_signature_overlay
    signing_request = @signing_request
    signature_x = 65
    signature_y = 319
    signature_y -= 20 if signing_request.year == 2016
    signature_metadata_y = signature_y - 13
    Prawn::Document.generate(signature_overlay_path("ca")) do
      text_box signing_request.state_signature, at: [signature_x, signature_y], size: 11
      text_box "IP: #{signing_request.signature_ip}", at: [signature_x, signature_metadata_y], size: 8
      text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_x + 69, signature_metadata_y], size: 9
      if signing_request.state_signature_spouse.present?
        signature_spouse_x = signature_x + 37
        signature_spouse_y = signature_y - 104
        signature_spouse_y -= 6 if signing_request.year == 2016
        signature_metadata_y = signature_spouse_y - 11
        text_box signing_request.state_signature_spouse, at: [signature_spouse_x, signature_spouse_y], size: 11
        text_box "IP: #{signing_request.signature_ip}", at: [signature_spouse_x, signature_metadata_y], size: 8
        text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_spouse_x + 69, signature_metadata_y], size: 9
      end
    end
  end

  def write_wisconsin_signature_overlay
    signing_request = @signing_request
    signature_x = 38
    signature_y = 510
    signature_metadata_y = signature_y - 13
    Prawn::Document.generate(signature_overlay_path("wi")) do
      text_box signing_request.state_signature, at: [signature_x, signature_y], size: 11
      text_box "IP: #{signing_request.signature_ip}", at: [signature_x, signature_metadata_y], size: 8
      text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_x + 69, signature_metadata_y], size: 9
      if signing_request.state_signature_spouse.present?
        signature_spouse_x = signature_x + 210
        signature_spouse_y = signature_y
        signature_metadata_y = signature_spouse_y - 13
        text_box signing_request.state_signature_spouse, at: [signature_spouse_x, signature_spouse_y], size: 11
        text_box "IP: #{signing_request.signature_ip}", at: [signature_spouse_x, signature_metadata_y], size: 8
        text_box signing_request.local_signed_at.strftime("%-m/%-d/%Y %-I:%M%p %Z"), at: [signature_spouse_x + 69, signature_metadata_y], size: 9
      end
    end
  end

  def signature_overlay_path(prefix)
    "tmp/#{prefix}_signature_overlay.pdf"
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
    federal_signature_overlay = CombinePDF.load signature_overlay_path("fed")
    signature_doc.pages[0] << federal_signature_overlay.pages[0]
    case @signing_request.vita_client.state
    when "Alaska"
      # do nothing
    when "California"
      write_california_signature_overlay
      california_signature_overlay = CombinePDF.load signature_overlay_path("ca")
      signature_doc.pages[1] << california_signature_overlay.pages[0]
    when "Wisconsin"
      write_wisconsin_signature_overlay
      wisconsin_signature_overlay = CombinePDF.load signature_overlay_path("wi")
      signature_doc.pages[1] << wisconsin_signature_overlay.pages[0]
    else
      write_colorado_signature_overlay
      colorado_signature_overlay = CombinePDF.load signature_overlay_path("co")
      signature_doc.pages[1] << colorado_signature_overlay.pages[0]
    end

    signature_doc.to_pdf
  end
end