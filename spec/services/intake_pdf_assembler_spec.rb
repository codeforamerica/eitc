require "rails_helper"

RSpec.describe IntakePdfAssembler do
  context "an existing VitaClient" do
    it "returns expected fields from the PDF" do
      vita_client = VitaClient.create(
        state: "California",
        email: "hoatschewer@groats.horse",
        phone_number: "7207280704",
        has_spouse: "yes",
        signature: "H.O.",
        spouse_signature: "GG",
        signature_ip: "127.0.0.1",
        signed_at: DateTime.new(2019, 6, 30)
      )
      HouseholdMember.create(
        relation: :primary_filer,
        first_name: "Horse",
        last_name: "Oatschewer",
        birthdate: DateTime.new(1980, 5, 1),
        vita_client: vita_client,
      )
      HouseholdMember.create(
        relation: :spouse,
        first_name: "Goat",
        last_name: "Groatschewer",
        birthdate: DateTime.new(1988, 6, 1),
        vita_client: vita_client,
      )
      assembler = IntakePdfAssembler.new(vita_client)
      outfile = assembler.intake_pdf_file

      result = PdfForms.new.get_fields(outfile.path).each_with_object({}) do |field, hash|
        hash[field.name] = field.value
      end

      expect(result).to eq({
           "dob" => "5/1/1980",
           "email" => "hoatschewer@groats.horse",
           "ip_address" => "IP: 127.0.0.1",
           "ip_address_spouse" => "IP: 127.0.0.1",
           "name" => "Horse Oatschewer",
           "phone_number" => "7207280704",
           "signature" => "H.O.",
           "signature_spouse" => "GG",
           "signed_at" => "6/29/2019 5:00PM PDT",
           "signed_at_spouse" => "6/29/2019 5:00PM PDT",
           "dob_spouse" => "6/1/1988",
           "name_spouse" => "Goat Groatschewer",
           "ssn_last_four" => nil,
           "ssn_last_four_spouse" => nil,
       })
    end
  end
end