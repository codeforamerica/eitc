require 'rails_helper'

RSpec.describe ReminderContactsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:params) do
        {
          reminder_contact: {
            email: "someone@example.com",
            phone_number: "1234567890"
          }
        }
      end

      it "creates a new Reminder sign up" do
        expect {
          post :create, params: params
        }.to change(ReminderContact, :count).from(0).to(1)

        expect(response).to redirect_to thanks_reminder_contact_path
      end
    end
  end

  describe "GET #thanks" do
    it "returns http success" do
      get :thanks
      expect(response).to have_http_status(:success)
    end
  end
end