require 'rails_helper'

RSpec.describe "Healthcheck", type: :request do
  describe "GET /healthcheck" do
    it "returns a successful (200) response" do
      get "/healthcheck"
      expect(response).to have_http_status(:ok)
    end
  end
end
