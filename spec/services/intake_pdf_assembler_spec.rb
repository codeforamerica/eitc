require "rails_helper"

RSpec.describe IntakePdfAssembler do
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
          state: "California",
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

    it "returns expected fields from the consent PDF" do
      assembler = IntakePdfAssembler.new(vita_client)
      outfile = assembler.consent_pdf_file

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
           "ssn_last_four" => "",
           "ssn_last_four_spouse" => "",
       })
    end

    it "returns expected fields from the intake pdf" do
      assembler = IntakePdfAssembler.new(vita_client)

      outfile = assembler.intake_packet_pdf

      result = PdfForms.new.get_fields(outfile.path).each_with_object({}) do |field, hash|
        hash[field.name] = field.value
      end
      expected_values = {
        "phone" => "7207280704",
        "married" => "Yes",
        "street_address" => "111 Hay Lane",
        "state" => "California",
        "city" => "Hayward",
        "zip" => "94609",

        "first_name" => "Horse",
        "last_name" => "Oatschewer",
        "birthdate" => "5/1/1980",
        "student" => "yes",
        "blind" => "no",
        "citizen" => "yes",
        "disabled" => "no",

        "first_name_spouse" => "Goat",
        "last_name_spouse" => "Groatschewer",
        "birthdate_spouse" => "6/1/1988",
        "blind_spouse" => "no",
        "citizen_spouse" => "no",
        "disabled_spouse" => "no",
        "student_spouse" => "no",

        "name_dependent_1" => "Billy Oatschewer",
        "birthdate_dependent_1" => "6/1/2010",
        "citizen_dependent_1" => "yes",
        "disabled_dependent_1" => "yes",
        "student_dependent_1" => "no"
      }
      expected_values.each_pair do |key, value|
        expect(result[key]).to eq value
      end
    end
  end
end