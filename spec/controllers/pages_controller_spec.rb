require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe "GET #file_online" do
    it "returns http success" do
      get :file_online
      expect(response).to have_http_status(:success)
    end
  end
end
