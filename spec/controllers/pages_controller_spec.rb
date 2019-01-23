require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #about" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #help_sites" do
    it "returns http success" do
      get :help_sites
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #file_online" do
    it "returns http success" do
      get :file_online
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #reminder" do
    it "returns http success" do
      get :reminder
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #file_late" do
    it "returns http success" do
      get :file_late
      expect(response).to have_http_status(:success)
    end
  end
end
