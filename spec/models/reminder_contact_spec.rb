require 'rails_helper'

RSpec.describe ReminderContact, type: :model do
  context "validations" do
    describe "#email_or_phone_number?" do
      it "adds an error if both email and phone_number are missing" do
        reminder_contact = ReminderContact.new(email: "", phone_number: "")
        expect(reminder_contact.valid?).to be false
        expect(reminder_contact.errors[:email]).to include "Please enter a phone number or email."
        expect(reminder_contact.errors[:phone_number]).to include "Please enter a phone number or email."
      end

      it "is valid if email is present" do
        reminder_contact = ReminderContact.new(email: "someone@example.com", phone_number: "")
        expect(reminder_contact.valid?).to be true
      end

      it "is valid if phone_number is present" do
        reminder_contact = ReminderContact.new(email: "", phone_number: "(415) 553-7865")
        expect(reminder_contact.valid?).to be true
      end
    end

    describe "#phone_number" do
      it "is valid for valid US phone numbers" do
        reminder_contact = ReminderContact.new(email: "someone@example.com", phone_number: "(415) 553-7865")
        expect(reminder_contact.valid?).to be true
      end

      it "adds an error for invalid US phone numbers" do
        reminder_contact = ReminderContact.new(email: "someone@example.com", phone_number: "(415) 553-786")
        expect(reminder_contact.valid?).to be false
        expect(reminder_contact.errors[:phone_number]).to be_present
      end
    end

    describe "#email" do
      it "is valid for valid email strings" do
        reminder_contact = ReminderContact.new(email: "someone@example.com", phone_number: "(415) 553-7865")
        expect(reminder_contact.valid?).to be true
      end

      it "adds an error for invalid email strings" do
        reminder_contact = ReminderContact.new(email: "someoneexample.com", phone_number: "(415) 553-7865")
        expect(reminder_contact.valid?).to be false
        expect(reminder_contact.errors[:email]).to be_present
      end
    end
  end
end
