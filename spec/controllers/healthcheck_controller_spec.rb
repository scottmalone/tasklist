require 'rails_helper'

RSpec.describe HealthcheckController, type: :controller do
  describe 'GET #index' do
    it "returns a 200 response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
