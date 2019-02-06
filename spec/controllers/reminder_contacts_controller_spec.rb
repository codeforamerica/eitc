require 'rails_helper'

RSpec.describe ReminderContactsController, type: :controller do
  describe "GET #new" do
    before do
      get :new
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets the visitor_id in the session" do
      expect(session[:visitor_id].blank?).to eq false
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:params) do
        {
          reminder_contact: {
            email: "someone@example.com",
            phone_number: "4155537865"
          }
        }
      end

      it "creates a new Reminder sign up" do
        session[:visitor_id] = '3x4mple'

        expect {
          post :create, params: params
        }.to change(ReminderContact, :count).from(0).to(1)

        expect(response).to redirect_to thanks_reminder_contact_path
        expect(ReminderContact.last.visitor_id).to eq '3x4mple'
        expect(ReminderContact.last.email).to eq 'someone@example.com'
        expect(ReminderContact.last.phone_number).to eq '4155537865'
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