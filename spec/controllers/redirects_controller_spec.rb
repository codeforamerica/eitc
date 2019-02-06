require 'rails_helper'

RSpec.describe RedirectsController, type: :controller do
  describe "GET #my_free_taxes" do
    it "returns http success" do
      get :my_free_taxes
      expect(response).to redirect_to 'https://www.myfreetaxes.com/'
    end
  end

  describe "GET #get_ahead_colorado_locations" do
    it "returns http success" do
      get :get_ahead_colorado_locations
      expect(response).to redirect_to 'https://www.garycommunity.org/tax-help#gci-tax-app-filter-form'
    end
  end
end