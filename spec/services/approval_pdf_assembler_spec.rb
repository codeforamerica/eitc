require "rails_helper"

RSpec.describe ApprovalPdfAssembler do
  context "an existing VitaClient" do
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
          state: "Colorado",
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

    it "Adds the signature to the Approval PDF" do
      assembler = ApprovalPdfAssembler.new(vita_client)
      outfile = assembler.approval_pdf_file

    end
  end
end

 # notice the << operator is on a page and not a PDF object.
