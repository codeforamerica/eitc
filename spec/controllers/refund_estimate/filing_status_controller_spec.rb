require 'rails_helper'

RSpec.describe RefundEstimate::FilingStatusController, type: :controller do
  describe "GET #edit" do
    before do
      get :edit
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets the visitor_id in the session" do
      expect(session[:visitor_id].blank?).to eq false
    end

  end

  describe "POST #update" do
    context "with valid params" do
      let(:params) do
        {
          filing_status_form: { status: "single" }
        }
      end

      it "creates a new EitcEstimate" do
        session[:visitor_id] = '3x4mple'

        expect {
          post :update, params: params
        }.to change(EitcEstimate, :count).from(0).to(1)

        expect(EitcEstimate.last.visitor_id).to eq '3x4mple'
        expect(EitcEstimate.last.status).to eq 'single'
      end
    end
  end
end