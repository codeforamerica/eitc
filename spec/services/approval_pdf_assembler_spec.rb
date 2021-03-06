require "rails_helper"

RSpec.describe ApprovalPdfAssembler do
  context "an existing VitaClient" do
    let(:year) { 2018 }
    let(:vita_client) do
      vita_client = VitaClient.create(
          email: "hoatschewer@groats.horse",
          phone_number: "7207280704",
          has_spouse: "yes",
          signature: "H.O.",
          spouse_signature: "GG",
          signature_ip: "127.0.0.1",
          signed_at: DateTime.new(2019, 6, 30),
          street_address: "111 Hay Lane",
          city: "Hayward",
          state: state,
          zip: "94609")
      HouseholdMember.create(
          relation: :primary_filer,
          first_name: "Horse",
          last_name: "Oatschewer",
          birthdate: DateTime.new(1980, 5, 1),
          vita_client: vita_client,
          full_time_student: "1",
          non_citizen: "0",
          disabled: "0",
          legally_blind: "0")
      HouseholdMember.create(
          relation: :spouse,
          first_name: "Goat",
          last_name: "Groatschewer",
          birthdate: DateTime.new(1988, 6, 1),
          vita_client: vita_client,
          full_time_student: "0",
          non_citizen: "1",
          disabled: "0",
          legally_blind: "0")
      HouseholdMember.create(
          relation: :dependent,
          first_name: "Billy",
          last_name: "Oatschewer",
          birthdate: DateTime.new(2010, 6, 1),
          vita_client: vita_client,
          full_time_student: "0",
          non_citizen: "0",
          disabled: "1",
          legally_blind: "0")
      vita_client
    end

    let(:signing_request) do
      SigningRequest.create(
        vita_client: vita_client,
        federal_signature: "H.O.",
        federal_signature_spouse: "GG",
        state_signature: "H.O.",
        state_signature_spouse: "GG",
        signature_ip: "127.0.0.1",
        signed_at: DateTime.new(2019, 6, 30),
        year: year
      )
    end

    context "with a colorado return" do
      let(:state) { "Colorado" }
      it "Adds the signature to on the right lines for Colorado" do
        signing_request.signature_document.attach(
            io: File.open("spec/fixtures/pdfs/ColoradoSignatureDocuments.pdf"),
            filename: "signature_pages.pdf",
            content_type: "application/pdf"
        )
        assembler = ApprovalPdfAssembler.new(signing_request)
        outdata = assembler.approval_pdf_file
        # uncomment lines below to see output
        File.open(assembler.filename, "wb") do |file|
          file.write(outdata)
        end
      end
    end

    context "with a California return" do
      let(:state) { "California" }

      it "Adds the signature to on the right lines for Colorado" do
        signing_request.signature_document.attach(
            io: File.open("spec/fixtures/pdfs/CaliforniaSignatureDocuments.pdf"),
            filename: "signature_pages.pdf",
            content_type: "application/pdf"
        )
        assembler = ApprovalPdfAssembler.new(signing_request)
        outdata = assembler.approval_pdf_file
        # uncomment lines below to see output
        # File.open(assembler.filename, "wb") do |file|
        #   file.write(outdata)
        # end
      end
    end

    context "with a 2017 Wisconsin return" do
      let(:state) { "Wisconsin" }
      let(:year) { 2017 }

      xit "Adds signature in the right place" do
        signing_request.signature_document.attach(
            io: File.open("spec/fixtures/pdfs/WisconsinSignatureDocuments.pdf"),
            filename: "signature_pages.pdf",
            content_type: "application/pdf"
        )
        assembler = ApprovalPdfAssembler.new(signing_request)
        outdata = assembler.approval_pdf_file
        # uncomment lines below to see output
        # File.open(assembler.filename, "wb") do |file|
        #   file.write(outdata)
        # end
      end
    end

    context "with a 2016 federal only return" do
      let(:state) { "Alaska" }
      let(:year) { 2016 }

      it "Adds a signature in the right place" do
        signing_request.signature_document.attach(
            io: File.open("spec/fixtures/pdfs/FedOnly2016.pdf"),
            filename: "signature_pages.pdf",
            content_type: "application/pdf"
        )
        assembler = ApprovalPdfAssembler.new(signing_request)
        outdata = assembler.approval_pdf_file
        # uncomment lines below to see output
        # File.open(assembler.filename, "wb") do |file|
        #   file.write(outdata)
        # end
      end
    end

    context "with a 2016 California return" do
      let(:state) { "California" }
      let(:year) { 2016 }

      it "Adds a signature in the right place" do
        signing_request.signature_document.attach(
            io: File.open("spec/fixtures/pdfs/CaliforniaSignatureDocuments2016.pdf"),
            filename: "signature_pages.pdf",
            content_type: "application/pdf"
        )
        assembler = ApprovalPdfAssembler.new(signing_request)
        outdata = assembler.approval_pdf_file
        # uncomment lines below to see output
        # File.open(assembler.filename, "wb") do |file|
        #   file.write(outdata)
        # end
      end
    end
  end
end
