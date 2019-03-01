require 'rails_helper'

RSpec.describe ResearchContact, type: :model do
  let(:visitor_id) { SecureRandom.hex(26) }
  let(:research_contact) do
    ResearchContact.create(
        visitor_id: visitor_id,
        full_name: "Hi",
        email: "mane@neigh.horse",
        phone_number: "(415) 553-7865")
  end


  describe "#assign_unique_token" do
    it "creates a unique string token on creation" do
      expect(research_contact.unique_token.length).to eq 7
    end
  end

  describe "#regenerate_unique_token" do
    it "updates the unique string token to be different" do
      expect{ research_contact.regenerate_unique_token }.to change(research_contact, :unique_token)
      expect{ research_contact.regenerate_unique_token }.to change(research_contact, :updated_at)
    end
  end

  describe "#eitc_estimate" do
    context "with a shared visitor id" do
      before do
        EitcEstimate.create(visitor_id: visitor_id)
      end

      it "returns the linked EitcEstimate" do
        expect(research_contact.eitc_estimate).to be_truthy
      end
    end

    context "without a shared visitor id" do
      before do
        EitcEstimate.create(visitor_id: SecureRandom.hex(26))
      end

      it "returns nil" do
        expect(research_contact.eitc_estimate).to eq nil
      end
    end
  end
end
